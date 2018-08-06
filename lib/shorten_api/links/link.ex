defmodule ShortenApi.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO
  # - make hashid auto gen
  # - check for exisitng url
  # - look up limits for mnesia
  # setup auth
  # setup login
  @primary_key {:hash, :string, []}
  @derive {Phoenix.Param, key: :hash}
  schema "links" do
    field :url, :string

    timestamps()
  end

  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  defp generate_hash_id(%Ecto.Changeset{changes: %{url: url}} = changeset) do
    put_change(changeset, :hash, random_string(6))
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:hash, :url])
    |> generate_hash_id()
    |> validate_required([:hash, :url])
    |> unique_constraint(:hash)
    |> unique_constraint(:url)
  end
end
