defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  alias ConduitWeb.Plugs

  pipeline :api do
    plug(:accepts, ["json"])

    plug(Guardian.Plug.Pipeline,
      error_handler: ConduitWeb.ErrorHandler,
      module: Conduit.Auth.Guardian
    )

    plug(Guardian.Plug.VerifyHeader, realm: "Token")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  scope "/api", ConduitWeb do
    pipe_through(:api)
    get("/user", UserController, :current)
    post("/users/login", SessionController, :create)
    post("/users", UserController, :create)
    put("/user", UserController, :update)
  end
end
