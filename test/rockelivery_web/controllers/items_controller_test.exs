defmodule RockeliveryWeb.ItemsControllerTest do
  use RockeliveryWeb.ConnCase

  import Rockelivery.Factory
  alias RockeliveryWeb.Auth.Guardian

  setup %{conn: conn} do
    user = insert(:user)

    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user}
  end

  describe "create/2" do
    test "when all params are valid, create the item", %{conn: conn} do
      params = build(:item_params)

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "Item created!",
               "item" => %{
                 "category" => "drink",
                 "description" => "cerveja",
                 "photo" => "cerveja.png",
                 "price" => "15.00"
               }
             } = response
    end

    test "when there is some error, returns an error", %{conn: conn} do
      params = build(:item_params, %{category: "suco", price: "-1234"})

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "category" => ["is invalid"],
          "price" => ["the price must be greater than 0"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when there is a item with given id, delete the item", %{conn: conn} do
      insert(:item)
      id = "d097e758-c0c7-4215-af97-334b6ac933e1"

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is a item without given id, returns an error", %{conn: conn} do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> json_response(:not_found)

      assert response == %{"message" => "Item not found"}
    end

    test "when there is a invalid id, returns an error", %{conn: conn} do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28"

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))

      assert %Plug.Conn{
               resp_body: "{\"message\":\"Invalid UUID\"}"
             } = response
    end
  end

  describe "show/2" do
    test "when there is a item with given id, show the item", %{conn: conn} do
      insert(:item)
      id = "d097e758-c0c7-4215-af97-334b6ac933e1"

      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:ok)

      assert response == %{
               "item" => %{
                 "id" => "d097e758-c0c7-4215-af97-334b6ac933e1",
                 "category" => "drink",
                 "description" => "cerveja",
                 "photo" => "cerveja.png",
                 "price" => "15.00"
               }
             }
    end

    test "when there is a item without given id, returns an error", %{conn: conn} do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:not_found)

      assert response == %{"message" => "Item not found"}
    end
  end

  describe "list/2" do
    test "when call list items, show all items", %{conn: conn} do
      insert(:item)

      response =
        conn
        |> get(Routes.items_path(conn, :index))
        |> json_response(:ok)

      assert response == %{
               "items" => [
                 %{
                   "id" => "d097e758-c0c7-4215-af97-334b6ac933e1",
                   "category" => "drink",
                   "description" => "cerveja",
                   "photo" => "cerveja.png",
                   "price" => "15.00"
                 }
               ]
             }
    end
  end

  describe "update/2" do
    test "when there is a item with given id, update the item", %{conn: conn} do
      insert(:item)
      id = "d097e758-c0c7-4215-af97-334b6ac933e1"

      params = %{
        "name" => "Teste 333"
      }

      response =
        conn
        |> put(Routes.items_path(conn, :update, id, params))
        |> json_response(:ok)

      assert %{
               "item" => %{
                 "category" => "drink",
                 "description" => "cerveja",
                 "photo" => "cerveja.png",
                 "price" => "15.00"
               },
               "message" => "Item updated!"
             } = response
    end

    test "when there is a item without given id, returns an error", %{conn: conn} do
      insert(:item)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      params = %{
        "name" => "Teste 333"
      }

      response =
        conn
        |> put(Routes.items_path(conn, :update, id, params))
        |> json_response(:not_found)

      assert response == %{"message" => "Item not found"}
    end
  end
end
