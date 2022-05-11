defmodule Rockelivery.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rockelivery.Order

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:category, :description, :photo, :price]
  @items_categories [:food, :drink, :desert]

  @derive {Jason.Encoder, only: [:id] ++ @required_params}

  schema "items" do
    field :category, Ecto.Enum, values: @items_categories
    field :description, :string
    field :price, :decimal
    field :photo, :string

    many_to_many :orders, Order, join_through: "orders_items"

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: 6)
    |> check_erros
  end

  defp check_erros(%{valid?: false, errors: errors} = changeset) do
    check_erro_price(List.keymember?(errors, :price, 0), changeset)
  end

  defp check_erros(changeset), do: validate_price(changeset)

  defp check_erro_price(true, changeset), do: changeset

  defp check_erro_price(false, changeset), do: validate_price(changeset)

  defp validate_price(changeset) do
    zero = Decimal.new("0.0")

    get_field(changeset, :price)
    |> Decimal.compare(zero)
    |> validate_price_granter_than_zero(changeset)
  end

  defp validate_price_granter_than_zero(:gt, changeset), do: changeset

  defp validate_price_granter_than_zero(_, changeset),
    do: add_error(changeset, :price, "the price must be greater than 0")
end
