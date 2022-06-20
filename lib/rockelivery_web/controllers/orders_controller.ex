defmodule RockeliveryWeb.OrdersController do
  use RockeliveryWeb, :controller

  alias Rockelivery.Order
  alias RockeliveryWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Order{} = order} <- Rockelivery.create_order(params) do
      conn
      |> put_status(:created)
      |> render("create.json", order: order)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Order{}} <- Rockelivery.delete_order(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end

  def index(conn, _params) do
    with {:ok, orders} <- Rockelivery.list_orders() do
      conn
      |> put_status(:ok)
      |> render("index.json", orders: orders)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Order{} = order} <- Rockelivery.get_order(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", order: order)
    end
  end
end
