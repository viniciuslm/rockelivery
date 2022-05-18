defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Create
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "when all params are valid, retuns the user" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response = Create.call(params)

      assert {:ok, %User{id: _id, age: 27, email: "teste123@teste.com"}} = response
    end

    test "when there are invalid params, retuns an error" do
      params = build(:user_params, %{"age" => 12, "password" => "1234"})

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end

    test "when cep is invalid, retuns an error" do
      params = build(:user_params, %{"cep" => "12349999"})

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:error, Error.build(:not_found, "CEP not found!")}
      end)

      response = Create.call(params)

      assert {:error, %Error{status: :not_found, result: "CEP not found!"}} == response
    end
  end
end
