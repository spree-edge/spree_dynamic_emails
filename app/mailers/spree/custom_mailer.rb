# frozen_string_literal: true

module Spree
  class CustomMailer < ::Spree::BaseMailer
    def custom_email(resend = false, test: false, id: nil, email_to: nil)
      @test_mail = test
      find_template(id)
      email = email_to
      mail(to: email, from: from_address, subject: @subject, store_url: current_store.url)
    end

    def find_template(id)
      @template = ::Spree::EmailTemplate.find_by(id: id)
      return unless @template.present?

      @subject = @template.subject
      @body = @template.body
      ensure_default_action_mailer_url_host(current_store.url)
    end
  end
end
