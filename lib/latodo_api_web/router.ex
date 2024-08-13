defmodule LatodoApiWeb.Router do
  use LatodoApiWeb, :router
  import LatodoApi.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LatodoApiWeb do
    pipe_through [:api, :authenticate]
    resources "/tasks", TaskController, except: [:new, :edit]
  end

  scope "/sessions" do
    pipe_through :api
    post "/sign_in", LatodoApiWeb.SessionController, :create
    delete "/sign_out", LatodoApiWeb.SessionController, :delete
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :latodo_api,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "LA Todo API",
        basePath: "/api"
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "API Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        }
      }
    }
  end
end
