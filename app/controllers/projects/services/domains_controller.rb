# frozen_string_literal: true

class Projects::Services::DomainsController < Projects::Services::BaseController
  def create
    @domain = @service.domains.new(domain_params)
    respond_to do |format|
      if @domain.save
        Services::AddDomainJob.perform_later(@domain)
        format.html { redirect_to project_path(@project), notice: "Domain was successfully added." }
        format.json { render :show, status: :created, domain: @domain }
        format.turbo_stream { render :create }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
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
