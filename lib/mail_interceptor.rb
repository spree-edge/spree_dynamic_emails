class MailInterceptor
  def self.delivering_email(message)
    message.perform_deliveries = Spree::EmailTemplate.find_by(template_name: message.mailer_action, store_id: message.store_id).try(:active)
    message.to = ['sandbox@example.com'] if message.test
  end
end
