defmodule Rockelivery.Orders.Create do
  import Ecto.Query
  alias Rockelivery.{Error, Item, Order, Repo}
  alias Rockelivery.Orders.ValidadeAndMultiPlyItems

  def call(%{"items" => items_params} = params) do
    items_ids = Enum.map(items_params, fn item -> item["id"] end)

    query = from(item in Item, where: item.id in ^items_ids)

    query
    |> Repo.all()
    |> ValidadeAndMultiPlyItems.call(items_ids, items_params)
    |> handle_item(params)
  end

  defp handle_item({:ok, items}, params) do
    params
    |> Order.changeset(items)
    |> Repo.insert()
    |> handle_insert
  end

  defp handle_item({:error, result}, _params), do: {:error, Error.build(:bad_request, result)}

  defp handle_insert({:ok, %Order{}} = result), do: result

  defp handle_insert({:error, result}), do: {:error, Error.build(:bad_request, result)}
end
