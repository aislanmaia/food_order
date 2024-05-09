defmodule FoodOrderWeb.HeaderComponent do
  # use Phoenix.Component
  use FoodOrderWeb, :html

  def navbar(assigns) do
    ~H"""
    <nav class="flex items-center justify-between py-4">
      <div id="logo">
        <.link href={~p"/"}>
          <img src={~p"/images/logo.png"} alt="" class="w-16 h-16" />
        </.link>
      </div>
      <ul id="menu" class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
        <%= if @current_user do %>
          <%= if @current_user.role == :ADMIN do %>
            <li class="ml-6 cursor-pointer">
              <.link href={~p"/admin/products"} class="leading-6">
                Admin Products
              </.link>
            </li>
            <li class="ml-6 cursor-pointer">
              Admin Orders
            </li>
          <% else %>
            <li class="ml-6 cursor-pointer">
              My Orders
            </li>
          <% end %>
          <li class="ml-6 cursor-pointer">
            <.link href={~p"/users/settings"} class="leading-6">
              Settings
            </.link>
          </li>
          <li class="ml-6 cursor-pointer">
            <.link href={~p"/users/log_out"} method="delete" class="leading-6">
              Log out
            </.link>
          </li>
          <li class="text-[0.8125rem] leading-6 text-zinc-900">
            <%= @current_user.email %>
          </li>
        <% else %>
          <li class="ml-6 cursor-pointer">
            <.link href={~p"/users/register"} class="leading-6">
              Register
            </.link>
          </li>
          <li class="ml-6 cursor-pointer">
            <.link href={~p"/users/log_in"} class="leading-6">
              Log in
            </.link>
          </li>
        <% end %>

        <a
          href={~p"/cart/"}
          class="flex ml-6 p-4 items-center bg-orange-500 rounded-full text-neutral-100 cursor-pointer group hover:text-orange-500 hover:bg-orange-100 transition-all"
        >
          <span class="text-sm">0</span>
          <.icon name="hero-shopping-cart-solid" class="h-5 w-5" />
        </a>
      </ul>
    </nav>
    """
  end
end
