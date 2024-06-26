defmodule FoodOrderWeb.RequireAdmin do
  use FoodOrderWeb, :verified_routes

  def on_mount(_default, _params, _session, socket) do
    if socket.assigns.current_user.role == :ADMIN do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(
          :error,
          "You must have right permissions to access this page."
        )
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end
end
