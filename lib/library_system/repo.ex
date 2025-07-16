defmodule LibrarySystem.Repo do
  use Ecto.Repo,
    otp_app: :library_system,
    adapter: Ecto.Adapters.Postgres
end
