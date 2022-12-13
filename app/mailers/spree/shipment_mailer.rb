# frozen_string_literal: true

module Spree
  class ShipmentMailer < BaseMailer
    def shipped_email(shipment, resend = false, test: false, id: nil, email_to: nil)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @test_mail = test
      @order = @shipment.order
      current_store = @shipment.store
      shipment_details
      email = id.present? ? email_to : @order.email
      mail(to: email, from: from_address, subject: @subject, store_url: current_store.url)
    end

    private

    def shipment_details
      ensure_default_action_mailer_url_host(current_store.url)
      line_item_details = render_to_string(partial: 'spree/shared/purchased_items_table',
                                           locals: {
                                             line_items: @shipment.manifest.map(&:line_item), order: @shipment.order
                                           })
      line_items_table = render_to_string(collection: @shipment.order.line_items,
                                          partial: 'spree/shared/purchased_items_table/line_item', as: :line_item)
      @body = build_template(@shipment, { line_item_details: line_item_details, line_items_table: line_items_table })
    end
  end
end
