defmodule Crawlex.Middlewares.UserAgent do
  @moduledoc """
  Set/Rotate user agents for crawling. The user agents are read from
  :crawly, :user_agents sessions.
  """

  def run(request, state) do
    new_headers = List.keydelete(request.headers, "User-Agent", 0)

    Pumba.load("Firefox")
    Pumba.load("Chrome")
    Pumba.load("Safari")
    user_agent = Pumba.random()

    new_request = Map.put(request, :headers, [{"User-Agent", user_agent} | new_headers])

    {new_request, state}
  end
end
