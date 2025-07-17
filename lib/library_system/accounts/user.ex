defmodule LibrarySystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LibrarySystem.Repo

  schema "users" do
    field :name, :string
    field :age, :integer

    has_many :loans, LibrarySystem.Library.Loan

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end

  def get_user_with_loans!(id) do
    LibrarySystem.Accounts.User
    |> Repo.get!(id)
    |> Repo.preload(loans: [:book])
  end

end
