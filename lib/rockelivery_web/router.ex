defmodule RockeliveryWeb.Router do
  use RockeliveryWeb, :router

  alias RockeliveryWeb.Plugs.UUIDChecker

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug RockeliveryWeb.Auth.Pipeline
  end

  scope "/api", RockeliveryWeb do
    pipe_through [:api, :auth]

    resources "/users", UsersController, except: [:new, :edit, :create]

    resources "/items", ItemsController, except: [:new, :edit]
    resources "/orders", OrdersController, except: [:new, :edit, :update]
  end

  scope "/api", RockeliveryWeb do
    pipe_through :api

    post "/users/", UsersController, :create
    post "/users/signin", UsersController, :sign_in
  end

  # coveralls-ignore-start
  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # coveralls-ignore-stop
end
