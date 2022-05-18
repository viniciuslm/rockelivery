defmodule Rockelivery.Orders.ListTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Order
  alias Rockelivery.Orders.{Create, List}
  alias Rockelivery.Users.Create, as: UserCreate
  alias Rockelivery.ViaCep.ClientMock

  setup do
    params_item = build(:item_params)
    params_user = build(:user_params)

    {:ok, item} = ItemCreate.call(params_item)

    expect(ClientMock, :get_cep_info, fn _cep ->
      {:ok, build(:cep_info)}
    end)

    {:ok, user} = UserCreate.call(params_user)

    {:ok, %{item: item, user: user}}
  end

  describe "list/1" do
    test "when call list orders, show all orders", context do
      params =
        build(:order_params, %{
          "user_id" => context.user.id,
          "items" => [%{"id" => context.item.id, "quantity" => 1}]
        })

      Create.call(params)

      response = List.call()

      {:ok, [%Order{address: address, comments: comments}]} = response

      assert address == "Rua teste, 15"
      assert comments == "Teste de comentario"
    end
  end
end
