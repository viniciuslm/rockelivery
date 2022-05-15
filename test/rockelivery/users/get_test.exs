defmodule Rockelivery.Users.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Get

  describe "call/1" do
    test "when there is a user with given id, get the user" do
      insert(:user)
      id = "ff295d64-4afe-4089-b4ea-e5e8528080ab"

      response = Get.by_id(id)

      assert {:ok, %User{id: _id, age: 27, email: "teste123@teste.com"}} = response
    end

    test "when there is a user without given id, returns an error" do
      insert(:user)
      id = "7d8972e2-62ff-40fa-8c28-2623620dd3d1"

      response = Get.by_id(id)

      expected_response = "User not found"

      assert {:error, %Error{status: :not_found, result: result}} = response
      assert result == expected_response
    end
  end
end
