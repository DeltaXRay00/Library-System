defmodule LibrarySystemWeb.LoanLive.Index do
  use LibrarySystemWeb, :live_view

  alias LibrarySystem.Library
  alias LibrarySystem.Library.Loan

  def list_loans(opts \\ []) do
    Loan
    |> LibrarySystem.Repo.all()
    |> LibrarySystem.Repo.preload(Keyword.get(opts, :preload, []))
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :loans, list_loans(preload: [:book, :user]))}
  end


  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Loan")
    |> assign(:loan, Library.get_loan!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Loan")
    |> assign(:loan, %Loan{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Loans")
    |> assign(:loan, nil)
  end

  @impl true
  def handle_info({LibrarySystemWeb.LoanLive.FormComponent, {:saved, loan}}, socket) do
    loan = Library.get_loan!(loan.id, preload: [:user, :book])
    {:noreply, stream_insert(socket, :loans, loan)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    loan = Library.get_loan!(id)
    {:ok, _} = Library.delete_loan(loan)

    {:noreply, stream_delete(socket, :loans, loan)}
  end
end
