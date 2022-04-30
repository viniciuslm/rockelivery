defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      address: "rua teste 1",
      age: 27,
      cep: "31260210",
      cpf: "02577788622",
      email: "teste123@teste.com",
      password: "123456",
      name: "Teste 2"
    }
  end

  def user_factory do
    %User{
      address: "rua teste 1",
      age: 27,
      cep: "31260210",
      cpf: "02577788622",
      email: "teste123@teste.com",
      password: "123456",
      name: "Teste 2",
      id: "7d8972e2-62ff-40fa-8c28-2623620dd3d9"
    }
  end
end
