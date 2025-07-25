defmodule LibrarySystemWeb.LoanLiveTest do
  use LibrarySystemWeb.ConnCase

  import Phoenix.LiveViewTest
  import LibrarySystem.LibraryFixtures

  @create_attrs %{books: "some books", borrowed_at: "2025-07-15T03:45:00", due_at: "2025-07-15T03:45:00", returned_at: "2025-07-15T03:45:00"}
  @update_attrs %{books: "some updated books", borrowed_at: "2025-07-16T03:45:00", due_at: "2025-07-16T03:45:00", returned_at: "2025-07-16T03:45:00"}
  @invalid_attrs %{books: nil, borrowed_at: nil, due_at: nil, returned_at: nil}

  defp create_loan(_) do
    loan = loan_fixture()
    %{loan: loan}
  end

  describe "Index" do
    setup [:create_loan]

    test "lists all loans", %{conn: conn, loan: loan} do
      {:ok, _index_live, html} = live(conn, ~p"/loans")

      assert html =~ "Listing Loans"
      assert html =~ loan.books
    end

    test "saves new loan", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert index_live |> element("a", "New Loan") |> render_click() =~
               "New Loan"

      assert_patch(index_live, ~p"/loans/new")

      assert index_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#loan-form", loan: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/loans")

      html = render(index_live)
      assert html =~ "Loan created successfully"
      assert html =~ "some books"
    end

    test "updates loan in listing", %{conn: conn, loan: loan} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert index_live |> element("#loans-#{loan.id} a", "Edit") |> render_click() =~
               "Edit Loan"

      assert_patch(index_live, ~p"/loans/#{loan}/edit")

      assert index_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#loan-form", loan: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/loans")

      html = render(index_live)
      assert html =~ "Loan updated successfully"
      assert html =~ "some updated books"
    end

    test "deletes loan in listing", %{conn: conn, loan: loan} do
      {:ok, index_live, _html} = live(conn, ~p"/loans")

      assert index_live |> element("#loans-#{loan.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#loans-#{loan.id}")
    end
  end

  describe "Show" do
    setup [:create_loan]

    test "displays loan", %{conn: conn, loan: loan} do
      {:ok, _show_live, html} = live(conn, ~p"/loans/#{loan}")

      assert html =~ "Show Loan"
      assert html =~ loan.books
    end

    test "updates loan within modal", %{conn: conn, loan: loan} do
      {:ok, show_live, _html} = live(conn, ~p"/loans/#{loan}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Loan"

      assert_patch(show_live, ~p"/loans/#{loan}/show/edit")

      assert show_live
             |> form("#loan-form", loan: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#loan-form", loan: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/loans/#{loan}")

      html = render(show_live)
      assert html =~ "Loan updated successfully"
      assert html =~ "some updated books"
    end
  end
end
