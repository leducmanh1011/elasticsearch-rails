class TracksIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      email: {
        tokenizer: "keyword",
        filter: ["lowercase"]
      },
    }
  }

  index_scope Track.includes(:album, :genre)
  default_import_options batch_size: 100, bulk_size: 10.megabytes, refresh: false

  field :name
  field :email, analyzer: "email"
  field :composer
  field :album, value: ->(track) { track.album.title }
  field :realease_date, type: "date"
  field :seconds, type: "integer"
end
