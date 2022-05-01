defmodule Rockelivery.ItemTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.Item

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:item_params)

      response = Item.changeset(params)

      assert %Changeset{
               changes: %{
                 category: :drink,
                 description: "cerveja",
                 photo: "cerveja.png"
               },
               valid?: true
             } = response
    end

    test "when update a changeset, returns a valid changeset with the given changes" do
      params = build(:item_params)

      update_params = %{
        description: "Teste 3"
      }

      response = Item.changeset(params) |> Item.changeset(update_params)

      assert %Changeset{
               changes: %{
                 description: "Teste 3"
               },
               valid?: true
             } = response
    end

    test "when there is some error, returns an invalid changeset" do
      params = build(:item_params, %{category: "suco", price: "1.d.234"})

      response = Item.changeset(params)

      expected_response = %{
        category: ["is invalid"],
        price: ["is invalid"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
