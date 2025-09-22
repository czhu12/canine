class Local::PortainerController < ApplicationController
  skip_before_action :authenticate_user!

  def github_oauth
    result = Portainer::Login.execute(
      password: params[:code],
      account: current_account,
    )
    if result.success?
      flash[:notice] = "The Portainer configuration has been updated"
    else
      flash[:error] = result.message
    end
    redirect_to root_path
  end
end
