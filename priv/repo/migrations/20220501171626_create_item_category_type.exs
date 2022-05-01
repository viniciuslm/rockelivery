defmodule Rockelivery.Repo.Migrations.CreateItemCategoryType do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE item_category as ENUM ('food', 'drink', 'desert')"
    drop_query = "DROP TYPE item_category"
    execute(create_query, drop_query)
  end
end
