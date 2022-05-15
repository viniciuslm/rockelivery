defmodule Rockelivery.Orders.Get do
  import Ecto.Query

  alias Rockelivery.{Error, Order, Repo}

  def by_id(id) do
    query = from(o in Order, where: o.id == ^id, preload: [:items])

    case Repo.one(query) do
      nil -> {:error, Error.build_order_not_found_error()}
      order -> {:ok, order}
    end
  end
end
