defmodule LibrarySystem.Repo.Migrations.CreateProfilesAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:profiles) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :utc_datetime
      add :full_name, :string
      add :phone_number, :string
      add :identity_card_number, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profiles, [:email])

    create table(:profiles_tokens) do
      add :credential_id, references(:profiles, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:profiles_tokens, [:credential_id])
    create unique_index(:profiles_tokens, [:context, :token])
  end
end
