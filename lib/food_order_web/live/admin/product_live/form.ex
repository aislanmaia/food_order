defmodule FoodOrderWeb.Admin.ProductLive.Form do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_component

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)
    {:ok, socket |> assign(assigns) |> assign(changeset: to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        id="product-form"
        for={@changeset}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.input field={@changeset[:name]} label="Name" />
        <.input field={@changeset[:description]} type="textarea" label="Description" />
        <.input field={@changeset[:price]} label="Price" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)
      |> to_form

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save(socket, socket.assigns.action, product_params)
  end

  defp save(socket, :new, product_params) do
    action_result = Products.create_product(product_params)
    message = "Product created successfully"
    perform(socket, action_result, message)
  end

  defp save(socket, :edit, product_params) do
    action_result = Products.update_product(socket.assigns.product, product_params)
    message = "Product updated successfully"
    perform(socket, action_result, message)
  end

  defp perform(socket, action_result, message) do
    case action_result do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, message)
          |> push_navigate(to: socket.assigns.navigate)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: to_form(changeset))}
    end
  end
end
