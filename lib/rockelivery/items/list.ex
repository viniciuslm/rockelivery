defmodule Rockelivery.Items.List do
  alias Rockelivery.{Item, Repo}

  def call do
    Item
    |> Repo.all()

    items = Repo.all(Item)
    {:ok, items}
  end
end
