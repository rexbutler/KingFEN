#!/usr/bin/env ruby
require 'rubygems'

require 'pp' #require 'ap'
require 'erb'
require 'redcloth'
require 'sinatra'
require 'sinatra/reloader' if development?

#'K' stands for a white king, "n" for a black knight, etc...
TRANS_TO_FILENAME = { "-" => "",
                      "P" => "wp.png", "N" => "wn.png", "B" => "wb.png",
                      "R" => "wr.png", "Q" => "wq.png", "K" => "wk.png",
                      "p" => "bp.png", "n" => "bn.png", "b" => "bb.png",
                      "r" => "br.png", "q" => "bq.png", "k" => "bk.png"  }
FEN_PIECE_CODES = TRANS_TO_FILENAME.keys

VALID_PIECE_IMAGE_SIZES = [20,24,28,32,36,40,44,48,52,56,60,64,72,80,88,96,112,128,144,300]

DEFAULT_FEN_STRING = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
DEFAULT_PIECE_IMAGE_SIZE = 56
DEFAULT_PIECE_IMAGE_SET = 'alpha'
DEFAULT_COMMENT_TOP = ""
DEFAULT_COMMENT_BOTTOM = ""

# '5' in a FEN string means 5 empty squares, etc... thus:
def parse_fen_character(fen_char)
  if fen_char =~ /\d/ then
    return '-' * fen_char.to_i
  elsif FEN_PIECE_CODES.include?(fen_char)
    return fen_char
  else
    puts "parse_fen_character returning nil"
    return nil
  end
end

# Prase (Expand) FEN row string, for example '2R3pr' gives '--R---pr'
def parse_fen_row(row_str)
  rs = row_str.split('')
  rs = rs.map { |x| parse_fen_character(x) }
  return nil if rs.include?(nil)
  rs = rs.join('')
  return nil unless rs.size == 8
  return rs
end

#Parses a FEN string into an 8 by 8 array representing the position
def parse_fen_string(fen_string)
  fen_position_string = fen_string.split(" ")[0]
  fen_position_rows = fen_position_string.split("/")

  return nil unless fen_position_rows.size == 8
  
  #FEN starts from the top of the board, 'the eighth rank (row)', not 'the first rank (row)'
  fen_position_rows.reverse! 
  fen_position_rows = fen_position_rows.map { |row_str| parse_fen_row(row_str) }
  return nil if fen_position_rows.include?(nil)
 
  pp fen_position_rows
  return fen_position_rows.map { |f| f.split('') }
end

#Translates one char piece codes to full image path for that code
def piece_image_path(piece_code,piece_image_size,piece_image_set)
  piece_img_name = TRANS_TO_FILENAME[piece_code]
  return '' if piece_img_name.empty?
  path = "./images/pieces/" 
  path += piece_image_set + '.ead-01/' 
  path += piece_image_size.to_s + '/' 
  path += piece_img_name
  return path
end

#Maps 8x8 array of piece codes to 8x8 array of corresponding filenames
def position_image_paths(chess_position,piece_image_size,piece_image_set)

  chess_position.map! do |row|
    row.map! do |piece_code|
      piece_image_path(piece_code,piece_image_size,piece_image_set)
    end
  end
  
  return chess_position
end


def self.get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

get_or_post '/' do
  redirect './about.html' #For now
end

get_or_post '/view' do
  #Handle default values
  fen_string = params.include?("fen_string") ? params["fen_string"] : DEFAULT_FEN_STRING
  piece_image_set = params.include?("piece_image_set") ? params["piece_image_set"] : DEFAULT_PIECE_IMAGE_SET
  piece_image_size = params.include?("piece_image_size") ? params["piece_image_size"] : DEFAULT_PIECE_IMAGE_SIZE

  comment_top    = params.include?("comment_top") ? params["comment_top"] : DEFAULT_COMMENT_TOP
  comment_bottom = params.include?("comment_bottom") ? params["comment_bottom"] : DEFAULT_COMMENT_BOTTOM
  
  #Find closest valid piece size, rounding down
  piece_image_size = DEFAULT_PIECE_IMAGE_SIZE if piece_image_size.to_i.nil?
  
  a = VALID_PIECE_IMAGE_SIZES.reject{ |s| s > piece_image_size.to_i }
  if a.size > 0 then
    piece_image_size = a.max
  else
    piece_image_size = VALID_PIECE_IMAGE_SIZES[0]
  end

  chess_position = parse_fen_string(fen_string)

  if chess_position.nil?
    erb :error_response #inline
  else    
    @display_info = {}
    @display_info[:piece_image_size] = piece_image_size
    @display_info[:piece_image_set] = piece_image_set
    @display_info[:piece_image_paths] = position_image_paths(chess_position,piece_image_size,piece_image_set)
    
    @display_info[:comment_top] = h comment_top
    @display_info[:comment_bottom] = h comment_bottom
     
    erb :view
  end
end

__END__

@@error_response
<div id="main">
  <h1>KingFEN: Invalid FEN string</h1>
</div>

