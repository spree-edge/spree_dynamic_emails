class CreateSpreeEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_email_templates do |t|
      t.string :template_name
      t.boolean :active
      t.string :subject
      t.string :body
      t.string :variables, array: true
      t.string :description
      t.string :mailer_class
      t.belongs_to :store

      t.timestamps
    end
  end
end
