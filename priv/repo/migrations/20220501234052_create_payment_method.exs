defmodule Rockelivery.Repo.Migrations.CreatePaymentMethod do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE payment_method as ENUM ('money', 'credit_card', 'debit_card')"
    drop_query = "DROP TYPE payment_method"
    execute(create_query, drop_query)
  end
end
