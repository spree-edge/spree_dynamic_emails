class CreateSpreeEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_email_templates do |t|
      t.string :name
      t.string :template_name, default: 'custom_email'
      t.boolean :active
      t.string :subject
      t.string :body
      t.string :variables, array: true
      t.string :description
      t.string :mailer_class, default: 'Spree::CustomMailer'
      t.belongs_to :store
      t.boolean :custom_template, default: true

      t.timestamps
    end
  end
end
