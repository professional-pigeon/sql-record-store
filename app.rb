require("sinatra")
require("sinatra/reloader")
require("./lib/album")
require("./lib/song")
require("./lib/artist")
require("pry")
require("pg")
also_reload("lib/**/*.rb")

DB = PG.connect({ :dbname => "record_store"})

get("/") do
  redirect to("/albums")
end

get("/albums") do
  @albums = Album.all
  @albums.sort_by! {|album| album.name.downcase}
  erb(:albums)
end
# artist = album.artists and then artist[0].name and artist[0].id

get("/albums/new") do
  erb(:new_album)
end

post("/albums") do
  album = Album.new({:name => params[:album_name], :id => nil, :release_year => params[:release_year]})
  album.save()
  artist = Artist.find_by_name(params[:artist_name]) #check to see if the artist already exists
  if artist
    artist.update({:album_name => params[:album_name]})
  else
    artist1 = Artist.new(:name => params[:artist_name], :id => nil) #if the artist doesn't exist this is new
    artist1.save
    artist1.update({:album_name => params[:album_name]})
  end
  redirect to("/albums")
end

get("/albums/:id") do
  @album = Album.find(params[:id].to_i())
  if @album
    erb(:album)
  else
    redirect to("/")
  end
end

get("/albums/:id/edit") do
  @album = Album.find(params[:id].to_i())
  if @album
    erb(:edit_album)
  else
    redirect to("/")
  end
end

patch("/albums/:id") do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  redirect to("/albums")
end

delete("/albums/:id") do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  redirect to("/albums")
end

get("/albums/:id/songs/:song_id") do
  if @song
    @song = Song.find(params[:song_id].to_i())
    erb(:song)
  else
    redirect to("/albums/#{params[:id]}")
  end
end

post("/albums/:id/songs") do
  @album = Album.find(params[:id].to_i())
  song = Song.new({ :name => params[:song_name], :album_id => @album.id, :id => nil })
  song.save()
  erb(:album)
end

patch("/albums/:id/songs/:song_id") do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete("/albums/:id/songs/:song_id") do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get("/albums/sort/:sort_method") do
  @albums = Album.all
  case params[:sort_method]
  when "id"
    @albums.sort_by! {|album| album.id}
  when "release_year"
    @albums.sort_by! {|album| album.release_year}
  else
    @albums.sort_by! {|album| album.name}
  end
  redirect to ("/")
end

get('/artists') do
  @artists = Artist.all
  erb(:artists)
end

get('/artists/:id') do
  erb(:artist)
end

get('/artists/edit') do
    @artist = find(params[:id].to_i())
  if @artist
    erb(:edit_artist)
  else
    redirect to("/")
  end
end




