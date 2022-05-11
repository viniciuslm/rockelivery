defmodule Rockelivery.Orders.Create do
  alias Rockelivery.{Error, Item, Order, Repo}

  def call(params, item) do
    params
    |> Order.changeset()
    |> Repo.insert()
    |> handle_insert
  end

  defp handle_insert({:ok, %Order{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
