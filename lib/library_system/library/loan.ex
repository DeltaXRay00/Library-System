defmodule LibrarySystem.Library.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :books, :string
    field :borrowed_at, :naive_datetime
    field :due_at, :naive_datetime
    field :returned_at, :naive_datetime

    belongs_to :user, LibrarySystem.Accounts.User
    belongs_to :book, LibrarySystem.Library.Book



    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:user_id, :book_id, :borrowed_at, :due_at, :returned_at])
    |> validate_required([:user_id, :book_id, :borrowed_at, :due_at])
    |> cast_assoc(:user)
    |> cast_assoc(:book)
    |> validate_optional_datetime(:returned_at)
  end

  defp validate_optional_datetime(changeset, field) do
    case get_change(changeset, field) do
      "" -> put_change(changeset, field, nil)
      _ -> changeset
    end
  end
end
