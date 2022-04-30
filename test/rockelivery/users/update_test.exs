defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Update

  describe "call/1" do
    test "when there is a user with given id, update the user" do
      insert(:user)

      params = %{
        "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
        "email" => "teste1232@teste.com"
      }

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
        "id" => "7d8972e2-62ff-40fa-8c28-2623620dd3d9",
        "age" => 12,
        "password" => "1234"
      }

      response = Update.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, changeset} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
