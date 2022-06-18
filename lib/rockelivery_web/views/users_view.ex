defmodule RockeliveryWeb.UsersView do
  use RockeliveryWeb, :view
  alias Rockelivery.User

  def render("create.json", %{user: %User{} = user, token: token}) do
    %{
      message: "User created!",
      user: user,
      token: token
    }
  end

  def render("delete.json", %{user: %User{} = user}), do: %{user: user}

  def render("index.json", %{users: users}), do: %{users: users}

  def render("show.json", %{user: %User{} = user}), do: %{user: user}

  def render("sign_in.json", %{token: token}), do: %{token: token}

  def render("update.json", %{user: %User{} = user}) do
    %{
      message: "User updated!",
      user: user
    }
  end
end
