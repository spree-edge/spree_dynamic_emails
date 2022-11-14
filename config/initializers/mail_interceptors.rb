require 'mail_interceptor'

Rails.application.configure do
  config.action_mailer.interceptors = %w[MailInterceptor]
  config.action_mailer.preview_path = "#{Gem.loaded_specs['spree_dynamic_emails'].gem_dir}/lib/mailer_previews"
end
