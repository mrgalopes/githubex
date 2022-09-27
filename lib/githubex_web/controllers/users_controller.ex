defmodule GithubexWeb.UsersController do
  use GithubexWeb, :controller

  alias GithubexWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, user} <- Githubex.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
