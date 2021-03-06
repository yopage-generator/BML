module HandleErrors
  extend ActiveSupport::Concern

  DEFAULT_HTTP_STATUS = 500
  NOT_FOUND_ERROR = OpenStruct.new(
    http_status: 404,
    title: 'Not Found',
    message: 'Страница не найдена'
  )

  included do
    # SiteError указываем первым, таким образом он в переборе ошибки будет последним и не поймает
    # наследованные классы
    #
    rescue_from SiteError,                    with: :rescue_site_error
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from NoCurrentAccount,             with: :rescue_no_current_account
    rescue_from UnknownSite,                  with: :rescue_site_error
    rescue_from NotAuthenticated,             with: :rescue_not_authenticated
    rescue_from NotAuthorized,                with: :rescue_not_authorized
    rescue_from Pundit::NotAuthorizedError,   with: :rescue_not_authorized
    rescue_from ActionController::UnknownFormat,     with: :rescue_unknown_format
    rescue_from ActionController::MissingFile,       with: :rescue_not_found
  end

  private

  def rescue_unknown_format
    render status: 406, text: "Unknown Format: #{request.headers['HTTP_ACCEPT']}"
  end

  def rescue_not_found
    rescue_site_error(NOT_FOUND_ERROR)
  end

  def rescue_no_current_account
    flash[:info] = 'Выберите аккаунт для работы'
    redirect_to accounts_url
  end

  def rescue_not_authorized
    flash.now[:warning] = 'У вас нет доступа к запрашиваемому ресурсу. Может стоит авторизоваться под другим пользователем?'
    render(
      'sessions/new',
      locals: { session_form: SessionForm.new(remember_me: true) },
      formats: 'html',
      layout: 'auth',
      status: NotAuthorized::HTTP_STATE
    )
  end

  def rescue_not_authenticated
    flash.now[:warning] = 'Авторизуйтесь для доступа на запрашиваемую страницу'
    render(
      'sessions/new',
      locals: { session_form: SessionForm.new(remember_me: true) },
      formats: 'html',
      layout: 'auth',
      status: NotAuthenticated::HTTP_STATE
    )
  end

  def rescue_site_error(error)
    render 'errors/show', locals: { error: error }, layout: 'error', formats: 'html', status: error.try(:http_status) || DEFAULT_HTTP_STATUS
  end
end
