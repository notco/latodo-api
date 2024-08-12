defmodule LatodoApi.Repo do
  use Ecto.Repo,
    otp_app: :latodo_api,
    adapter: Ecto.Adapters.Postgres
end
