defmodule Rockelivery.Order.CreateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Order}
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Orders.Create
  alias Rockelivery.Users.Create, as: UserCreate

  setup do
    params_item = build(:item_params)
    params_user = build(:user_params)

    {:ok, item} = ItemCreate.call(params_item)
    {:ok, user} = UserCreate.call(params_user)

    {:ok, %{item: item, user: user}}
  end

  describe "call/1" do
    test "when all params are valid, retuns the order", context do
      params =
        build(:order_params, %{
          "user_id" => context.user.id,
          "items" => [%{"id" => context.item.id, "quantity" => 1}]
        })

      response = Create.call(params)

      {:ok, %Order{address: address, comments: comments}} = response

      assert address == "Rua teste, 15"
      assert comments == "Teste de comentario"
    end

    test "when there are invalid params, retuns an error", context do
      params =
        build(:order_params, %{
          "payment_method" => "cash",
          "user_id" => context.user.id,
          "items" => [%{"id" => context.item.id, "quantity" => 1}]
        })

      response = Create.call(params)

      expected_response = %{payment_method: ["is invalid"]}

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end

    test "when there are invalid items, retuns an error", context do
      params =
        build(:order_params, %{
          "payment_method" => "cash",
          "user_id" => context.user.id,
          "items" => [%{"id" => "d097e758-c0c7-4215-af97-334b6ac933e1", "quantity" => 1}]
        })

      response = Create.call(params)

      assert response == {:error, %Error{result: "Invalid ids!", status: :bad_request}}
    end
  end
end
