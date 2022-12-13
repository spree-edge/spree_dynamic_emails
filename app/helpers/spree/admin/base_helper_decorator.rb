# frozen_string_literal: true

module Spree
  module Admin
    module BaseHelperDecorator
      def email_preview_link(resource, options = {})
        resource_name = options[:name] || resource.class.name.demodulize
        resource_id = resource.id
        button_link_to(Spree.t(:preview_email, scope: :template),
                       "/rails/mailers/#{mailer_name(resource.mailer_class)}/#{resource.template_name}?template_id=#{resource_id}",
                       class: 'btn-outline-secondary', icon: 'view.svg', target: :blank, data: { turbo: false })
      end

      def mailer_name(mailer_class = nil)
        case mailer_class
        when 'Spree::OrderMailer'
          'order_mailer'
        when 'Spree::ShipmentMailer'
          'shipment_mailer'
        when 'Spree::ReimbursementMailer'
          'reimbursement_mailer'
        when 'Spree::ReturnAuthorizationMailer'
          'return_authorization_mailer'
        when 'Spree::CustomMailer'
          'custom_mailer'
        end
      end

      ::Spree::Admin::BaseHelper.prepend ::Spree::Admin::BaseHelperDecorator
    end
  end
end
