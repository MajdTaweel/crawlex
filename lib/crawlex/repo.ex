defmodule Crawlex.Repo do
  use Ecto.Repo,
    otp_app: :crawlex,
    adapter: Ecto.Adapters.Postgres
end
