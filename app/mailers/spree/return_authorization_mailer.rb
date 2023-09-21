# frozen_string_literal: true

module Spree
  class ReturnAuthorizationMailer < BaseMailer
    def return_authorization_email(return_authorization, test= false, id= nil, email_to=nil)
      @return_authorization = return_authorization.respond_to?(:id) ? return_authorization : Spree::ReturnAuthorization.find(return_authorization)
      @test_mail = test
      @order = @return_authorization.order
      current_store = @order&.store || Spree::Store.default
      return_authorization_details
      email = id.present? ? email_to : @order.email
      mail(to: email, from: current_store.mail_from_address, subject: @subject, store_url: current_store.url)
    end

    private

    def return_authorization_details
      ensure_default_action_mailer_url_host(current_store.url)
      return_item_details = render_to_string(
        partial: 'spree/return_authorization_mailer/shared/return_authorization_table', locals: { return_authorization: @return_authorization }
      )
      @body = build_template(@return_authorization, { return_item_details: return_item_details })
    end
  end
end
