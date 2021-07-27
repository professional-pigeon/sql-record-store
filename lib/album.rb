class Album
  attr_accessor :name, :release_year
  attr_reader :id

  def initialize(attributes)
    attributes.each {|pair| instance_variable_set("@#{pair[0].to_s}", pair[1])}
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      release_year= album.fetch("release_year").to_i
      albums.push(Album.new({ :name => name, :id => id, :release_year => release_year }))
    end
    albums
  end

  def save
    result = DB.exec("INSERT INTO albums (name, release_year) VALUES ('#{@name}', '#{@release_year}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    if album
      name = album.fetch("name")
      id = album.fetch("id").to_i
      release_year = album.fetch("release_year").to_i
      Album.new({ :name => name, :id => id, :release_year => release_year})
    else
      false
    end
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  def songs
    Song.find_by_album(self.id)
  end

  def artists
    artists = []
    results = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id};")
    results.each() do |result|
      artist_id = result.fetch("artist_id").to_i()
      artist = DB.exec("SELECT * FROM artists WHERE id = #{artist_id};")
      name = artist.first().fetch("name")
      artists.push(Artist.new({:name => name, :id => artist_id}))
    end
    artists
  end

end

