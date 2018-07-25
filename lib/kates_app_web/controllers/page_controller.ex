defmodule KatesAppWeb.PageController do
  use KatesAppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
