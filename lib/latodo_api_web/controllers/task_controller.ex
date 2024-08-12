defmodule LatodoApiWeb.TaskController do
  use LatodoApiWeb, :controller

  alias LatodoApi.Todos
  alias LatodoApi.Todos.Task

  import Plug.Conn.Status, only: [code: 1]
  use PhoenixSwagger

  action_fallback LatodoApiWeb.FallbackController

  def swagger_definitions do
    %{
      Task:
        swagger_schema do
          title("Task")
          description("A task of the application")

          properties do
            title(:string, "Task title", required: true)
            details(:string, "Task details", required: true)
            status(:string, "Task status", required: true)
            order(:number, "Task order", required: true)
          end
        end
    }
  end

  swagger_path :index do
    get("/api/tasks")
    description("List of tasks")
    response(code(:ok), "Success")
  end

  def index(conn, _params) do
    tasks = Todos.list_tasks()
    render(conn, :index, tasks: tasks)
  end

  swagger_path :create do
    post("/api/tasks")
    summary("Create tasks")
    description("Create tasks with params")
    produces("application/json")
    operation_id("create_tasks")

    parameters do
      title(:query, :string, "Title", required: true)
      details(:query, :string, "Details", required: true)
      order(:query, :number, "Order", required: true)
      status(:query, :string, "Status", required: true)
    end

    response(200, "OK", Schema.ref(:Task))
    response(400, "Client Error")
  end

  def create(conn, params) do
    with {:ok, %Task{} = task} <- Todos.create_task(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todos.get_task!(id)
    render(conn, :show, task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todos.get_task!(id)

    with {:ok, %Task{} = task} <- Todos.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todos.get_task!(id)

    with {:ok, %Task{}} <- Todos.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
