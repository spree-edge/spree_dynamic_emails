# frozen_string_literal: true

class CustomMailerPreview < ActionMailer::Preview
  def custom_email
    ::Spree::CustomMailer.custom_email(nil, false, params[:template_id], nil)
  end
end
