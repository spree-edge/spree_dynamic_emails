require 'mail_interceptor'

Rails.application.configure do
  config.action_mailer.interceptors = %w[MailInterceptor]
end
