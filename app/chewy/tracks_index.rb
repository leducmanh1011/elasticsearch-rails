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

        # kuromoji_baseform: replace bổ nghĩa cho động từ, tính từ 
        # kuromoji_part_of_speech: 
        # cjk_width 
        # ja_stop: filter stopwords (a, the, in, ...)
        # kuromoji_stemmer: chuẩn hóa các biến thể chính tả katakana phổ biến 
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
  template "name.en", type: "text", analyzer: 'english_ngram'
  template "name.ja", type: "text", analyzer: 'japanese_ngram'


  field :id, type: "integer"
  field :name, type: "object", value: ->(track) do
    {
      ja: track.name_ja,
      en: track.name_en
    }
  end
  field :email, analyzer: "email"
  field :composer
  field :album, value: ->(track) { track.album.title }
  field :realease_date, type: "date"
  field :seconds, type: "integer"
end
