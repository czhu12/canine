class Services::AddDomainJob < ApplicationJob
  def perform(domain)
    cluster = domain.cluster
    runner = Cli::RunAndLog.new(cluster)
    K8::Kubectl.new(cluster.kubeconfig, runner).apply_yaml(K8::Stateless::Ingress.new(domain.project_service).to_yaml)
  end
end