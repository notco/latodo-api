defmodule LatodoApiWeb.ErrorJSONTest do
  use LatodoApiWeb.ConnCase, async: true

  test "renders 404" do
    assert LatodoApiWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert LatodoApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
