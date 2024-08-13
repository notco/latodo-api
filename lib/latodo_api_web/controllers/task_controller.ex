defmodule LatodoApiWeb.TaskController do
  use LatodoApiWeb, :controller

  alias LatodoApi.Todos
  alias LatodoApi.Todos.Task

  import Plug.Conn.Status, only: [code: 1]
  use PhoenixSwagger, except: [:delete]

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
    security([%{Bearer: []}])
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
    security([%{Bearer: []}])
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

  swagger_path :update do
    patch("/api/tasks/{id}")
    summary("Updates an existing task")
    description("Update an existing task with params")
    produces("application/json")
    security([%{Bearer: []}])
    operation_id("update_task")

    parameters do
      id(:path, :integer, "Task ID", required: true)
      task(:body, Schema.ref(:Task), "The task details to update")
    end

    response(200, "OK", Schema.ref(:Task))
    response(400, "Client Error")
  end

  def update(conn, %{"id" => id} = params) do
    task = Todos.get_task!(id)
    task_params = Map.drop(params, ["id"])

    with {:ok, %Task{} = task} <- Todos.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/tasks/{id}")
    summary("Delete a task")
    description("Remove a task from the system")
    operation_id("delete_task")
    security([%{Bearer: []}])

    parameters do
      id(:path, :string, "The id of the task", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, %{"id" => id}) do
    task = Todos.get_task!(id)

    with {:ok, %Task{}} <- Todos.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
