Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_mail_tab_to_main_menu',
  insert_before: "ul#sidebarConfiguration",
  text: <<-HTML
    <% if can? :admin, current_store %>
      <ul class="nav nav-sidebar border-bottom" id="sidebarEmail">
        <%= main_menu_tree Spree.t(:email), icon: "envelope.svg", sub_menu: "template", url: "#sidebar-email" %>
      </ul>
    <% end %>
  HTML
)
