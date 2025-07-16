defmodule LibrarySystemWeb.ErrorJSONTest do
  use LibrarySystemWeb.ConnCase, async: true

  test "renders 404" do
    assert LibrarySystemWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert LibrarySystemWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
