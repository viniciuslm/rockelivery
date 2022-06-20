defmodule Rockelivery.Orders.List do
  import Ecto.Query

  alias Rockelivery.{Order, Repo}

  def call do
    query = from(o in Order, preload: [:items])

    orders = Repo.all(query)
    {:ok, orders}
  end
end
