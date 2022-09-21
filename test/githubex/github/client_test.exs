defmodule Githubex.Github.ClientTest do
  use ExUnit.Case, async: true

  alias Githubex.Error
  alias Githubex.Github.{Client, Response}
  alias Plug.Conn

  describe "get_repos/2" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when looking for valid user, returns its repos", %{bypass: bypass} do
      body = File.read!("test/support/responses/repos.json")

      username = "danilo-vieira"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_repos(url, username)

      expected_response =
        {:ok,
         [
           %Response{
             description:
               "Material necessário para realização do processamento de áudios para a disciplina Tópicos Especiais em Inteligência Artificial - UFPI",
             html_url: "https://github.com/danilo-vieira/audio_processing",
             id: 247_000_001,
             name: "audio_processing",
             stargazers_count: 0
           },
           %Response{
             description: nil,
             html_url: "https://github.com/danilo-vieira/be-the-hero_SemanaOmniStack11",
             id: 250_401_242,
             name: "be-the-hero_SemanaOmniStack11",
             stargazers_count: 1
           }
         ]}

      assert response == expected_response
    end

    test "when looking for non-existing user, returns error", %{bypass: bypass} do
      username = "i-am-not-an-existing-user"

      body = ~s({
        "message": "Not Found",
        "documentation_url": "https://docs.github.com/rest/reference/repos#list-repositories-for-a-user"
      })

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(404, body)
      end)

      response = Client.get_repos(url, username)

      expected_response = {:error, %Error{result: "User not found", status: :not_found}}

      assert response == expected_response
    end

    test "when there is unknown result, returns an error", %{bypass: bypass} do
      username = "error-user"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_repos(url, username)

      expected_response =
        {:error, %Error{result: "Could not fetch repos", status: :internal_server_error}}

      assert response == expected_response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
