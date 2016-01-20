class LandingsController < ApplicationController
  include CurrentAccountSupport

  def show
    landing = current_account.landings.find params[:id]

    render locals: { landing: landing }
  end
end
