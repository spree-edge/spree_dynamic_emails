class CreateCampaign < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_campaigns do |t|
      t.string :name
      t.string :to
      t.integer :rule
      t.references :email_template
      t.belongs_to :store
      t.jsonb :campaign_job_details, default: {}
      t.timestamps
    end
  end
end
