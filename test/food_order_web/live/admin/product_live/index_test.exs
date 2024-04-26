defmodule FoodOrderWeb.Admin.ProductLive.IndexTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "Admin Product Index" do
    setup [:create_product]

    test "list products", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "header>div>h1", "List Products")

      product_id = "#products-#{product.id}"
      assert has_element?(view, product_id)
      assert has_element?(view, product_id <> ">td>div>span", product.name)

      assert has_element?(
               view,
               product_id <> ">td>div>span",
               Money.to_string(product.price)
             )

      assert has_element?(
               view,
               product_id <> ">td>div>span",
               Atom.to_string(product.size)
             )
    end

    test "add new product", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert view |> element("header>div>a", "New Product") |> render_click()

      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      assert view
             |> form("#product-form",
               product: %{
                 name: "Product 1 name",
                 description: "Product 1 description",
                 price: "11"
               }
             )
             |> render_change()

      {:ok, _view, html} =
        view
        |> form("#product-form",
          product: %{
            name: "Product 1 name",
            description: "Product 1 description",
            price: "11"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products")

      assert html =~ "Product created successfully"
      assert html =~ "Product 1 name"
    end
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
