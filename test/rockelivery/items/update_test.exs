defmodule Rockelivery.Items.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Update

  describe "call/1" do
    test "when there is a item with given id, update the item" do
      insert(:item)

      params = %{
        "id" => "d097e758-c0c7-4215-af97-334b6ac933e1",
        "description" => "Beer boa"
      }

      response = Update.call(params)

      {:ok, %Item{price: price, description: description}} = response

      assert price == Decimal.new("15.00")
      assert description == "Beer boa"
    end

    test "when there is a item without given id, returns an error" do
      insert(:item)

      params = %{
        "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d1",
        "description" => "Beer boa"
      }

      response = Update.call(params)

      expected_response = "Item not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end

    test "when there are invalid params, retuns an error" do
      insert(:item)

      params = %{
        "id" => "d097e758-c0c7-4215-af97-334b6ac933e1",
        "category" => "suco",
        "price" => "-1"
      }

      response = Update.call(params)

      expected_response = %{
        category: ["is invalid"],
        price: ["the price must be greater than 0"]
      }

      assert {:error, changeset} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
