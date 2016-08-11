#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "pry"
require '/home/okano/okano/RRSP/v0.3/rubyOkn/BasicTool'

include BasicTool

word_list = Array.new ;
# while true
#   print "do you add a word ? [y|n]"
#   response = gets.chomp
#   
#   case response
#   when "y"
#     puts "input word"
#     word = gets.chomp
#     word_list.push(word)
#   when "n"
#     break ;
#   end
# end
word_list = ["テニス", "ソフトテニス"]
# word_list = ["テニス", "野球", "サッカー", "ピアノ", "剣道", "ソフトテニス"]
# word_list = ["猫", "犬", "サッカー", "ピアノ", "テニス", "ソフトテニス", "バトミントン", "野球"]

makeYamlFile("word_list.yml", word_list) ;
# makeYamlFile("word_set/word_list_test.yml", word_list) ;

