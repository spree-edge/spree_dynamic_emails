# frozen_string_literal: true

module SpreeDynamicEmails
  module Spree
    module AbilityDecorator
      def initialize(user)
        user ||= ::Spree.user_class.new
        if user.persisted? && user.try(:spree_admin?)
          apply_admin_permissions(user)
        elsif user.respond_to?(:has_spree_role?) && user.has_spree_role?(:store_owner)
          apply_store_owner_permissions(user)
        elsif user.respond_to?(:has_spree_role?) && user.has_spree_role?(:store_employee)
          apply_store_employee_permissions(user)
        else
          apply_user_permissions(user)
        end

        ::Spree::Ability.abilities.merge(abilities_to_register).each do |clazz|
          merge clazz.new(user)
        end
      end

      def abilities_to_register
        super << ::Spree::EmailTemplateAbility
      end
    end
  end
end

Spree::Ability.prepend SpreeDynamicEmails::Spree::AbilityDecorator
