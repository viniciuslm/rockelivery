defmodule Rockelivery.Orders.List do
  alias Rockelivery.{Order, Repo}

  def call do
    orders = Repo.all(Order)
    {:ok, orders}
  end
end
