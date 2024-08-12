defmodule LatodoApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :details, :string
      add :order, :float
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
