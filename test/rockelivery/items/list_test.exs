defmodule Rockelivery.Items.ListTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.Item
  alias Rockelivery.Items.List

  describe "list/1" do
    test "when call list items, show all items" do
      insert(:item)

      response = List.call()

      {:ok, [%Item{price: price, description: description}]} = response

      assert price == Decimal.new("15.00")
      assert description == "cerveja"
    end
  end
end
