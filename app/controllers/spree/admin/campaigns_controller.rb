# frozen_string_literal: true

module Spree
  module Admin
    class CampaignsController < ResourceController
      def send_mail
        if @campaign.email_template.active
          if params[:campaign_job_details].present?
            schedule = Time.zone.parse(params[:campaign_job_details].join(', '))
          end
          @campaign.run(schedule)
          flash[:success] =
            if params[:campaign_job_details].present?
              Spree.t(:email_scheduled_successfully,
                      scope: :campaign)
            else
              ::Spree.t(:email_sent_successfully,
                        scope: :template)
            end
        else
          flash[:error] = ::Spree.t(:email_not_active, scope: :template)
        end
        redirect_to edit_admin_campaign_path
      end

      def campaign_log
        @campaign_logs = @campaign.campaign_logs.order(created_at: :desc).page(params[:page]).per(params[:per_page])
      end

      def delete_jobs
        job_ids = params[:format]
        @campaign.campaign_job_details.delete(job_ids)
        @campaign.save
        redirect_to edit_admin_campaign_path
      end
    end
  end
end
