defmodule Rockelivery.Users.Update do
  alias Rockelivery.{Error, Repo, User}

  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> do_update(user, params)
    end
  end

  defp do_update(user, %{"cep" => cep} = params) do
    changeset = User.changeset(user, params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, _cep_info} <- client().get_cep_info(cep),
         {:ok, %User{}} = user <- update_user(changeset) do
      user
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end

  defp do_update(user, params) do
    changeset = User.changeset(user, params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, %User{}} = user <- update_user(changeset) do
      user
    else
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end

  defp update_user(changeset) do
    changeset
    |> Repo.update()
  end

  defp client do
    :rockelivery
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:via_cep_adapter)
  end
end
