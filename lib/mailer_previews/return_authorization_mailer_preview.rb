class ReturnAuthorizationMailerPreview < ActionMailer::Preview
  def return_authorization_email
    ::Spree::ReturnAuthorizationMailer.return_authorization_email(::Spree::ReturnAuthorization.last)
  end
  
end
