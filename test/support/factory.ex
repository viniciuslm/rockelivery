defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.{Item, Order, User}

  def user_params_factory do
    %{
      "address" => "rua teste 1",
      "age" => 27,
      "cep" => "31260210",
      "cpf" => "02577788622",
      "email" => "teste123@teste.com",
      "password" => "123456",
      "name" => "Teste 2"
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
      id: "ff295d64-4afe-4089-b4ea-e5e8528080ab"
    }
  end

  def item_params_factory do
    %{
      "category" => "drink",
      "description" => "cerveja",
      "price" => "15.00",
      "photo" => "cerveja.png"
    }
  end

  def item_factory do
    %Item{
      category: "drink",
      description: "cerveja",
      price: "15.00",
      photo: "cerveja.png",
      id: "d097e758-c0c7-4215-af97-334b6ac933e1"
    }
  end

  def order_params_factory do
    user = build(:user)
    item = build(:item)

    %{
      "address" => "Rua teste, 15",
      "comments" => "Teste de comentario",
      "payment_method" => "money",
      "user_id" => user.id,
      "items" => [
        %{
          "id" => item.id,
          "quantity" => "1"
        }
      ]
    }
  end

  def order_factory do
    user = build(:user)
    item = build(:item)

    %Order{
      id: "2fb4d7d6-1b16-436e-aaa5-7f91a41d9564",
      address: "Rua teste, 15",
      comments: "Teste de comentario",
      payment_method: "money",
      user_id: user.id,
      items: [item]
    }
  end
end
