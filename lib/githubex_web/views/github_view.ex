defmodule GithubexWeb.GithubView do
  use GithubexWeb, :view

  def render("repos.json", %{repos: repos}) do
    %{
      repos: repos
    }
  end
end
