class Account::ApiController < Account::BaseController
  layout 'account'

  def show
    render locals: { account: current_account }
  end
end
