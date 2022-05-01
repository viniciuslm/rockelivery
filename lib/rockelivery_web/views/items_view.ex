defmodule RockeliveryWeb.ItemsView do
  use RockeliveryWeb, :view
  alias Rockelivery.Item

  def render("create.json", %{item: %Item{} = item}) do
    %{
      message: "Item created!",
      item: item
    }
  end

  def render("delete.json", %{item: %Item{} = item}), do: %{item: item}

  def render("index.json", %{items: [%Item{} = _item | _rest] = items}), do: %{items: items}

  def render("show.json", %{item: %Item{} = item}), do: %{item: item}

  def render("update.json", %{item: %Item{} = item}) do
    %{
      message: "Item updated!",
      item: item
    }
  end
end
