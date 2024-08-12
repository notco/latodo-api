defmodule LatodoApiWeb.Router do
  use LatodoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LatodoApiWeb do
    pipe_through :api
    resources "/tasks", TaskController, except: [:new, :edit]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :latodo_api,
      swagger_file: "swagger.json"
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:latodo_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LatodoApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "LA Todo API",
        basePath: "/api"
      }
    }
  end
end
