defmodule Rockelivery.Items.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Delete

  describe "call/1" do
    test "when there is a item with given id, delete the item" do
      insert(:item)
      id = "d097e758-c0c7-4215-af97-334b6ac933e1"

      response = Delete.call(id)

      {:ok, %Item{price: price, description: description}} = response

      assert price == Decimal.new("15.00")
      assert description == "cerveja"
    end

    test "when there is a item without given id, returns an error" do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response = Delete.call(id)

      expected_response = "Item not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end
  end
end
