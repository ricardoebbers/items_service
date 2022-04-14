defmodule ItemsService.Repo do
  use Ecto.Repo,
    otp_app: :items_service,
    adapter: Ecto.Adapters.Postgres
end
