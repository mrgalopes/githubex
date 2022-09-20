defmodule Githubex.Github.Response do
  alias Githubex.Error

  @keys [:id, :name, :description, :html_url, :stargazers_count]

  @derive {Jason.Encoder, only: @keys}

  defstruct @keys

  def build(%{
        "id" => id,
        "name" => name,
        "description" => description,
        "html_url" => html_url,
        "stargazers_count" => stargazers_count
      }) do
    {:ok,
     %__MODULE__{
       id: id,
       name: name,
       description: description,
       html_url: html_url,
       stargazers_count: stargazers_count
     }}
  end

  def build(_params) do
    {:error, Error.build(:internal_server_error, "Mandatory arguments not sent by API")}
  end
end
