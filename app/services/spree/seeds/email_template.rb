module Spree
  module Seeds
    class EmailTemplate
      prepend ::Spree::ServiceModule::Base

      EMAIL_TEMPLATES = %i[cancel_email shipped_email confirm_email store_owner_notification_email return_authorization_email reimbursement_email]

      def call(store= nil)
        stores = ::Spree::Store.where(id: store.id) if store.present?
        stores = ::Spree::Store.all  if store.nil?
        return unless stores.any?

        stores.each do |store|            
          EMAIL_TEMPLATES.each do |template|
            ::Spree::EmailTemplate.create(template_data(store)[template])
          end
        end
      end

      def template_data(current_store)
        data = { 
          store_owner_notification_email: { 
            template_name: "store_owner_notification_email",
            active: true,
            subject: "#{current_store.name} received a new order",
            body:
              "<p><strong>hi {{ username }} </strong>,&nbsp;</p>
              <p>New order has been placed with the email {{user_email}}&nbsp; &nbsp;having order number {{order_number}} of total amount {{order_total}},</p>
              <p>with the following items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{line_item_details}} &nbsp;</p>
              <p>the tax amount for the order is {{tax}}.</p>
              <p>the subtotal cost of line items is&nbsp; {{subtotal}} is recieved by the store&nbsp; {{store_name}}.</p>
              <p>Thanks&nbsp;</p>",
            store_id: current_store.id,
            variables: ["username", "user_email", "order_number", "line_items_detail", "order_total", "shipping_name", "shippment_cost", "subtotal"],
            description: 'This email is sent to store owner when new order is recieved',
            mailer_class: 'Spree::OrderMailer',
            },
          confirm_email: {
            template_name: "confirm_email",
            active: true,
            subject: "Order Confirmation",
            body:"<p><strong>hi {{ username }} </strong>,&nbsp;</p>
                  <p>Your order has been placed with the email {{user_email}}&nbsp; &nbsp;having order number {{order_number}} of total amount {{order_total}},</p>
                  <p>with the following items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{line_item_details}} &nbsp;</p>
                  <p>the tax amount for the order is {{tax}}</p>
                  <p>the subtotal cost of line items is&nbsp; {{subtotal}} is recieved by the store&nbsp; {{store_name}}.</p>
                  <p>Thanks&nbsp;</p>",
            store_id:  current_store.id,
            variables: ["username", "user_email", "order_number", "line_items_detail", "order_total", "shipping_name", "shippment_cost", "subtotal"],
            description: 'This email is sent to customer when new order is placed',
            mailer_class: 'Spree::OrderMailer',
          },
          shipped_email: {
            template_name: "shipped_email",
            active: true,
            subject: "Shipment Notification",
            body: "<p><strong>Dear {{ username }} </strong>,&nbsp;</p>
                    <p>Your order has been shipped with the email&nbsp; {{user_email}}&nbsp; having order number {{order_number}} of total amount {{order_total}},</p>
                    <p>with the following items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{line_item_details}} &nbsp;</p>
                    <p>the tax amount for the order is {{tax}}</p>
                    <p>the subtotal cost of line items is&nbsp; {{subtotal}} is recieved by the store&nbsp; {{store_name}}.</p>
                    <p>Thanks&nbsp;</p>",
            store_id:  current_store.id,
            variables: ["username", "user_email", "order_number", "line_items_detail", "order_total", "shipping_name", "shippment_cost", "subtotal"],
            description: "This email is sent to when admin ship the order shipment",
            mailer_class: 'Spree::ShipmentMailer',
          },
          cancel_email: {
            template_name: "cancel_email",
            active: true,
            subject: "Cancellation of Order",
            body: "<p><strong>Dear {{ username }} </strong>,&nbsp;</p>
                  <p>Your order has been cancelled with the email&nbsp; {{user_email}}&nbsp; having order number {{order_number}} of total amount {{order_total}},</p>
                  <p>with the following items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{line_item_details}} &nbsp;</p>
                  <p>the tax amount for the order is {{tax}}</p>
                  <p>the subtotal cost of line items is&nbsp; {{subtotal}} is recieved by the store&nbsp; {{store_name}}.</p>
                  <p>Thanks&nbsp;</p>",
            store_id:  current_store.id,
            variables: ["username", "user_email", "order_number", "line_items_detail", "order_total", "shipping_name", "shippment_cost", "subtotal"],
            description: "This email is sent when order is cancelled by the store",
            mailer_class: 'Spree::OrderMailer',
          },
          return_authorization_email: {
            template_name: "return_authorization_email",
            active: true,
            subject: "Return Authorization of Order",
            body: "<p><strong>Dear {{ username }} </strong>,&nbsp;</p>
                  <p>Your return  authorization has been approved for {{return_authorization_number}} with the email&nbsp; {{user_email}}&nbsp; having order number {{order_number}} of total amount {{order_total}},</p>
                  <p>with the following return items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{return_item_details}} &nbsp;</p>
                  <p>the tax amount for the order is {{tax}}</p>
                  <p>the address for the return will be
                  {{address1}},{{city}},{{zipcode}},{{phone}}
                  </p>
                  <p>Thanks&nbsp;</p>",
            store_id:  current_store.id,
            variables: ["username", "user_email", "order_number", "return_authorization_number", "return_item_details", "address1", "city", "zipcode", "phone"],
            description: "This email is sent when return authorization is created by the store",
            mailer_class: 'Spree::ReturnAuthorizationMailer',
          },
          reimbursement_email: {
            template_name: "reimbursement_email",
            active: true,
            subject: "Reimbursement Order email",
            body: "<p><strong>Dear {{ username }} </strong>,&nbsp;</p>
                  <p>Your return  authorization has been approved for  {{user_email}}&nbsp; having order number {{order_number}}</p>
                  <p>with the following items&nbsp;<br />&nbsp; &nbsp; &nbsp; {{reimbursement_item_details}} &nbsp;</p>
                  <p>Thanks&nbsp;</p>",
            store_id:  current_store.id,
            variables: ["username", "user_email", "order_number", "reimbursement_item_details", "reimbursement_total"],
            description: "This email is sent when Reimbursement is created by the store",
            mailer_class: 'Spree::ReimbursementMailer',
          }

        }

        data
      end
    end
  end
end
