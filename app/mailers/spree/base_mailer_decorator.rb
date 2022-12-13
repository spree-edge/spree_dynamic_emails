# frozen_string_literal: true

module Spree
  module BaseMailerDecorator
    def self.prepended(base)
      base.before_action :ensure_default_action_mailer_url_host
      base.after_action :attach_metadata
    end

    private

    def ensure_default_action_mailer_url_host(store_url = nil)
      ActionMailer::Base.default_url_options ||= {}
      ActionMailer::Base.default_url_options[:protocol] = 'https'
      ActionMailer::Base.default_url_options[:host] ||= store_url
    end

    def build_template(resource, options = {})
      @template = current_store.email_templates.find_by(template_name: action_name)
      return unless @template.present?

      @subject = @template.subject
      @body = @template.render_body(resource, options)
    end

    def attach_metadata
      mailer_klass = self.class.to_s
      mailer_action = action_name

      message.instance_variable_set(:@store_id, current_store.id)
      message.instance_variable_set(:@mailer_klass, mailer_klass)
      message.instance_variable_set(:@mailer_action, mailer_action)
      message.instance_variable_set(:@test, @test_mail)

      message.class.send(:attr_reader, :store_id)
      message.class.send(:attr_reader, :mailer_klass)
      message.class.send(:attr_reader, :mailer_action)
      message.class.send(:attr_reader, :test)
    end
  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
