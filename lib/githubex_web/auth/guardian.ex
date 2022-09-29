defmodule GithubexWeb.Auth.Guardian do
  use Guardian, otp_app: :githubex

  alias Githubex.User

  def subject_for_token(%User{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    Githubex.get_user_by_id(id)
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
