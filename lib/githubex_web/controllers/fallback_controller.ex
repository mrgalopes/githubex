defmodule GithubexWeb.FallbackController do
  use GithubexWeb, :controller

  alias Githubex.Error
  alias GithubexWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
