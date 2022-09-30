defmodule GithubexWeb.GithubControllerTest do
  use GithubexWeb.ConnCase, async: true

  alias Githubex.User
  alias GithubexWeb.Auth.Guardian

  describe "show/2" do
    test "when token is not sent, return unauthorized", %{conn: conn} do
      username = "torvalds"

      conn
      |> get(Routes.github_path(conn, :show, username))
      |> json_response(:unauthorized)
    end

    test "when token is sent, returns the repos", %{conn: conn} do
      {:ok, %User{} = user} = Githubex.create_user(%{password: "123456"})

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      username = "torvalds"

      # TODO stop using real path to make request
      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(Routes.github_path(conn, :show, username))
        |> json_response(:ok)

      assert %{"repos" => _repos} = response
    end
  end
end
