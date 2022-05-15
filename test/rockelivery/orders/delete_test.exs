defmodule Rockelivery.Orders.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Order}
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Orders.{Create, Delete}
  alias Rockelivery.Users.Create, as: UserCreate

  setup do
    params_item = build(:item_params)
    params_user = build(:user_params)

    {:ok, item} = ItemCreate.call(params_item)
    {:ok, user} = UserCreate.call(params_user)

    {:ok, %{item: item, user: user}}
  end

  describe "call/1" do
    test "when there is a order with given id, delete the order", context do
      params =
        build(:order_params, %{
          "user_id" => context.user.id,
          "items" => [%{"id" => context.item.id, "quantity" => 1}]
        })

      {:ok, %Order{id: id}} = Create.call(params)

      response = Delete.call(id)

      {:ok, %Order{address: address, comments: comments}} = response

      assert address == "Rua teste, 15"
      assert comments == "Teste de comentario"
    end

    test "when there is a order without given id, returns an error", context do
      params =
        build(:order_params, %{
          "user_id" => context.user.id,
          "items" => [%{"id" => context.item.id, "quantity" => 1}]
        })

      Create.call(params)

      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response = Delete.call(id)

      expected_response = "Order not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end
  end
end
