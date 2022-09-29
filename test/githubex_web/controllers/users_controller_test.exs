defmodule GithubexWeb.UsersControllerTest do
  use GithubexWeb.ConnCase, async: true

  alias Githubex.User
  alias GithubexWeb.Auth.Guardian

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

  describe "sign_in/2" do
    test "when id is not found, returns bad request", %{conn: conn} do
      params = %{"id" => Ecto.UUID.generate(), "password" => "123456"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"result" => "User not found"} = response
    end

    test "when password is incorrect, return unauthorized", %{conn: conn} do
      {:ok, %User{id: id}} = Githubex.create_user(%{"password" => "123456"})
      params = %{"id" => id, "password" => "654321"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:unauthorized)

      assert %{"result" => "Password invalid"} = response
    end

    test "when password is correct, returns token", %{conn: conn} do
      {:ok, %User{id: id}} = Githubex.create_user(%{"password" => "123456"})
      params = %{"id" => id, "password" => "123456"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"token" => token} = response
      assert {:ok, %User{id: ^id}, _claims} = Guardian.resource_from_token(token)
    end
  end
end
