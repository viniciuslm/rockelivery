defmodule Rockelivery.Items.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Get

  describe "call/1" do
    test "when there is a item with given id, get the item" do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d9"

      response = Get.by_id(id)

      {:ok, %Item{price: price, description: description}} = response

      assert price == Decimal.new("15.00")
      assert description == "cerveja"
    end

    test "when there is a item without given id, returns an error" do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response = Get.by_id(id)

      expected_response = "Item not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end
  end
end
