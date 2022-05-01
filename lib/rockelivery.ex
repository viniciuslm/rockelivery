defmodule Rockelivery do
  @moduledoc """
  Rockelivery keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Items.Delete, as: ItemDelete
  alias Rockelivery.Items.Get, as: ItemGet
  alias Rockelivery.Items.List, as: ItemList
  alias Rockelivery.Items.Update, as: ItemUpdate
  alias Rockelivery.Users.Create, as: UserCreate
  alias Rockelivery.Users.Delete, as: UserDelete
  alias Rockelivery.Users.Get, as: UserGet
  alias Rockelivery.Users.List, as: UserList
  alias Rockelivery.Users.Update, as: UserUpdate

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate delete_user(id), to: UserDelete, as: :call
  defdelegate get_user(id), to: UserGet, as: :by_id
  defdelegate list_users, to: UserList, as: :call
  defdelegate update_user(params), to: UserUpdate, as: :call

  defdelegate create_item(params), to: ItemCreate, as: :call
  defdelegate delete_item(id), to: ItemDelete, as: :call
  defdelegate get_item(id), to: ItemGet, as: :by_id
  defdelegate list_items, to: ItemList, as: :call
  defdelegate update_item(params), to: ItemUpdate, as: :call
end
