defmodule RupiWeb.PageController do
  use RupiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
