defmodule HnFetch do
  def get_top_stories do
    get("https://hacker-news.firebaseio.com/v0/topstories.json", "Unable to fetch top stories")
  end

  def get_story_data(story_id) do
    get(
      "https://hacker-news.firebaseio.com/v0/item/#{story_id}.json",
      "Unable to fetch story data"
    )
  end

  defp get(url, failure_msg) do
    with %{status_code: 200, body: body} <- HTTPoison.get!(url),
         {:ok, decoded_body} <- Poison.decode(body) do
      {:ok, decoded_body}
    else
      _ -> {:error, failure_msg}
    end
  end
end
