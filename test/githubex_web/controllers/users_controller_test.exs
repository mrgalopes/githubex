defmodule GithubexWeb.UsersControllerTest do
  use GithubexWeb.ConnCase, async: true

  describe "create/2" do
    test "when given parameters, should create user", %{conn: conn} do
      params = %{password: "123456"}

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{"id" => _id} = response
    end

    test "when parameters are not given, return bad request", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"message" => %{"password" => ["can't be blank"]}} = response
    end
  end
end
