defmodule Budget.Scheam.Query.MeTest do
  use BudgetWeb.ConnCase, async: true

  @query """
  {
    me {
      email
    }
  }
  """

  @valid_attrs %{password: "some password", email: "username@example.com"}
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Budget.Accounts.create_user()

    user
  end

  test "me returns email" do
    user = user_fixture()
    session = BudgetWeb.AuthToken.sign(user)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{session}")
      |> get("/api", query: @query)

    assert %{
             "data" => %{
               "me" => %{
                 "email" => "username@example.com"
               }
             }
           } = json_response(conn, 200)
  end

  test "me returns an error if not signed in" do
    conn = get build_conn(), "/api", query: @query

    assert %{
             "data" => %{
               "me" => nil
             },
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Sign in before proceeding",
                 "path" => ["me"]
               }
             ]
           } = json_response(conn, 200)
  end
end
