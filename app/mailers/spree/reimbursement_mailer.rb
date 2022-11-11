module Spree
  class ReimbursementMailer < BaseMailer
    def reimbursement_email(reimbursement, resend = false, test: false)
      @reimbursement = reimbursement.respond_to?(:id) ? reimbursement : Spree::Reimbursement.find(reimbursement)
      @order = @reimbursement.order
      current_store = @reimbursement.store || Spree::Store.default
      reimbursement_details
      email = test ? current_store.email_setting.intercept_email : @order.email
      mail(to: email, from: current_store.mail_from_address, subject: @subject, store_url: current_store.url)
    end

    private
    def reimbursement_details
      ensure_default_action_mailer_url_host(current_store.url)
      reimbursement_item_details = render_to_string(partial: 'spree/reimbursement_mailer/shared/reimbursement_table', locals: {reimbursement:  @reimbursement })
      @body = build_template(@reimbursement, {reimbursement_item_details: reimbursement_item_details})
    end
  end
end