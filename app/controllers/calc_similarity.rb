#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "pry"
require "yaml"

#
# === コサイン類似度
#
def cos(v1, v2)
  sum = 0.0 
  same_key = Array.new 
  v1.keys.each do |key|
    if v2[key] != nil
      sum += v1[key] * v2[key] 
    else
      v2[key] = 0.0
      sum += v1[key] * v2[key] 
    end
      same_key.push(key)
  end

  # v1_test = de(v1, same_key)  
  v1_test = de(v1,v1.keys)
  # v2_test = de(v2, same_key)
  v2_test = de(v2,v2.keys)

  return sum/(v1_test * v2_test)
end

def de(v, key_array)
  sum = 0.0
  key_array.each do |key|
    sum += v[key] ** 2
  end 
  return Math.sqrt(sum)
end


word_list = YAML.load_file("word_set/word_list_test.yml") ;
# word_list = YAML.load_file("word_list.yml") ;
# word_list2 = YAML.load_file("word_list.yml") ;
word_list2 = YAML.load_file("word_set/word_list_test.yml") ;

word_vec = []
word_list.each do |word|
  word_vec.push(YAML.load_file("data_set/"+word+".yml")) ;
end

word_vec.each_with_index do |word, i|
  word_vec.each_with_index do |word2, i2|
     # if word != word2
        print word_list[i]+":"+word_list[i2]+"  "
        puts cos(word, word2)
     # end
  end
end

