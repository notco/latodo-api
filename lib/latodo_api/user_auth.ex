defmodule LatodoApi.UserAuth do
  use LatodoApiWeb, :verified_routes

  import Plug.Conn

  alias LatodoApi.Repo
  alias LatodoApi.User

  # These values must be moved in a configuration file
  # generator for secret 
  # :crypto.strong_rand_bytes(30) 
  # |> Base.url_encode64 
  # |> binary_part(0, 30)

  def authenticate(conn, _default) do
    case get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(LatodoApi.AuthToken, %{token: token, revoked: false})
             |> Repo.preload(:user) do
          nil -> unauthorized(conn)
          auth_token -> authorized(conn, auth_token.user)
        end

      _ ->
        unauthorized(conn)
    end
  end

  def generate_token(id) do
    seed = System.get_env("TOKEN_SEED")
    secret = System.get_env("TOKEN_SECRET")
    Phoenix.Token.sign(secret, seed, id, max_age: 86400)
  end

  def verify_token(token) do
    seed = System.get_env("TOKEN_SEED")
    secret = System.get_env("TOKEN_SECRET")

    case Phoenix.Token.verify(secret, seed, token, max_age: 86400) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  def register(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))

      err ->
        err
    end
  end

  def sign_out(conn) do
    case get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(LatodoApi.AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      error ->
        error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
      _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")

    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end

  defp authorized(conn, user) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn |> send_resp(401, "Unauthorized") |> halt()
  end
end
