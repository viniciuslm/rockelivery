defmodule RockeliveryWeb.OrdersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  import Rockelivery.Factory

  alias Rockelivery.Order
  alias RockeliveryWeb.OrdersView

  test "create.json" do
    order = build(:order)

    %{order: %Order{address: address}} = render(OrdersView, "show.json", order: order)

    assert address == "Rua teste, 15"
  end

  test "show.json" do
    order = build(:order)

    %{order: %Order{address: address}} = render(OrdersView, "show.json", order: order)

    assert address == "Rua teste, 15"
  end

  test "delete.json" do
    order = build(:order)

    %{order: %Order{address: address}} = render(OrdersView, "delete.json", order: order)

    assert address == "Rua teste, 15"
  end

  test "index.json" do
    order = build(:order)

    %{
      orders: [
        %Order{address: address}
      ]
    } = render(OrdersView, "index.json", orders: [order])

    assert address == "Rua teste, 15"
  end
end
