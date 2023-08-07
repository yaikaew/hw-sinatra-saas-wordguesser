class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word, :guesses, :wrong_guesses

  def guess(letter)
    is_invalid_guess = letter.nil? || letter.empty? || letter.match(/\W/)
    throw ArgumentError if is_invalid_guess

    letter.downcase!
    is_already_guess_that_letter = (@guesses+@wrong_guesses).include? letter
    return false if is_already_guess_that_letter

    if @word.include? letter
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    word_guess = ''
    @word.chars { |char|
      if @guesses.include? char
        word_guess << char
      else
        word_guess << '-'
      end
    }
    word_guess
  end

  def check_win_or_lose
    if word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length == 7
      return :lose
    end
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
