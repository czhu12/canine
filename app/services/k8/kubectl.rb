class K8::Kubectl
  attr_reader :kubeconfig
  def initialize(kubeconfig)
    @kubeconfig = kubeconfig
  end

  def self.from_project(project)
    new(project.cluster.kubeconfig)
  end

  def with_kube_config
    Tempfile.open(['kubeconfig', '.yaml']) do |kubeconfig_file|
      kubeconfig_file.write(kubeconfig.to_yaml)
      kubeconfig_file.flush
      yield kubeconfig_file
    end
  end

  def apply_yaml(yaml_content)
    with_kube_config do
      # Create a temporary file for the YAML content
      Tempfile.open(['k8s', '.yaml']) do |yaml_file|
        yaml_file.write(yaml_content)
        yaml_file.flush

        # Apply the YAML file to the cluster using the kubeconfig file
        stdout, stderr, status = Open3.capture3("kubectl --kubeconfig=#{kubeconfig_file.path} apply -f #{yaml_file.path}")
        
        # Print the output and any errors to the console
        puts "\n\n=== kubectl apply output ==="
        puts stdout unless stdout.empty?
        puts stderr unless stderr.empty?
        puts "=== End of output ===\n"
        unless status.success?
          raise "Kubectl apply command failed: #{stderr}"
        end
      end
    end
  end


  def run(command)
    with_kube_config do |kubeconfig_file|
      full_command = "kubectl --kubeconfig=#{kubeconfig_file.path} #{command}"
      Rails.logger.info("Running command: #{full_command}")
      stdout, stderr, status = Open3.capture3(full_command)
      return stdout, stderr, status
    end
  end
end
