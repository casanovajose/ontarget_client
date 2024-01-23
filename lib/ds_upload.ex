defmodule DsUpload do
  @moduledoc """
  DsUpload entablish connection with upload server
  """
  import Upload
  use HTTPoison.Base

  @base_url System.get_env("BASE_URL")
  @api_key System.get_env("API_KEY")

  @doc """
  Hello world.

  ## Examples

      iex> DsUpload.hello()
      :world

  """
  def start do
    #IO.inspect(System.get_env("API_KEY"), label: "the key")
    #capture_cmd(["server"])
    #%HTTPoison.Response{body: response} = HTTPoison.get!("google.com")
    #IO.stream(:stdio, :line)
    #|> Enum.take_while(&(&1 != "end\n"))
    #|> IO.inspect(label: "line: ")
    #   |> String.split()
    #   |> IO.inspect()
    #   |> capture_cmd()
    #   |> Enum.map(&String.replace(&1, "\n", ""))
    loop(:ok)
  end

  def loop(:end), do: "Bye!"
  def loop(:ok) do
    IO.gets("> ")
    |> String.split()
    |> capture_cmd()
    |> loop()
  end


  defp capture_cmd(["end" | _]), do: :end
  defp capture_cmd(["base_url" | _args]) do
    {:ok, url} = get_base_url()
    IO.puts(url)
    :ok
  end
  defp capture_cmd(["upload_url" | _args]) do
    {:ok, url} = get_upload_url()
    IO.puts(url)
    :ok
  end

  defp capture_cmd(_), do:  :ok

  def get_base_url do
    {:ok, "#{@base_url}/account/info?key=#{@api_key}"}
  end

  def get_upload_url do
    url = "#{@base_url}/upload/server?key=#{@api_key}";
    IO.puts("Getting upload server url")
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    {:ok, %{"result" => upload_url}} = Jason.decode(body)
    {:ok, upload_url}
  end

  def generate_post(upload = %Upload{}, opts \\ []) do
    Upload.generate_post(upload)
  end
end
