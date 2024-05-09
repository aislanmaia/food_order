defmodule FoodOrderWeb.Admin.ProductLive.IndexTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "Admin Product Index" do
    setup [:create_product, :register_and_log_in_admin_user]

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

    test "delete product", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")
      product_id_attribute = "#products-#{product.id}"

      assert has_element?(view, product_id_attribute)

      view
      |> element("[data-id=product-delete-btn-#{product.id}}]", "Delete")
      |> render_click()

      refute has_element?(view, product_id_attribute)
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert view
             |> element("[data-id=product-edit-btn-#{product.id}}]", "Edit")
             |> render_click()

      assert_patch(view, ~p"/admin/products/#{product.id}/edit")

      {:ok, _, html} =
        view
        |> form("#product-form", product: %{name: "pumpkin name updated"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products")

      assert html =~ "Product updated successfully"
      assert html =~ "pumpkin name updated"
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products/#{product}")

      assert view
             |> element("[data-id=header-action-edit-btn]", "Edit Product")
             |> render_click() =~ "Edit Product"

      assert_patch(view, ~p"/admin/products/#{product.id}/show/edit")

      assert view
             |> form("#product-form", product: %{description: nil})
             |> render_submit() =~ "be blank"

      {:ok, _, html} =
        view
        |> form("#product-form", product: %{description: "pumpkin description updated"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products/#{product}")

      assert html =~ "Product updated successfully"
      assert html =~ "pumpkin description updated"
    end
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
