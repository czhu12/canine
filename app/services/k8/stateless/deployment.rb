class K8::Stateless::Deployment < K8::Base
  attr_accessor :project, :name, :port, :environment_variables

  def initialize(project)
    @project = project
    @name = project.name
    @port = 3000
    @environment_variables = project.environment_variables
  end
end