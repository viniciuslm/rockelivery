defmodule Rockelivery.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rockelivery.{Item, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:address, :comments, :payment_method, :user_id]
  @payments_methos [:money, :credit_card, :debit_card]

  @derive {Jason.Encoder, only: [:id] ++ @required_params}

  schema "orders" do
    field :address, :string
    field :comments, :decimal
    field :payment_method, Ecto.Enum, values: @payments_methos

    many_to_many :items, Item, join_through: "orders_items"
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params, items) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> put_assoc(:item, items)
    |> validate_length(:address, min: 16)
  end
end
