defmodule GithubexWeb.GithubController do
  use GithubexWeb, :controller

  alias GithubexWeb.FallbackController

  action_fallback FallbackController

  def show(conn, %{"username" => username}) do
    with {:ok, repos} <- Githubex.get_github_repos(username) do
      conn
      |> put_status(:ok)
      |> render("repos.json", repos: repos)
    end
  end
end
