class Account::LandingsController < Account::BaseController
  layout 'account'

  def index
    render locals: { landings: landings }
  end

  def new
    render locals: { landing: build_landing }
  end

  def edit
    redirect_to address_landing_settings_url(params[:id])
  end

  def show
    redirect_to landing_leads_path(params[:id])
  end

  def create
    landing = create_landing!
    redirect_to landing_editor_path landing.default_variant.uuid
  rescue ActiveRecord::RecordInvalid => err
    Rails.logger.error err
    render 'new', locals: { landing: err.record }
  end

  def destroy
    landing = current_account.landings.find params[:id]
    landing.destroy!
    redirect_to account_url
  end

  private

  def current_variant
    nil
  end

  def build_landing
    current_account.landings.build
  end

  def landings
    current_account.landings.ordered
  end

  def permitted_params
    params.require(:landing).permit(:title, :path, :head_title, :meta_keywords, :meta_description)
  end

  def create_landing!
    landing = build_landing
    landing.assign_attributes permitted_params

    landing.transaction do
      landing.save!
      v = landing.variants.create!
      SectionsUpdater.new(v, regenerate_uuid: true).update(LandingExamples::EXAMPLE1)
    end

    landing
  end
end
