class K8::Helm::Client
  CHARTS = YAML.load_file(Rails.root.join('resources', 'helm', 'charts.yml'))
  include K8::Kubeconfig
  attr_reader :kubeconfig, :runner

  def initialize(kubeconfig, runner)
    @kubeconfig = kubeconfig
    @runner = runner
  end

  def self.fetch_package_details(name:, package_id:)
    result = AddOns::HelmChartDetails.execute(query: name)
    if result.failure?
      raise "Failed to connect to helm repository."
    end
    package = result.response['packages'].find { |package| package['package_id'] == package_id }
    raise "Package not found in helm repository." if package.blank?
    package
  end

  def self.default_values_yaml(package_id, package_name)
    # Add repository if needed
    package = K8::Helm::Client.fetch_package_details(name: package_name, package_id: package_id)
    add_repo("helm repo add #{package['repository']['organization_name']} #{package['repository']['url']}")

    Tempfile.create([ 'values', '.yaml' ]) do |values_file|
      command = "helm show values #{package['repository']['organization_name']}/#{package_name} > #{values_file.path}"
      runner.(command)
      output = values_file.read
      raise "Helm show values failed with exit status #{exit_status}" unless exit_status.success?
      output
    end
  end

  def ls
    with_kube_config do |kubeconfig_file|
      command_output = `helm ls --all-namespaces --kubeconfig=#{kubeconfig_file.path} -o yaml`
      output = YAML.safe_load(command_output)
    end
  end

  def self.repo_update!
    command = "helm repo update"
    exit_status = runner.(command)
    raise "Helm repo update failed with exit status #{exit_status}" unless exit_status.success?
    exit_status
  end

  def self.add_repo(command)
    exit_status = runner.(command)
    raise "Helm add repo failed with exit status #{exit_status}" unless exit_status.success?
    exit_status
  end

  def install(name, chart_url, values: {}, namespace: 'default')
    with_kube_config do |kubeconfig_file|
      # Load the values.yaml file
      # Create a temporary file with the values.yaml content
      Tempfile.create([ 'values', '.yaml' ]) do |values_file|
        values_file.write(values.to_yaml)
        values_file.flush

        command = "helm upgrade --install #{name} #{chart_url} -f #{values_file.path} --namespace #{namespace}"
        exit_status = runner.(command, envs: { "KUBECONFIG" => kubeconfig_file.path })
        raise "Helm install failed with exit status #{exit_status}" unless exit_status.success?
        exit_status
      end
    end
  end

  def uninstall(name, namespace: 'default')
    with_kube_config do |kubeconfig_file|
      command = "helm uninstall #{name} --namespace #{namespace}"
      exit_status = runner.(command, envs: { "KUBECONFIG" => kubeconfig_file.path })
      raise "Helm uninstall failed with exit status #{exit_status}" unless exit_status.success?
      exit_status
    end
  end
end
