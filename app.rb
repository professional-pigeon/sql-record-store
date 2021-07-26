require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname=> "record_store", :password=> "epicodus"})

get('/') do
  redirect to('/albums')
end

get('/albums') do
  @albums = Album.all
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

post('/albums') do
  name = params[:album_name]
  album = Album.new({:name => name, :id => nil})
  album.save()
  redirect to('/albums')
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  if @album
    erb(:album)
  else
    redirect to('/')
  end
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  if @album
    erb(:edit_album)
  else
    redirect to('/')
  end
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  redirect to('/albums')
end

delete ('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  redirect to('/albums')
end

get ('/albums/:id/songs/:song_id') do
  if @song
    @song = Song.find(params[:song_id].to_i())
    erb(:song)
  else
    redirect to("/albums/#{params[:id]}")
  end
end

post ('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new({:name => params[:song_name], :album_id => @album.id, :id => nil})
  song.save()
  erb(:album)
end

patch ('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete ('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
