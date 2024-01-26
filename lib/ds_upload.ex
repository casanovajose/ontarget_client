defmodule DsUpload do
  @moduledoc """
  DsUpload entablish connection with upload server
  """
  use HTTPoison.Base

  @doc """
  Hello world.

  ## Examples

      iex> DsUpload.hello()
      :world

  """
  def start do
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
  defp capture_cmd(["api_url" | args]) do
    [opt | _] = args
    Client.get_api_url(opt)
    |> IO.puts()
    :ok
  end

  defp capture_cmd(["upload_url" | _args]) do
    Client.get_upload_url()
    |> IO.puts()
    :ok
  end

  defp capture_cmd(["files" | _args]) do
    Client.get_files("")
    #|> IO.puts()
    :ok
  end

  defp capture_cmd(_), do:  :ok

  # def generate_post(upload = %Upload{}, opts \\ []) do
  #   Upload.generate_post(upload)
  # end
end
