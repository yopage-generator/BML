# Общий воркер для отправки писем
class MailerWorker
  include Sidekiq::Worker
  # extend LoggerConcern

  sidekiq_options queue: :critical

  def perform(mailer, method, *args)
    mail = mailer.constantize.send method, *args
    mail.deliver_now!
  rescue Net::SMTPSyntaxError => err
    Bugsnag.notify err, metadata: { mail: mail.inspect }
    # logger.error "#{err} #{mail.inspect}"
  end
end
