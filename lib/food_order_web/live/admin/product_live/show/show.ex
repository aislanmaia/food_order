defmodule FoodOrderWeb.Admin.ProductLive.Show do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.Admin.ProductLive.Form

  def handle_params(%{"id" => id}, _, socket) do
    product = Products.get_product!(id)
    {:noreply, assign(socket, :product, product) |> assign(page_title: "Product #{product.name}")}
  end
end
