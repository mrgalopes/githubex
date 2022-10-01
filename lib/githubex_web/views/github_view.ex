defmodule GithubexWeb.GithubView do
  use GithubexWeb, :view

  def render("repos.json", %{repos: repos, token: token}) do
    %{
      repos: repos,
      token: token
    }
  end
end
