defmodule LatodoApiWeb.SessionJSON do
  alias LatodoApi.AuthToken

  @doc """
  Renders a single auth_token.
  """
  def show(%{auth_token: auth_token}) do
    %{data: data(auth_token)}
  end

  defp data(%AuthToken{} = auth_token) do
    %{
      id: auth_token.id,
      token: auth_token.token
    }
  end
end
