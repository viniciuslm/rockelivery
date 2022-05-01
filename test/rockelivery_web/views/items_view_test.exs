defmodule RockeliveryWeb.ItemsViewTest do
  use RockeliveryWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  import Rockelivery.Factory

  alias RockeliveryWeb.ItemsView

  test "create.json" do
    item = build(:item)

    assert %{
             message: "Item created!",
             item: %Rockelivery.Item{
               id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
               category: "drink",
               description: "cerveja",
               photo: "cerveja.png",
               price: "15.00",
               inserted_at: nil,
               updated_at: nil
             }
           } = render(ItemsView, "create.json", item: item)
  end

  test "show.json" do
    item = build(:item)

    assert %{
             item: %Rockelivery.Item{
               id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
               category: "drink",
               description: "cerveja",
               photo: "cerveja.png",
               price: "15.00",
               inserted_at: nil,
               updated_at: nil
             }
           } = render(ItemsView, "show.json", item: item)
  end

  test "update.json" do
    item = build(:item)

    assert %{
             message: "Item updated!",
             item: %Rockelivery.Item{
               id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
               category: "drink",
               description: "cerveja",
               photo: "cerveja.png",
               price: "15.00",
               inserted_at: nil,
               updated_at: nil
             }
           } = render(ItemsView, "update.json", item: item)
  end

  test "delete.json" do
    item = build(:item)

    assert %{
             item: %Rockelivery.Item{
               id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
               category: "drink",
               description: "cerveja",
               photo: "cerveja.png",
               price: "15.00",
               inserted_at: nil,
               updated_at: nil
             }
           } = render(ItemsView, "delete.json", item: item)
  end

  test "index.json" do
    item = build(:item)

    assert %{
             items: [
               %Rockelivery.Item{
                 id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
                 category: "drink",
                 description: "cerveja",
                 photo: "cerveja.png",
                 price: "15.00",
                 inserted_at: nil,
                 updated_at: nil
               }
             ]
           } = render(ItemsView, "index.json", items: [item])
  end
end
