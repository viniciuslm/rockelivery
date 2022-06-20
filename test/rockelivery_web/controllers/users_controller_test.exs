defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.ViaCep.ClientMock
  alias RockeliveryWeb.Auth.Guardian

  describe "create/2" do
    test "when all params are valid, create the user", %{conn: conn} do
      params = %{
        "address" => "rua teste 1",
        "age" => 27,
        "cep" => "31260210",
        "cpf" => "02577788621",
        "email" => "teste121@teste.com",
        "password" => "123456",
        "name" => "Teste 2"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

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
                 "cpf" => "02577788621",
                 "email" => "teste121@teste.com",
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

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

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
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when there is a user with given id, delete the user", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080ab"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080a1"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert response == %{"message" => "User not found"}
    end

    test "when there is a invalid id, returns an error", %{conn: conn} do
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
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when there is a user with given id, show the user", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080ab"

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
                 "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
                 "name" => "Teste 2"
               }
             }
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080a1"

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:not_found)

      assert response == %{"message" => "User not found"}
    end
  end

  describe "list/2" do
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when call list users, show all users", %{conn: conn} do
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
                   "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
                   "name" => "Teste 2"
                 }
               ]
             }
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when there is a user with given id, update the user", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080ab"

      params = %{
        "name" => "Teste 333"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

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
                 "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
                 "name" => "Teste 333"
               },
               "message" => "User updated!"
             }
    end

    test "when there is a user without given id, returns an error", %{conn: conn} do
      id = "ff295d64-4afe-4089-b4ea-e5e8528080a1"

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
