require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end
# Put your record definitions here

class Album

    attr_accessor :album_no, :title, :artist, :image, :genre, :tracks

    def initialize (album_no, title, artist, image, genre, tracks)
        @album_no = album_no
        @genre = genre
        @image = image
        @title = title
        @artist = artist
        @tracks = tracks
    end
end

class Track
    attr_accessor :track_no, :name, :location

    def initialize (track_no, name, location)
        @track_no = track_no
        @name = name
        @location = location
    end
end

class Song
  attr_accessor :song
  def initialize
    @song = Gosu::Song.new(file)
  end
end

class MusicPlayerMain < Gosu::Window
  def initialize
    super 1200, 800
    self.caption = "Rohan's Music Player"
    music_file = File.new('albums.txt', 'r')
    @pointer = 0
    @album_pointer = 0
    @locs = [40,40]
    @font = Gosu::Font.new(30)
    albums = read_in_albums(music_file)
    @albums = albums
    @track_pointer = 0

  end

  def read_track(music_file)
    track_PrKey = @track_id
    name = music_file.gets()
    location = music_file.gets.chomp
    track = Track.new(track_PrKey, name, location)
    return track
  end

  def read_tracks(music_file)
    tracks = Array.new()
    count = music_file.gets().to_i()
    index=0
    @track_id = 1
    while index<count
      track = read_track(music_file)
      tracks << track
      index = index + 1
      @track_id = @track_id + 1
    end
    return tracks
  end

  def read_album(music_file)
      album_key = @album_id
      album_artist = music_file.gets()
      album_title = music_file.gets.chomp
      album_image = music_file.gets.chomp
      album_genre = music_file.gets.to_i
      album_songs = read_tracks(music_file)
      album = Album.new(album_key, album_artist, album_title, album_image, album_genre, album_songs)
      album.album_no = album_key
      album.title = album_title
      album.artist = album_artist
      album.image = album_image
      album.genre = album_genre
      return album
  end

  def read_in_albums(music_file)
    count = music_file.gets.to_i
    @album_id = 1
    albums = Array.new()
    index = 0
    while index < count
      album = read_album(music_file)
      albums << album
      index+=1
      @album_id += 1
    end
    return albums
  end

# Draws the artwork on the screen for all the albums
  def draw_all_albums(albums)
    # complete this code
    #Album 1
    @bmp = Gosu::Image.new(albums[0].image)
    @bmp.draw(40, 60, z = ZOrder::PLAYER, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Album 2
    @bmp = Gosu::Image.new(albums[1].image)
    @bmp.draw(320, 60, z = ZOrder::PLAYER, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Album 3
    @bmp = Gosu::Image.new(albums[2].image)
    @bmp.draw(40, 350, z = ZOrder::PLAYER, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Album 4
    @bmp = Gosu::Image.new(albums[3].image)
    @bmp.draw(320, 350, z = ZOrder::PLAYER, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
  end

  #Draws the control buttons
  def draw_controls()
    #Shuffle song icon
    @bmp = Gosu::Image.new("images/shuffle.png")
    @bmp.draw(150, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Previous song
    @bmp = Gosu::Image.new("images/previous.png")
    @bmp.draw(220, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Play song
    @bmp = Gosu::Image.new("images/play.png")
    @bmp.draw(280, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Pause song
    @bmp = Gosu::Image.new("images/pause.png")
    @bmp.draw(350, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Stop song
    @bmp = Gosu::Image.new("images/stop.png")
    @bmp.draw(420, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

    #Next song
    @bmp = Gosu::Image.new("images/next.png")
    @bmp.draw(480, 680, z = ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

  end

  def area_clicked(mouse_x,mouse_y)
      #Album 1
      if ((mouse_x > 40 && mouse_x < 290) && (mouse_y > 60 && mouse_y < 310))
        @options = 0
        @track_pointer = @track_pointer.to_i()
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      #Album 2
      elsif ((mouse_x > 320 && mouse_x < 570) && (mouse_y > 60 && mouse_y < 310))
        @options = 1
        @track_pointer = @track_pointer.to_i()
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      #Album 3
      elsif ((mouse_x > 40 && mouse_x < 290) && (mouse_y > 350 && mouse_y < 600))
        @options = 2
        @track_pointer = @track_pointer.to_i()
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      #Album 4
      elsif ((mouse_x > 320 && mouse_x < 570) && (mouse_y > 350 && mouse_y < 600))
        @options = 3
        @track_pointer = @track_pointer.to_i()
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      end
    return @options
  end

  def area_clicked_for_tracks(mouse_x,mouse_y)
    index = 0
    start_x = 800
    end_x = 1000
    start_y = 0
    end_y = 100
    while index < @albums[@options].tracks.length
      if((mouse_x > start_x) && (mouse_x < end_x) && (mouse_y > start_y) && (mouse_y < end_y))
        return index.to_i()
      end
      start_y+=100
      end_y+=100
      index = index + 1
    end
  end

  def controls(mouse_x,mouse_y)
    #Shuffle Song
    if ((mouse_x >150 && mouse_x < 200 )&& (mouse_y > 680 && mouse_y < 730))
      @track_pointer = @track_pointer.to_i()
      shuff = rand(@track_pointer)
      @song = Gosu::Song.new(@albums[@options].tracks[shuff].location.chomp)
      @song.play(false)
    end
    #Play song
    if ((mouse_x >280 && mouse_x < 330 )&& (mouse_y > 680 && mouse_y < 730))
      @song.play
    end
    #Pause song
    if ((mouse_x >350 && mouse_x < 400)&& (mouse_y > 680 && mouse_y < 730))
      @song.pause
    end

    #Stop song
    if ((mouse_x >420 && mouse_x < 470)&& (mouse_y > 680 && mouse_y < 730))
      @song.stop
      @options = nil
    end
    #Next song
    if ((mouse_x >480 && mouse_x < 530)&& (mouse_y > 680 && mouse_y < 730))
      @track_pointer = @track_pointer.to_i()
      if (@track_pointer < @albums[@options].tracks.length-1)
        @track_pointer += 1
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      end
    end

    #Previous song
    if ((mouse_x >220 && mouse_x < 270)&& (mouse_y > 680 && mouse_y < 730))
      @track_pointer = @track_pointer.to_i()
      if (@track_pointer > 0)
        @track_pointer -= 1
        @song = Gosu::Song.new(@albums[@options].tracks[@track_pointer].location.chomp)
        @song.play(false)
      end
    end

  end

  def draw_track(title, x, y)
    @font.draw_text(title, x, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def draw_tracks()
    i = 0

    current_track = @track_pointer.to_i() + 1
    if (@options == nil)
      x1=800
      y1=0
      while i < @albums.length
        @font.draw_text("#{@albums[i].artist}", x1 , y1+=100, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
        @font.draw_text("#{@albums[i].title}", x1 , y1+=40, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
        i+=1
      end
    else
      x = 800
      y = 70
      while i < @albums[@options].tracks.length
        draw_track(@albums[@options].tracks[i].name, x, y)
        if(@albums[@options].tracks[i].track_no == current_track)
          @font.draw_text("\u{25B6}", x-30, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
        end
        y+= 100
        i+= 1
      end
    end
  end

  # Takes a track index and an Album and plays the Track from the Album
  def play_curr_Track(track, album)
      @song = Gosu::Song.new(album.tracks[track].location.chomp)
      @song.play(false)
  end

  # Draw a coloured background using TOP_COLOR and BOTTOM_/COLOR
  def draw_background()
    draw_quad(0, 0, TOP_COLOR, 0, 1000, TOP_COLOR, 1200, 0, BOTTOM_COLOR, 1200, 800, BOTTOM_COLOR, z= ZOrder::BACKGROUND, mode = :default)
  end


  # Draws the album images and the track list for the selected album

  def draw()
    draw_tracks()
    draw_background()
    draw_controls()
    draw_all_albums(@albums)
  end

  def needs_cursor?
    true
  end
  # If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

  def button_down(id)
    @locs = [mouse_x, mouse_y]
    area_clicked(mouse_x, mouse_y)
    @track_pointer = area_clicked_for_tracks(mouse_x, mouse_y)
    controls(mouse_x,mouse_y)
    case id
    when Gosu::MsLeft
      unless (@track_pointer.nil?)
      play_curr_Track(@track_pointer, @albums[@options])
      end
    #Press S to stop song
    when Gosu::KbS
      @song.stop
    #Press P to play Song
    when Gosu::KbP
      @song.play
    #Press down arrow key to lower the volume
    when Gosu::KbDown
      if @song.volume > 0.05 then
          @song.volume -= 0.1
      end
    #Press up arrow key to increase the volume
    when Gosu::KbUp
        if @song.volume < 0.95 then
            @song.volume += 0.1
        end
    end
  end
end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show
