defmodule GithubexWeb.GithubController do
  use GithubexWeb, :controller

  alias GithubexWeb.Auth.Guardian
  alias GithubexWeb.FallbackController

  action_fallback FallbackController

  def show(conn, %{"username" => username}) do
    with {:ok, repos} <- Githubex.get_github_repos(username),
         {:ok, _old_stuff, {new_token, _new_claims}} <-
           Guardian.refresh(Guardian.Plug.current_token(conn)) do
      conn
      |> put_status(:ok)
      |> render("repos.json", repos: repos, token: new_token)
    end
  end
end
