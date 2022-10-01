defmodule GithubexWeb.Auth.Guardian do
  use Guardian, otp_app: :githubex

  alias Githubex.{Error, User}

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

  def authenticate(%{"id" => id, "password" => password}) do
    case Githubex.get_user_by_id(id) do
      {:ok, user} -> authenticate_user(user, password)
      {:error, _error_message} = error -> error
    end
  end

  defp authenticate_user(%User{password_hash: password_hash} = user, password) do
    case Pbkdf2.verify_pass(password, password_hash) do
      false -> {:error, Error.build(:unauthorized, "Password invalid")}
      true -> encode_and_sign(user, %{}, ttl: {1, :minute})
    end
  end
end
