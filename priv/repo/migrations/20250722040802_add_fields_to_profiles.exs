defmodule LibrarySystem.Repo.Migrations.AddFieldsToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :full_name, :string
      add :phone_number, :string
      add :identity_card_number, :string
      add :gender, :string
    end
  end
end
