defmodule LatodoApi.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :token, :text, null: false
      add :revoked, :boolean, default: false, null: false
      add :revoked_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:auth_tokens, [:token])
    create index(:auth_tokens, [:user_id])
  end
end
