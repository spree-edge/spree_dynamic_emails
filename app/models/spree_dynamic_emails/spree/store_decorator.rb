# frozen_string_literal: true

module SpreeDynamicEmails
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.has_many :email_templates, class_name: 'Spree::EmailTemplate', dependent: :destroy
        base.has_many :campaign, class_name: 'Spree::Campaign', dependent: :destroy
        private
        def create_email_template
          Spree::Seeds::EmailTemplate.call(self)
        end
      end
    end
  end
end
::Spree::Store.prepend ::SpreeDynamicEmails::Spree::StoreDecorator
