#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mecab'
# require 'natto'
require 'yaml'
require 'pry'
require '/home/okano/oknlibs/rubyOkn/BasicTool'
require '/home/okano/oknlibs/rubyOkn/StringTool'
require '/home/okano/oknlibs/rubyOkn/MathTool'

include BasicTool  ;
include StringTool;
include MathTool;
# sentence = "太郎はこの本を二郎を見た女性に渡した。"

# word_list = YAML.load_file("word_list.yml")
# word_list = YAML.load_file("word_list2.yml")
word_list = YAML.load_file("word_set/word_list_test.yml")
all_array = Array.new ;
word_name = ""
word_list.each do |word|
  word_name += word 
  word_name += "_"
  f = open('data_set/'+word+'.txt')
  sentence = f.read()
  f.close()

  # mecab = MeCab::Tagger.new
  mecab = MeCab::Tagger.new
  node = mecab.parseToNode(sentence)
  word_array = []

  #名詞だけとってくる
  begin
    node = node.next
    if /^名詞/ =~ node.feature.force_encoding("UTF-8")
      word_array << node.surface.force_encoding("UTF-8")
    end
  end until node.next.feature.include?("BOS/EOS")

  #以下、全角文字を取る
  new_word_array = remove_zenkaku(word_array)
  all_array.concat(new_word_array) ;
end
  #とれた文字をハッシュ化する
  hash = array_to_numarray(all_array)

  #出てきた単語順に並べる
  hash = hash.sort{|(k1, v1), (k2, v2) | v2 <=> v1}

  #要素の個数を限定する（今回は500?)
  # sorted_array = Array.new ;
  hash = cut_hash(hash, 500)
  hash = min_max_normalization_hash(hash) ;
 
  makeYamlFile("data_set/"+word_name+".yml",hash) ;

