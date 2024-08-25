class Projects::BaseController < ApplicationController
  before_action :set_project

  private
  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end