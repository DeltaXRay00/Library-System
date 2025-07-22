defmodule LibrarySystemWeb.Router do
  use LibrarySystemWeb, :router

  import LibrarySystemWeb.CredentialAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LibrarySystemWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_credential
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LibrarySystemWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", LibrarySystemWeb do
    pipe_through [:browser, :require_authenticated_credential]

    live_session :require_authenticated_credential,
      on_mount: [{LibrarySystemWeb.CredentialAuth, :ensure_authenticated}] do
      # User, Book, Loan pages
      live "/users", UserLive.Index, :index
      live "/users/new", UserLive.Index, :new
      live "/users/:id/edit", UserLive.Index, :edit
      live "/users/:id", UserLive.Show, :show
      live "/users/:id/show/edit", UserLive.Show, :edit

      live "/books", BookLive.Index, :index
      live "/books/new", BookLive.Index, :new
      live "/books/:id/edit", BookLive.Index, :edit
      live "/books/:id", BookLive.Show, :show
      live "/books/:id/show/edit", BookLive.Show, :edit

      live "/loans", LoanLive.Index, :index
      live "/loans/new", LoanLive.Index, :new
      live "/loans/:id/edit", LoanLive.Index, :edit
      live "/loans/:id", LoanLive.Show, :show
      live "/loans/:id/show/edit", LoanLive.Show, :edit

      # Profile settings pages
      live "/profiles/settings", CredentialSettingsLive, :edit
      live "/profiles/settings/confirm_email/:token", CredentialSettingsLive, :confirm_email
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", LibrarySystemWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:library_system, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LibrarySystemWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LibrarySystemWeb do
    pipe_through [:browser, :redirect_if_credential_is_authenticated]

    live_session :redirect_if_credential_is_authenticated,
      on_mount: [{LibrarySystemWeb.CredentialAuth, :redirect_if_credential_is_authenticated}] do
      live "/profiles/register", CredentialRegistrationLive, :new
      live "/profiles/log_in", CredentialLoginLive, :new
      live "/profiles/reset_password", CredentialForgotPasswordLive, :new
      live "/profiles/reset_password/:token", CredentialResetPasswordLive, :edit
    end

    post "/profiles/log_in", CredentialSessionController, :create
  end

  scope "/", LibrarySystemWeb do
    pipe_through [:browser]

    delete "/profiles/log_out", CredentialSessionController, :delete

    live_session :current_credential,
      on_mount: [{LibrarySystemWeb.CredentialAuth, :mount_current_credential}] do
      live "/profiles/confirm/:token", CredentialConfirmationLive, :edit
      live "/profiles/confirm", CredentialConfirmationInstructionsLive, :new
    end
  end
end
