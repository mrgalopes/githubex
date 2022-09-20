defmodule Githubex.Repo do
  use Ecto.Repo,
    otp_app: :githubex,
    adapter: Ecto.Adapters.Postgres
end
