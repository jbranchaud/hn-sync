defmodule NewsSync do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    send(self(), :fetch_top_posts)

    {:ok, state}
  end

  def handle_info(:fetch_top_posts, state) do
    IO.puts("----------------- About to fetch some posts ---------------------")

    case HnFetch.get_top_stories() do
      {:ok, top_stories} ->
        top_stories |> Enum.take(3) |> Enum.map(&fetch_story/1)

      {:error, msg} ->
        IO.puts(msg)
    end

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    interval = 6 * 1000
    Process.send_after(self(), :fetch_top_posts, interval)
  end

  defp fetch_story(story_id) do
    spawn(fn ->
      with {:ok, body} <- HnFetch.get_story_data(story_id),
           {:ok, url} <- Map.fetch(body, "url") do
        IO.puts("##{story_id}: #{url}")
      else
        {:error, msg} ->
          IO.puts(msg)
      end
    end)
  end
end
