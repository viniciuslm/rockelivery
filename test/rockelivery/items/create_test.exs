defmodule Rockelivery.Item.CreateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Create

  describe "call/1" do
    test "when all params are valid, retuns the item" do
      params = build(:item_params)

      response = Create.call(params)

      {:ok, %Item{price: price, description: description}} = response

      assert price == Decimal.new("15.00")
      assert description == "cerveja"
    end

    test "when there are invalid params, retuns an error" do
      params = build(:item_params, %{category: "suco", price: "-1"})

      response = Create.call(params)

      expected_response = %{
        category: ["is invalid"],
        price: ["the price must be greater than 0"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
