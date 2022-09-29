defmodule GithubexWeb.UsersController do
  use GithubexWeb, :controller

  alias GithubexWeb.Auth.Guardian
  alias GithubexWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, user} <- Githubex.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def sign_in(conn, params) do
    with {:ok, token, _claims} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end
end
