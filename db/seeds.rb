# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def gen_name_by_locale locale = :en
  Faker::Config.locale = locale
  Faker::Name.unique.name
end

Chewy.strategy(:atomic) do
  50.times do |n|
    artist = Artist.create! name: Faker::Name.unique.name, gender: rand(0..1)
    artist.albums.create! title: Faker::Music.album
  end

  15.times do 
    Genre.find_or_create_by! name: Faker::Music.genre
  end

  genre_ids = Genre.ids

  Album.all.each do |a|
    Track.create! name_en: gen_name_by_locale, name_ja: gen_name_by_locale(:ja),
      album_id: a.id, genre_id: genre_ids.sample,
      composer: Faker::Music.band, seconds: Array(180..700).sample, 
      realease_date: rand(10.years.ago.to_date..Date.current - 1.month),
      email: Faker::Internet.email
  end
end
