module AuthorizeUser
  extend ActiveSupport::Concern

  NotAuthorized = Class.new StandardError

  included do
    before_action :authorize_user
  end

  def authorize_user
    fail NotAuthenticated unless current_user.present?
  end
end