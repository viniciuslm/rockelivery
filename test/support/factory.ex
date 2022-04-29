defmodule Rockelivery.Factory do
  use ExMachina

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
end
