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

    response = HTTPoison.get!("https://hacker-news.firebaseio.com/v0/topstories.json")
    top_twenty = response.body |> Poison.decode!() |> Enum.take(3)
    Enum.map(top_twenty, &fetch_story/1)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    interval = 6 * 1000
    Process.send_after(self(), :fetch_top_posts, interval)
  end

  defp fetch_story(story_id) do
    spawn(fn ->
      response =
        story_id
        |> (&"https://hacker-news.firebaseio.com/v0/item/#{&1}.json").()
        |> HTTPoison.get!()

      with %{status_code: 200, body: body} <- response,
           {:ok, decoded_body} <- Poison.decode(body),
           {:ok, url} <- Map.fetch(decoded_body, "url") do
        IO.puts("##{story_id}: #{url}")
      else
        _ ->
          IO.puts("Failed to fetch anything for #{story_id}")
      end
    end)
  end
end
