# frozen_string_literal: true

module Spree
  class Campaign < ApplicationRecord
    include Spree::PredefinedRules

    belongs_to :store
    belongs_to :email_template
    has_many :campaign_logs, dependent: :destroy
    validates :email_template_id, presence: true
    validates :to, presence: { message: 'or rule must be present' }, unless: -> { rule.present? }
    validates :rule, presence: { message: 'or to must be present' }, unless: -> { to.present? }
    validate :check_email_addresses
    before_destroy :check_job_presence

    enum rule: Spree::PredefinedRules.instance_methods

    def run(schedule = nil)
      if schedule.present?
        response = EmailSendJob.set(wait_until: schedule).perform_later(email_template, id)
        save_job_id(response, schedule)
      else
        EmailSendJob.perform_now(email_template, id)
      end
    end

    def save_job_id(response, schedule)
      self.campaign_job_details = campaign_job_details.merge({ response.provider_job_id => schedule })
      save!
    end

    def delete_job(job_id)
      job = Sidekiq::ScheduledSet.new.find_job(job_id)
      job.delete if job_id.present?
      campaign_job_details.delete(job_id)
      save!
    end

    def check_job_presence
      if campaign_job_details.present?
        self.errors.add(:base, "Campaigns are already scheduled, First delete the scheduled campaigns")
        throw :abort
      end
    end

    private

    def check_email_addresses
      if to.present?
        to.split(/,\s*/).each do |email|
          unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
            errors.add(:email_addresses, "are invalid due to #{email}")
          end
        end
      end
    end
  end
end
