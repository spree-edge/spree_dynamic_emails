module Spree
  module Admin
    class EmailTemplatesController < ResourceController
      def index
        @email_templates = Spree::EmailTemplate.current_store(current_store.id)
      end

      def test_mail
        if @email_template.send_mail
          flash[:success] = ::Spree.t(:email_sent_successfully, scope: :template)
        else 
          flash[:error] = ::Spree.t(:unable_to_send, scope: :template)
        end

        redirect_to edit_admin_email_template_path(@email_template)
      end
    end
  end
end
