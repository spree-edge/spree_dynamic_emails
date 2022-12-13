class CreateCampaignLog < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_campaign_logs do |t|
      t.references :campaign
      t.string :sent_to
      t.string :email
      t.string :status
      t.datetime :sent_at

      t.timestamps
    end
  end
end
