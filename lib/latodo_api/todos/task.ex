defmodule LatodoApi.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, :string
    field :title, :string
    field :details, :string
    field :order, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :details, :order, :status])
    |> validate_required([:title, :details, :order, :status])
  end
end
