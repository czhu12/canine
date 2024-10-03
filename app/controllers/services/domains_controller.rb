# frozen_string_literal: true

class Services::DomainsController < Services::BaseController
  before_action :set_service

  def create
    @domain = @service.domains.new(domain_params)
    respond_to do |format|
      if @domain.save
        Services::AddDomainJob.perform_later(@domain)
        format.html { redirect_to project_path(@project), notice: "Domain was successfully added." }
        format.json { render :show, status: :created, domain: @domain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
  end

  def destroy
    @domain = @project.domains.find(params[:id])
    @domain.destroy

    respond_to(&:turbo_stream)
  end

  private

  def domain_params
    params.require(:domain).permit(:domain_name)
  end
end