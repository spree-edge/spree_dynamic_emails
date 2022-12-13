# frozen_string_literal: true

class CustomMailerPreview < ActionMailer::Preview
  def custom_email
    ::Spree::CustomMailer.custom_email(id: params[:template_id])
  end
end
