defmodule LatodoApi.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LatodoApi.Todos` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        details: "some details",
        order: 120.5,
        status: "some status",
        title: "some title"
      })
      |> LatodoApi.Todos.create_task()

    task
  end
end
