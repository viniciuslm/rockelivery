defmodule Rockelivery.Users.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Delete

  describe "call/1" do
    test "when there is a user with given id, delete the user" do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d9"

      response = Delete.call(id)

      assert {:ok, %User{id: _id, age: 27, email: "teste123@teste.com"}} = response
    end

    test "when there is a user without given id, returns an error" do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response = Delete.call(id)

      expected_response = "User not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end
  end
end
