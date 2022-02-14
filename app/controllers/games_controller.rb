require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ""
    10.times {@letters  << (65 + rand(25)).chr}
    @start_time = Time.now.to_i
  end

  def score
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    @elapsed_time = @end_time - @start_time
    @user_answer = params[:user_answer].upcase
    @url = "https://wagon-dictionary.herokuapp.com/#{@user_answer}"
    @api_response = URI.open(@url).read
    @api_hash = JSON.parse(@api_response)
    @existing_word = @api_hash["found"]
    @letters = params[:letters]

    if @existing_word
      @result = 'The word exists. '
    else
      @result = 'The word does not exist. '
    end

    @valid_word = compare(@user_answer, @letters)

    if @valid_word
      @result += "The word can be created with the random letters."
    else
      @result += "The word can not be created with the random letters."
    end

    if @valid_word && @existing_word
      @points = @user_answer.length
    else
      @points = 0
    end

  end

  def compare(guess, letters)
    @array_letters = letters.split("")
    @array_guess = guess.split("")
    @array_guess.each do |letter|
      if @array_letters.include?(letter)
        @index = @array_letters.index(letter)
        @array_letters.delete_at(@index)
      else
        return false
      end
    end
    return true
  end

end
