require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer]
    score_and_message(@answer, @letters)
  end

  def included?(answer, letters)
    answer.chars.all? { |letter| answer.count(letter) <= letters.count(letter) }
  end

  def english_word?(answer)
    response = open("https://wagon-dictionary.herokuapp.com/#{answer}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score_and_message(answer, letters)
    if included?(answer.upcase, letters)
      if english_word?(answer)
        @result = "Congratulations! #{answer} is a valid English word!"
      else
        @result = "Sorry but #{answer} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{answer} can't be built out of #{letters}"
    end
  end
end
