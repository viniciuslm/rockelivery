defmodule Rockelivery.Users.List do
  alias Rockelivery.{Repo, User}

  def call do
    users = Repo.all(User)
    {:ok, users}
  end
end
