require 'rspec'
require 'album'
require 'song'
require 'pry'
require 'spec_helper'

describe '#Album' do

  before(:each) do
    @album = Album.new({:name => "A Love Supreme", :id => nil})
    @album.save()
    @album2 = Album.new({:name => "Blue", :id => nil})
    @album2.save()
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      Album.clear
      expect(Album.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an album") do
      expect(Album.all).to(eq([@album, @album2]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      Album.clear
      expect(Album.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album3 = Album.new({:name => "A Love Supreme", :id => nil, :release_year => 2008})
      album3.save()
      expect(@album).to(eq(album3))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      expect(Album.find(@album.id)).to(eq(@album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      @album.update("A Love Supreme")
      expect(@album.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      @album.delete()
      expect(Album.all).to(eq([@album2]))
    end

    it("deletes all songs belonging to a deleted album") do
      song = Song.new({:name => "Naima", :album_id => @album.id, :id => nil})
      song.save()
      @album.delete()
      expect(Song.find(song.id)).to(eq(nil))
    end
  end

  describe('#songs') do
    it("returns an album's songs") do
      song = Song.new({:name => "Naima", :album_id => @album.id, :id => nil})
      song.save()
      song2 = Song.new({:name => "Cousin Mary", :album_id => @album.id, :id => nil})
      song2.save()
      expect(@album.songs).to(eq([song, song2]))
    end
  end
end
