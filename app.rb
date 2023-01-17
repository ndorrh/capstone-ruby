require_relative './src/modules/read_write_file'
require_relative './src/author'
require_relative './src/genre'
require_relative './src/book'
require_relative './src/music_album'
require_relative './src/game'
require_relative './src/label'
require_relative './src/modules/get_user_input'
require_relative './src/modules/read_file'

class App
  attr_accessor :genres, :authors, :sources, :labels, :books, :music_albums, :movies, :games

  def initialize
    @user_input = GetUserInput.new
    @lood_files = read
  end

  def print_dash(no_of_dash)
    dash = ''
    (0..no_of_dash).to_a.each do |_i|
      dash.concat('-')
    end
    puts dash
  end
  def get_attributes(thing)
    puts 'Follow the Prompt to Add a new music Album'
    new_genre = Genre.new(@user_input.genre(thing))
    @lood_files[:genres] << new_genre unless @lood_files[:genres].include?(new_genre)
    print_dash(130)
    new_author = @user_input.author
    author = Author.new(new_author[:f_name], new_author[:l_name])

  

    @lood_files[:authors] << author unless @lood_files[:authors].any?{ |aut| author.first_name == aut[:first_name] && author.last_name == aut[:last_name]}

    print_dash(130)
    new_label = @user_input.label
    label = Label.new(new_label[:title], new_label[:color])
    @lood_files[:labels] << label unless @lood_files[:labels].include?(label)
    print_dash(130)
    [new_genre, author, label]
  end


def add_music_album
    arg = get_attributes('Music')
    new_date = @user_input.publish_date('On spotify')
    music = MusicAlbum.new(arg[0], arg[1], arg[3], arg[2], new_date[:date], new_date[:boolean])
    new_music = @user_input.parse_data(music)
    @lood_files[:music_albums] << new_music unless @lood_files[:music_albums].include?(new_music)
    print_dash(130)
    puts '                                                     music album added successfully                                    '
    print_dash(130)
  end

  def add_game
    arg = get_attributes('Game')
    publish_date = @user_input.input_date('Publish date')
    last_played = @user_input.input_date('Last played date')
    print 'Enter Game mode multiplayer? Choose one [YES/NO]: '
    game_mode = gets.chomp
    game = Game.new(arg[0], arg[1], arg[3], arg[2], publish_date, game_mode, last_played)
    new_game = @user_input.parse_data(game)
    @lood_files[:games] << new_game unless @lood_files[:games].include?(new_game)
    print_dash(174)
    puts '                                                     Game added successfully                                     '
    print_dash(174)
  end

  def list_all_games
    unless @lood_files[:games].empty?
      print_dash(130)
      puts '                                                                 Games:                                           '
      @lood_files[:games].each do |game|
        print_dash(130)
        puts "Genre: #{game['genre']['name']}, Author name: #{game['author']['first_name']} #{game['author']['last_name']},Label title: #{game['label']['title']}, label color: #{game['label']['color']},Publish date: #{game['publish_date']}, MultiPlayer: #{game['multiplayer']}, Last Played on: #{game['last_played_at']}"
      end
      print_dash(130)
    end
    puts "\n No Movie to Display \n" if @lood_files[:games].empty?
  end

  def list_all_authors
    unless @lood_files[:authors].empty?
      print_dash(130)
      puts 'Authors:'
      @lood_files[:authors].each do |author|
        print_dash(130)
        puts "Name: #{author['first_name']}, #{author['last_name']}"
      end
    end
    puts "No author to display \n" if @lood_files[:authors].empty?
  end



  def list_all_music_albums
    unless @lood_files[:music_albums].empty?
      print_dash(130)
      puts '|                                                                Music albums:'
      @lood_files[:music_albums].each do |album|
        print_dash(130)
        puts "Genre: #{album['genre']['name']}, Author name: #{album['author']['first_name']} #{album['author']['last_name']},
        Label title: #{album['label']['title']}, label color: #{album['label']['color']},
        Publish date: #{album['publish_date']}, On spotify: #{album['on_spotify'] ? 'YES' : 'NO'}"
      end
      print_dash(130)
    end
    puts "\n No Music Album to Display \n" if @lood_files[:music_albums].empty?
  end

def list_all_genres
    unless @lood_files[:genres].empty?
      print_dash(130)
      puts 'Genres:'
      print_dash(130)
      @lood_files[:genres].each do |genre|
        print "#{genre['name']}, "
      end
      puts "\n"
    end
    print_dash(130)
    puts "No genre to display \n" if @lood_files[:genres].empty?
  end



  def interface
    display_options = ["\n Welcome to Catalog of my things App! \n",
                       "\n Please Choose an option by entering a number \n\n", '1 - List all books', '2 - List all music albums', '3 - List of games', '4 - List all genres', '5 - List all labels', '6 - List all authors', '7 - Add a book', '8 - Add a game', '9 - Add music album ',
                       '0 - Enter 0 to exit app']
    display_options.each do |option|
      puts option
    end
  end

  def write_files()
    write_json_file('database/books.json', @lood_files[:books])
    write_json_file('database/music_albums.json', @lood_files[:music_albums])
    write_json_file('database/games.json', @lood_files[:games])
    write_json_file('database/genres.json', @lood_files[:genres])
    write_json_file('database/authors.json', @lood_files[:authors])
    write_json_file('database/labels.json', @lood_files[:labels])
  end
end
