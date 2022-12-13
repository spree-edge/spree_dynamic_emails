# frozen_string_literal: true

module Spree
  module Admin
    class EmailTemplatesController < ResourceController
      def index
        @email_templates = current_store.email_templates.order('custom_template')
      end

      def test_mail
        if @email_template.active
          if @email_template.send_mail
            flash[:success] = ::Spree.t(:email_sent_successfully, scope: :template)
          end
        else
          flash[:error] = ::Spree.t(:email_not_active, scope: :template)
        end

        redirect_to edit_admin_email_template_path(@email_template)
      end

      def destroy
        invoke_callbacks(:destroy, :before)
        if @email_template.destroy
          invoke_callbacks(:destroy, :after)
          flash[:success] = flash_message_for(@email_template, :successfully_removed)
        else
          invoke_callbacks(:destroy, :fails)
          flash[:error] = "Scheduled campaigns are present, first delete the scheduled campaigns"
        end
        respond_with(@email_template) do |format|
          format.html { redirect_to location_after_destroy }
          format.js   { render_js_for_destroy }
        end
      end
    end
  end
end
