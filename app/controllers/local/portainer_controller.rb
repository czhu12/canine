class Local::PortainerController < ApplicationController
  skip_before_action :authenticate_user!

  def github_oauth
    account = current_account || Account.find_by(id: session[:account_id])
    provider_url = account.stack_manager&.provider_url || session[:provider_url]
    result = Portainer::Login.execute(
      password: params[:code],
      account:,
      provider_url:
    )
    path = if result.success?
      sign_in(result.user)
      root_path
    else
      flash[:error] = result.message
      account_sign_in_path(account.slug)
    end
    redirect_to path
  end
end
