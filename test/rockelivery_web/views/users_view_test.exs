defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  import Rockelivery.Factory

  alias RockeliveryWeb.UsersView

  test "create.json" do
    user = build(:user)

    assert %{
             message: "User created!",
             user: %Rockelivery.User{
               address: "rua teste 1",
               age: 27,
               cep: "31260210",
               cpf: "02577788622",
               email: "teste123@teste.com",
               id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
               inserted_at: nil,
               name: "Teste 2",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = render(UsersView, "create.json", user: user)
  end

  test "show.json" do
    user = build(:user)

    assert %{
             user: %Rockelivery.User{
               address: "rua teste 1",
               age: 27,
               cep: "31260210",
               cpf: "02577788622",
               email: "teste123@teste.com",
               id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
               inserted_at: nil,
               name: "Teste 2",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = render(UsersView, "show.json", user: user)
  end

  test "update.json" do
    user = build(:user)

    assert %{
             message: "User updated!",
             user: %Rockelivery.User{
               address: "rua teste 1",
               age: 27,
               cep: "31260210",
               cpf: "02577788622",
               email: "teste123@teste.com",
               id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
               inserted_at: nil,
               name: "Teste 2",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = render(UsersView, "update.json", user: user)
  end

  test "delete.json" do
    user = build(:user)

    assert %{
             user: %Rockelivery.User{
               address: "rua teste 1",
               age: 27,
               cep: "31260210",
               cpf: "02577788622",
               email: "teste123@teste.com",
               id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
               inserted_at: nil,
               name: "Teste 2",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = render(UsersView, "delete.json", user: user)
  end

  test "index.json" do
    user = build(:user)

    assert %{
             users: [
               %Rockelivery.User{
                 address: "rua teste 1",
                 age: 27,
                 cep: "31260210",
                 cpf: "02577788622",
                 email: "teste123@teste.com",
                 id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
                 inserted_at: nil,
                 name: "Teste 2",
                 password: "123456",
                 password_hash: nil,
                 updated_at: nil
               }
             ]
           } = render(UsersView, "index.json", users: [user])
  end
end
