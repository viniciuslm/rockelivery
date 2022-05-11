defmodule Rockelivery.Orders.Update do
  alias Rockelivery.{Error, Order, Repo}

  def call(%{"id" => id} = params) do
    case Repo.get(Order, id) do
      nil -> {:error, Error.build_order_not_found_error()}
      order -> do_update(order, params)
    end
  end

  defp do_update(order, params) do
    order
    |> Order.changeset(params)
    |> Repo.update()
  end
end
