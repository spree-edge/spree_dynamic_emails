# frozen_string_literal: true

module Spree
  class CampaignLog < ApplicationRecord
    belongs_to :campaign
  end
end
