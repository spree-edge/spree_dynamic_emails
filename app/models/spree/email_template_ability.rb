# frozen_string_literal: true

module Spree
  class EmailTemplateAbility
    include CanCan::Ability

    def initialize(_user)
      apply_delete_at_custom_template if Spree::EmailTemplate.present?
    end

    def apply_delete_at_custom_template
      cannot :destroy, ::Spree::EmailTemplate.all.where(custom_template: false)
    end
  end
end
