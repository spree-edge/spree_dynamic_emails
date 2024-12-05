# frozen_string_literal: true

module SpreeDynamicEmails
  module Spree
    module OrderMailerDecorator
      def confirm_email(order, test=false, id=nil, email_to=nil)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @test_mail = test
        current_store = @order.store
        build_confirm_email_detail
        email = id.present? ? email_to : @order.email
        mail(to: email, from: from_address, subject: @subject, store_url: current_store.url)
      end

      def store_owner_notification_email(order, test=false, id=nil, email_to=nil)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @test_mail = test
        current_store = @order.store
        build_store_owner_notification_email
        email = id.present? ? email_to : current_store.new_order_notifications_email
        mail(to: email, from: from_address, subject: @subject, store_url: current_store.url)
      end

      def cancel_email(order, test=false, id=nil, email_to=nil)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @test_mail = test
        current_store = @order.store
        build_cancel_email_detail
        email = id.present? ? email_to : @order.email
        mail(to: email, from: from_address, subject: @subject, store_url: current_store.url)
      end

      def build_confirm_email_detail
        order_details
      end

      def build_cancel_email_detail
        order_details
      end

      def build_store_owner_notification_email
        order_details
      end

      private

      def order_details
        ensure_default_action_mailer_url_host(current_store.url)
        line_item_details = render_to_string(partial: 'spree/shared/purchased_items_table',
                                             locals: {
                                               line_items: @order.line_items, order: @order
                                             })
        line_items_table = render_to_string(collection: @order.line_items,
                                            partial: 'spree/shared/purchased_items_table/line_item', as: :line_item)
        @body = build_template(@order, { line_item_details: line_item_details, line_items_table: line_items_table })
      end
    end
  end
end

Spree::OrderMailer.prepend ::SpreeDynamicEmails::Spree::OrderMailerDecorator
