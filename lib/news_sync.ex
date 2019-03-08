defmodule NewsSync do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()

    {:ok, state}
  end

  def handle_info(:fetch_top_posts, state) do
    IO.puts("----------------- About to fetch some posts ---------------------")

    response = HTTPoison.get!("https://hacker-news.firebaseio.com/v0/topstories.json")

    IO.puts(response.body)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    interval = 6 * 1000
    Process.send_after(self(), :fetch_top_posts, interval)
  end
end
