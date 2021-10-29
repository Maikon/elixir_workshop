defmodule Rupi.Repo do
  use Ecto.Repo,
    otp_app: :rupi,
    adapter: Ecto.Adapters.Postgres
end
