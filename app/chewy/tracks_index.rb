class TracksIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      email: {
        tokenizer: "keyword",
        filter: %w[lowercase]
      },
      english_ngram: {
        tokenizer: "ngram_tokenizer",
        filter: %w[lowercase]
      },
      japanese_ngram: {
        tokenizer: "ngram_tokenizer",
        filter: %w[kuromoji_baseform kuromoji_part_of_speech cjk_width ja_stop
          kuromoji_stemmer lowercase]
      }
    },
    tokenizer: {
      ngram_tokenizer: {
        type: "ngram",
        min_gram: 1,
        max_gram: 3,
        token_chars: %w[letter digit]
      }
    }
  },
  max_ngram_diff: 2

  index_scope Track.includes(:album, :genre)
  default_import_options batch_size: 100, bulk_size: 10.megabytes, refresh: false

  field :name
  field :email, analyzer: "email"
  field :composer, analyzer: "english_ngram"
  field :album, value: ->(track) { track.album.title }
  field :realease_date, type: "date"
  field :seconds, type: "integer"
end
