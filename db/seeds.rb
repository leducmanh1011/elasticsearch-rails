# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


50.times do |n|
  artist = Artist.create! name: Faker::Name.unique.name, gender: rand(0..1)
  artist.albums.create! title: Faker::Music.album
end

15.times do 
  Genre.find_or_create_by! name: Faker::Music.genre
end

genre_ids = Genre.ids

Album.all.each do |a|
  Track.create! name: Faker::Name.unique.name, album_id: a.id, genre_id: genre_ids.sample,
    composer: Faker::Music.band, seconds: Array(3173..5893).sample, realease_date: rand(10.years.ago.to_date..Date.current - 1.month)
end
