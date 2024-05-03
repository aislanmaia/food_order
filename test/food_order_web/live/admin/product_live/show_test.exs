defmodule FoodOrderWeb.Admin.ProductLive.ShowTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "Admin Product Show" do
    setup [:create_product]

    test "show product", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products/#{product}")

      assert has_element?(view, "header>div>h1", "Product #{product.id}")
      assert has_element?(view, "div>dt", "Name")
      assert has_element?(view, "div>dd", product.name)

      assert has_element?(view, "div>dt", "Image")
      assert has_element?(view, "img[src*=/images/#{product.image_url}]")
    end
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
