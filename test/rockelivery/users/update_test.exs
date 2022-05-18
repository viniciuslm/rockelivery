defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Update
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "when there is a user with given id, update the user" do
      insert(:user)

      params = %{
        "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
        "email" => "teste1232@teste.com",
        "cep" => "30180061"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response = Update.call(params)

      assert {:ok, %User{id: _id, age: 27, email: "teste1232@teste.com"}} = response
    end

    test "when there is a user without given id, returns an error" do
      insert(:user)

      params = %{
        "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d1",
        "email" => "teste1232@teste.com"
      }

      response = Update.call(params)

      expected_response = "User not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end

    test "when there are invalid params, retuns an error" do
      insert(:user)

      params = %{
        "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
        "age" => 12,
        "password" => "1234"
      }

      response = Update.call(params)

      assert {:error, _changeset} = response
    end

    test "when cep is invalid, retuns an error" do
      insert(:user)

      params = %{
        "id" => "ff295d64-4afe-4089-b4ea-e5e8528080ab",
        "cep" => "12349999"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:error, Error.build(:not_found, "CEP not found!")}
      end)

      response = Update.call(params)

      assert {:error, %Error{status: :not_found, result: "CEP not found!"}} == response
    end
  end
end
