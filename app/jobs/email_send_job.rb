# frozen_string_literal: true

class EmailSendJob < ApplicationJob
  queue_as :default

  def perform(template, campaign_id)
    recepients(template, campaign_id)
  end

  def recepients(template, id)
    @campaign = Spree::Campaign.find_by(id: id)
    rule = @campaign.rule
    emails = @campaign.send(rule) if rule.present?
    emails = @campaign&.to&.split(',') unless emails.present?
    emails&.each do |to|
      response = template.mailer_class.constantize.send(template.template_name, template.record, false, template.id,
                                                                                                  to).deliver_now
      create_log(response)
    end
  end

  def create_log(response)
    email = JSON.parse(response.from).join(', ')
    sent_to = JSON.parse(response.to).join(', ')
    date = Time.zone.parse(response.date.to_s)
    status = response.present? ? 'success' : 'fail'
    @campaign_logs = @campaign.campaign_logs.build(email: email, sent_to: sent_to, status: status, sent_at: date)
    @campaign_logs.save
  end

  after_perform do |job|
    job_id = job.provider_job_id
    @campaign.campaign_job_details.delete(job_id)
    @campaign.save!
  end
end
