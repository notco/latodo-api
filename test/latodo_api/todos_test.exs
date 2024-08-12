defmodule LatodoApi.TodosTest do
  use LatodoApi.DataCase

  alias LatodoApi.Todos

  describe "tasks" do
    alias LatodoApi.Todos.Task

    import LatodoApi.TodosFixtures

    @invalid_attrs %{status: nil, title: nil, details: nil, order: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todos.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Todos.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{status: "some status", title: "some title", details: "some details", order: 120.5}

      assert {:ok, %Task{} = task} = Todos.create_task(valid_attrs)
      assert task.status == "some status"
      assert task.title == "some title"
      assert task.details == "some details"
      assert task.order == 120.5
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{status: "some updated status", title: "some updated title", details: "some updated details", order: 456.7}

      assert {:ok, %Task{} = task} = Todos.update_task(task, update_attrs)
      assert task.status == "some updated status"
      assert task.title == "some updated title"
      assert task.details == "some updated details"
      assert task.order == 456.7
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_task(task, @invalid_attrs)
      assert task == Todos.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Todos.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Todos.change_task(task)
    end
  end
end
