defmodule LatodoApiWeb.TaskControllerTest do
  use LatodoApiWeb.ConnCase

  import LatodoApi.TodosFixtures

  alias LatodoApi.Todos.Task
  alias LatodoApi.UserAuth

  @create_attrs %{
    status: "some status",
    title: "some title",
    details: "some details",
    order: 120.5
  }
  @update_attrs %{
    status: "some updated status",
    title: "some updated title",
    details: "some updated details",
    order: 456.7
  }
  @invalid_attrs %{status: nil, title: nil, details: nil, order: nil}

  setup %{conn: conn} do
    UserAuth.register(%{email: "test@email.com", password: "LawAdvisor2019!"})
    {:ok, token} = UserAuth.sign_in("test@email.com", "LawAdvisor2019!")
    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> token.token)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/api/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "details" => "some details",
               "order" => 120.5,
               "status" => "some status",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, ~p"/api/tasks/#{task}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "details" => "some updated details",
               "order" => 456.7,
               "status" => "some updated status",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/api/tasks/#{task}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/api/tasks/#{task}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tasks/#{task}")
      end
    end
  end

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end
end
