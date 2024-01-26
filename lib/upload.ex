defmodule Upload do
  defstruct [
    :folder,
    :folder_id,
    :folder_code,
    :file_code,
    :title,
    :single_img,
    :splash_img,
    :download_url,
    :length,
    :uploaded,
    :file_name,
    :hash
  ]

  def to_keyword(upload = %Upload{}) do
    [
      folder: upload.folder
    ]
  end
  def crete_template(upload, template) do
    Path.expand("../ds_upload/templates/sec/" <> template <> ".eex")
    |> EEx.eval_file(upload)
  end
end
