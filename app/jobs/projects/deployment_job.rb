require 'base64'
require 'json'

class Projects::DeploymentJob < ApplicationJob

  def perform(deployment)
    cluster_kubeconfig = deployment.project.cluster.kubeconfig
    project = deployment.project
    
    # Upload container registry secrets
    runner = Cli::RunAndLog.new(deployment)
    kubectl = K8::Kubectl.new(cluster_kubeconfig, runner)
    upload_registry_secrets(kubectl, deployment)

    # For each of the projects services
    project.services.each do |service|
      if service.background_service?
        apply_deployment(service, kubectl)
      elsif service.cron_job?
        apply_cron_job(service, kubectl)
      elsif service.web_service?
        apply_deployment(service, kubectl)
        apply_service(service, kubectl)
        apply_ingress(service, kubectl)
      end
    end

    deployment.completed!
  rescue StandardError => e
    deployment.info "Deployment failed: #{e.message}"
    deployment.failed!
  end

  def apply_deployment(service, kubectl)
    deployment_yaml = K8::Stateless::Deployment.new(service).to_yaml
    kubectl.apply_yaml(deployment_yaml)
  end

  def apply_cron_job(service, kubectl)
    cron_job_yaml = K8::Stateless::CronJob.new(service).to_yaml
    kubectl.apply_yaml(cron_job_yaml)
  end

  def apply_service(service, kubectl)
    service_yaml = K8::Stateless::Service.new(service).to_yaml
    kubectl.apply_yaml(service_yaml)
  end

  def apply_ingress(service, kubectl)
    ingress_yaml = K8::Stateless::Ingress.new(service).to_yaml
    kubectl.apply_yaml(ingress_yaml)
  end

  def upload_registry_secrets(kubectl, deployment)
    project = deployment.project
    docker_config_json = create_docker_config_json(project.user.github_username, project.user.github_access_token)
    secret_yaml = K8::Secrets::RegistrySecret.new(project, docker_config_json).to_yaml
    kubectl.apply_yaml(secret_yaml)
  end

  def create_docker_config_json(username, password)
    # First base64 encoding
    auth_value = Base64.strict_encode64("#{username}:#{password}")

    # Create the JSON structure
    docker_config = {
      "auths" => {
        "ghcr.io" => {
          "auth" => auth_value
        }
      }
    }

    # Second base64 encoding of the entire JSON
    Base64.strict_encode64(JSON.generate(docker_config))
  end
end