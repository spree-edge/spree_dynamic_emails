class AddEmailTemplateToNewStore < ActiveRecord::Migration[6.1]
  def change
    Spree::Seeds::EmailTemplate.call
  end
end
