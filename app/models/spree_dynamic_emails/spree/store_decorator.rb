module SpreeDynamicEmails
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.has_many :email_templates
      end
    end
  end
end
::Spree::Store.prepend ::SpreeDynamicEmails::Spree::StoreDecorator
