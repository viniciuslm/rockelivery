defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build :user_params

      response = User.changeset(params)

      assert %Changeset{changes: %{
        cpf: "02577788622",
        email: "teste123@teste.com",
        name: "Teste 2"
      }, valid?: true} = response
    end
    test "when update a changeset, returns a valid changeset with the given changes" do
      params = build(:user_params)

      update_params = %{
        name: "Teste 3"
      }

      response = User.changeset(params) |> User.changeset(update_params)

      assert %Changeset{changes: %{
        name: "Teste 3"
      }, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:user_params, %{ age: 12, password: "1234"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
