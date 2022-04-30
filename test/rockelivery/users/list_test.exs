defmodule Rockelivery.Users.ListTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.User
  alias Rockelivery.Users.List

  describe "list/1" do
    test "when call list users, show all users" do
      insert(:user)

      response = List.call()

      assert {:ok, [%User{id: _id, age: 27, email: "teste123@teste.com"}]} = response
    end
  end
end
