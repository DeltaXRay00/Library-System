defmodule LibrarySystem.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LibrarySystem.Library` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        isbn: "some isbn",
        published_at: ~D[2025-07-15],
        title: "some title"
      })
      |> LibrarySystem.Library.create_book()

    book
  end

  @doc """
  Generate a loan.
  """
  def loan_fixture(attrs \\ %{}) do
    {:ok, loan} =
      attrs
      |> Enum.into(%{
        books: "some books",
        borrowed_at: ~N[2025-07-15 03:45:00],
        due_at: ~N[2025-07-15 03:45:00],
        returned_at: ~N[2025-07-15 03:45:00]
      })
      |> LibrarySystem.Library.create_loan()

    loan
  end
end
