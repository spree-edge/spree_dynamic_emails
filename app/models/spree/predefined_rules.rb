# frozen_string_literal: true

module Spree
  module PredefinedRules
    def last_thirty_users
      Spree::User.pluck(:email).last(30)
    end

    def completed_orders
      Spree::Order.complete.pluck(:email).last(10)
    end
  end
end
