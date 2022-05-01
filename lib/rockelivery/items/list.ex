defmodule Rockelivery.Items.List do
  alias Rockelivery.{Item, Repo}

  def call do
    items = Repo.all(Item)
    {:ok, items}
  end
end
