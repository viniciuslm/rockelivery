defmodule RockeliveryWeb.OrdersControllerTest do
  use RockeliveryWeb.ConnCase

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Orders.Create, as: OrderCreate
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

    params =
      build(:order_params, %{
        "user_id" => user.id,
        "items" => [%{"id" => item.id, "quantity" => 1}]
      })

    {:ok, order} = OrderCreate.call(params)

    {:ok, %{item: item, user: user, order: order}}
  end

  describe "create/2" do
    test "when all params are valid, create the order", %{conn: conn, user: user, item: item} do
      params =
        build(:order_params, %{
          "user_id" => user.id,
          "items" => [%{"id" => item.id, "quantity" => 1}]
        })

      response =
        conn
        |> post(Routes.orders_path(conn, :create), params)
        |> json_response(:created)

      assert %{
               "message" => "Order created!",
               "order" => %{
                 "address" => "Rua teste, 15",
                 "comments" => "Teste de comentario",
                 "items" => [
                   %{
                     "category" => "drink",
                     "description" => "cerveja",
                     "photo" => "cerveja.png",
                     "price" => "15.00"
                   }
                 ],
                 "payment_method" => "money"
               }
             } = response
    end

    test "when there is some error, returns an error", %{conn: conn, user: user, item: item} do
      params =
        build(:order_params, %{
          "user_id" => user.id,
          "items" => [%{"id" => item.id, "quantity" => 1}],
          "payment_method" => "cash"
        })

      response =
        conn
        |> post(Routes.orders_path(conn, :create), params)
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{"payment_method" => ["is invalid"]}
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when there is a order with given id, delete the order", %{conn: conn, order: order} do
      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, order.id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is a order without given id, returns an error", %{conn: conn} do
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, id))
        |> json_response(:not_found)

      assert response == %{"message" => "Order not found"}
    end

    test "when there is a invalid id, returns an error", %{conn: conn} do
      id = "7d8972e2-62ff-40fa-8c28"

      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, id))

      assert %Plug.Conn{
               resp_body: "{\"message\":\"Invalid UUID\"}"
             } = response
    end
  end

  describe "show/2" do
    test "when there is a order with given id, show the order", %{
      conn: conn,
      order: order,
      user: user,
      item: item
    } do
      response =
        conn
        |> get(Routes.orders_path(conn, :show, order.id))
        |> json_response(:ok)

      assert response == %{
               "order" => %{
                 "address" => "Rua teste, 15",
                 "comments" => "Teste de comentario",
                 "id" => order.id,
                 "items" => [
                   %{
                     "category" => "drink",
                     "id" => item.id,
                     "description" => "cerveja",
                     "photo" => "cerveja.png",
                     "price" => "15.00"
                   }
                 ],
                 "payment_method" => "money",
                 "user_id" => user.id
               }
             }
    end

    test "when there is a order without given id, returns an error", %{conn: conn} do
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> get(Routes.orders_path(conn, :show, id))
        |> json_response(:not_found)

      assert response == %{"message" => "Order not found"}
    end
  end

  describe "list/2" do
    test "when call list orders, show all orders", %{
      conn: conn,
      order: order,
      user: user,
      item: item
    } do
      response =
        conn
        |> get(Routes.orders_path(conn, :index))
        |> json_response(:ok)

      assert response == %{
               "orders" => [
                 %{
                   "address" => "Rua teste, 15",
                   "comments" => "Teste de comentario",
                   "id" => order.id,
                   "items" => [
                     %{
                       "category" => "drink",
                       "description" => "cerveja",
                       "id" => item.id,
                       "photo" => "cerveja.png",
                       "price" => "15.00"
                     }
                   ],
                   "payment_method" => "money",
                   "user_id" => user.id
                 }
               ]
             }
    end
  end
end
