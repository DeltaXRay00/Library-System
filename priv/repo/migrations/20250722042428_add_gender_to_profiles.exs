defmodule LibrarySystem.Repo.Migrations.AddGenderToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :gender, :string
    end
  end
end
