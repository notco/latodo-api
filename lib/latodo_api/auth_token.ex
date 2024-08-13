defmodule LatodoApi.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_tokens" do
    field :token, :string
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime

    belongs_to :user, LatodoApi.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
