defmodule LatodoApiWeb.SessionController do
  use LatodoApiWeb, :controller
  alias LatodoApi.UserAuth

  def create(conn, %{"email" => email, "password" => password}) do
    case UserAuth.sign_in(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render(:show, auth_token: auth_token)

      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def delete(conn, _) do
    case UserAuth.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end
end
