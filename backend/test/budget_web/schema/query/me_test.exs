defmodule Budget.Scheam.Query.MeTest do
  use BudgetWeb.ConnCase, async: true

  @query """
  {
    me {
      email
    }
  }
  """

  @valid_attrs %{password: "some password", username: "username@example.com"}
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  test "me returns email" do
    conn = get build_conn(), "/api", query: @query

    assert %{
             "data" => %{
               "me" => %{
                 "email" => "username@example.com"
               }
             }
           } = json_response(conn, 200)
  end
end
