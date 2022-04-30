defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params are valid, create the user", %{conn: conn} do
      params = %{
        "address" => "rua teste 1",
        "age" => 27,
        "cep" => "31260210",
        "cpf" => "02577788622",
        "email" => "teste123@teste.com",
        "password" => "123456",
        "name" => "Teste 2"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created!",
               "user" => %{
                 "address" => "rua teste 1",
                 "age" => 27,
                 "cep" => "31260210",
                 "cpf" => "02577788622",
                 "email" => "teste123@teste.com",
                 "id" => _id,
                 "name" => "Teste 2"
               }
             } = response
    end

    test "when there is some error, returns an error", %{conn: conn} do
      params = %{
        "address" => "rua teste 1",
        "age" => 13,
        "cep" => "31260210",
        "cpf" => "02577788622",
        "email" => "teste123@teste.com",
        "password" => "123",
        "name" => "Teste 2"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "age" => ["must be greater than or equal to 18"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when there is a user with given id, delete the user", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d9"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert response == %{"message" => "User not found"}
    end

    test "when there is a invalid id, returns an error", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))

      assert %Plug.Conn{
               resp_body: "{\"message\":\"Invalid UUID\"}"
             } = response
    end
  end

  describe "show/2" do
    test "when there is a user with given id, show the user", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d9"

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      assert response == %{
               "user" => %{
                 "address" => "rua teste 1",
                 "age" => 27,
                 "cep" => "31260210",
                 "cpf" => "02577788622",
                 "email" => "teste123@teste.com",
                 "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
                 "name" => "Teste 2"
               }
             }
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:not_found)

      assert response == %{"message" => "User not found"}
    end
  end

  describe "list/2" do
    test "when call list users, show all users", %{conn: conn} do
      insert(:user)

      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(:ok)

      assert response == %{
               "users" => [
                 %{
                   "address" => "rua teste 1",
                   "age" => 27,
                   "cep" => "31260210",
                   "cpf" => "02577788622",
                   "email" => "teste123@teste.com",
                   "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
                   "name" => "Teste 2"
                 }
               ]
             }
    end
  end

  describe "update/2" do
    test "when there is a user with given id, update the user", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d9"

      params = %{
        "name" => "Teste 333"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, id, params))
        |> json_response(:ok)

      assert response == %{
               "user" => %{
                 "address" => "rua teste 1",
                 "age" => 27,
                 "cep" => "31260210",
                 "cpf" => "02577788622",
                 "email" => "teste123@teste.com",
                 "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
                 "name" => "Teste 333"
               },
               "message" => "User updated!"
             }
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      params = %{
        "name" => "Teste 333"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, id, params))
        |> json_response(:not_found)

      assert response == %{"message" => "User not found"}
    end
  end
end
