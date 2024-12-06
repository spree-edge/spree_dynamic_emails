module SpreeDynamicEmails
  module Admin
    module MainMenu
      class DynamicEmailBuilder
        include ::Spree::Core::Engine.routes.url_helpers

        def build
          items = [
            ::Spree::Admin::MainMenu::ItemBuilder.new("template.email_templates", ::Spree::Core::Engine.routes.url_helpers.admin_email_templates_path).
            with_manage_ability_check(::Spree::EmailTemplate).
            with_match_path('/email_templates').
            build,
            ::Spree::Admin::MainMenu::ItemBuilder.new("campaign.campaign", ::Spree::Core::Engine.routes.url_helpers.admin_campaigns_path).
            with_manage_ability_check(::Spree::Campaign).
            with_match_path('/campaigns').
            build
          ]

          ::Spree::Admin::MainMenu::SectionBuilder.new('emails', 'envelope.svg').
              with_manage_ability_check(::Spree::Emails).
              with_items(items).
              build
        end
      end
    end
  end
end
