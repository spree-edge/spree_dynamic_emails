# frozen_string_literal: true

module Spree
  class EmailTemplate < ApplicationRecord
    belongs_to :store
    has_many :campaigns, dependent: :destroy
    scope :current_store, ->(current_store) { where(store_id: current_store) }
    validates :name, presence: true
    validates :subject, presence: true
    validates :mailer_class, presence: true

    def render_body(resource, options)
      @resource = resource
      @options = options
      template = ::Liquid::Template.parse(body)
      template_variables = send(template_name.to_s)
      template.render(template_variables)
    end

    def send_mail
      mailer_class.constantize.send(template_name, record, true, id, nil).deliver_now
    end

    def record
      # TO DO: dummy records to handle nil calss errors
      case mailer_class
      when 'Spree::OrderMailer'
        Spree::Order.last
      when 'Spree::ShipmentMailer'
        Spree::Shipment.last
      when 'Spree::ReturnAuthorizationMailer'
        Spree::ReturnAuthorization.last
      when 'Spree::ReimbursementMailer'
        Spree::Reimbursement.last
      end
    end

    private

    def confirm_email
      order_variables
    end

    def cancel_email
      order_variables
    end

    def shipped_email
      shipment_variables
    end

    def store_owner_notification_email
      order_variables
    end

    def return_authorization_email
      return_authorization_variables
    end

    def reimbursement_email
      reimbursement_email_variables
    end

    def order_variables
      {
        'username' => @resource.name,
        'user_email' => @resource.email,
        'order_number' => @resource.number,
        'order_total' => @resource.total,
        'line_item_details' => @options[:line_item_details],
        'tax' => @resource.additional_tax_total,
        'subtotal' => @resource.item_total,
        'store_name' => @resource.store.name,
        'line_items_table' => @options[:line_items_table]
      }
    end

    def shipment_variables
      { 'username' => @resource.order.name,
        'user_email' => @resource.order.email,
        'order_number' => @resource.order.number,
        'shipping_method_name' => @resource.shipping_method.name,
        'store_name' => @resource.store.name,
        'tracking_url' => @resource.tracking_url,
        'track_information' => @resource.tracking,
        'order_total' => @resource.order.total,
        'line_item_details' => @options[:line_item_details],
        'tax' => @resource.order.additional_tax_total,
        'subtotal' => @resource.order.item_total,
        'store_name' => @resource.store.name,
        'line_items_table' => @options[:line_items_table] }
    end

    def reimbursement_variables
      { 'username' => @resource.order.name,
        'user_email' => @resource.order.email,
        'order_number' => @resource.order.number,
        'store_name' => @resource.store.name,
        'refund_total' => @resource.total,
        'line_item_details' => @options[:line_item_details],
        'tax' => @resource.order.additional_tax_total,
        'subtotal' => @resource.order.item_total,
        'store_name' => @resource.store.name,
        'line_items_table' => @options[:line_items_table] }
    end

    def return_authorization_variables
      { 'username' => @resource.order.name,
        'user_email' => @resource.order.email,
        'order_number' => @resource.order.number,
        'store_name' => @resource.order.store.name,
        'return_authorization_number' => @resource.number,
        'return_item_details' => @options[:return_item_details],
        'address1' => @resource.stock_location.address1,
        'city' => @resource.stock_location.city,
        'zipcode' => @resource.stock_location.zipcode,
        'phone' => @resource.stock_location.phone }
    end

    def reimbursement_email_variables
      { 'username' => @resource.order.name,
        'user_email' => @resource.order.email,
        'order_number' => @resource.order.number,
        'store_name' => @resource.order.store.name,
        'reimbursement_item_details' => @options[:reimbursement_item_details],
        'reimbursement_total' => @resource.total }
    end
  end
end
