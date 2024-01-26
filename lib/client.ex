defmodule Client do
  @base_url System.get_env("BASE_URL")
  @api_key System.get_env("API_KEY")

  def get_api_url("upload"), do: "#{@base_url}/upload/server?key=#{@api_key}"
  def get_api_url("files"), do: "#{@base_url}/file/list?key=#{@api_key}"
  def get_api_url("folders"), do: "#{@base_url}/folder/list?only_folders=0&key=#{@api_key}"

  def get_upload_url do
    url = get_api_url("upload");
    IO.puts("Getting upload server url")
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    {:ok, %{"result" => upload_url}} = Jason.decode(body)
    upload_url
  end

  def get_folders() do
    url = get_api_url("folders");
    IO.puts("Getting folders from server")
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    {:ok, %{"result" => %{"folders" => folders}}} = Jason.decode(body)
    folders
    # |> IO.inspect()
  end

  def get_files(_filter) do
    url = get_api_url("files");
    folders = get_folders();

    IO.puts("Getting files from server")
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    {:ok, %{"result" => %{"files" => files}}} = Jason.decode(body)
    Enum.map(files, fn file -> generate_upload_data(folders, file) end)
    #|> IO.inspect(files)
    #files
    |> Enum.at(0)
    |> Map.to_list()
    |> IO.inspect()
    |> Upload.crete_template("nbh")
    |> IO.puts()
  end

  def basic_file_data(folders, file) do
    file_folder = Enum.find(folders, fn folder -> folder["fld_id"] == file["fld_id"] end)
    "#{file_folder["name"]}/#{file["title"]}.mp4" |> IO.inspect()
  end

  def generate_upload_data(folders, file) do
    file_folder = Enum.find(folders, fn folder -> folder["fld_id"] == file["fld_id"] end)
    # IO.inspect(file)
    %Upload{
      folder: file_folder["name"],
      folder_id: file_folder["fld_id"],
      folder_code: file_folder["code"],
      file_code: file["file_code"],
      title: file["title"],
      single_img: file["single_img"],
      splash_img: file["splash_img"],
      download_url: file["download_url"],
      length: file["length"],
      uploaded: file["uploaded"],
    }
  end
end
