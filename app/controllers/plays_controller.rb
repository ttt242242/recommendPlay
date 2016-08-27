#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'yaml'
require 'mechanize'

class PlaysController < ApplicationController
  before_action :set_play, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @plays = Play.all
    respond_with(@plays)
  end

  def simple_recommend
    word_model = get_word_model(params[:word])
    @plays= calc_similarity_each_plays(word_model)
    render "index"
  end

  # ワードのベクトルを返す
  def get_word_model(word)
    # DBにword vecがなければ、スクレイピングしてモデルの生成
    play = Play.find_by(name: word)
    if play.nil?
      # スクレイピングしてtxtを取得
      word_sentence = scraping_word(word)
      # txt から wordのベクトルの生成
      word_vec = sentence_to_vec(word_sentence)
      # dbにデータを登録
      play = create_play(word,word_vec)
    end

    return play
  end

  def get_word_vec(word)
    # スクレイピングしてtxtを取得
    word_sentence = scraping_word(word)
    # txt から wordのベクトルの生成
    word_vec = sentence_to_vec(word_sentence)

    return word_vec
  end

  # ワードのベクトルを生成する
  def sentence_to_vec(sentence)
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
    #とれた文字をハッシュ化する
    hash = array_to_numarray(new_word_array)

    #出てきた単語順に並べる
    hash = hash.sort{|(k1, v1), (k2, v2) | v2 <=> v1}

    #要素の個数を限定する（今回は500?)
    hash = cut_hash(hash, 500)
    hash = min_max_normalization_hash(hash) ;

    return hash ;
  end

  def create_play(word, word_vec)
    play = Play.new(:name => word, :vec => word_vec)
    # play.save
    return play
  end


  def scraping_word(word)
    agent = Mechanize.new ;
    page = agent.get("https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8")  ;
    form = page.forms[0]
    form.field_with(:name => 'search').value = word
    page2 = agent.submit(form)
    result = page2.body.force_encoding("utf-8")

    return result 
  end

  def calc_similarity_each_plays(obj_play)
    result= {}
    plays = Play.all 

    plays.each do |play|
      if (play.name != obj_play.name)
        result[play.name] = cos(obj_play.vec,play.vec)
      end
    end 

    result = result.sort {|(k1,  v1),  (k2,  v2)| v2 <=> v1 }
    return result;

  end

  #
  # === コサイン類似度
  #
  def cos(v1, v2)
    sum = 0.0 
    same_key = Array.new 
    v1.keys.each do |key|

        begin
      if v2[key] != nil
        sum += v1[key] * v2[key] 
        
      else
        v2[key] = 0.0
        sum += v1[key] * v2[key] 
      end
      rescue
          binding.pry ;
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


  def show
    respond_with(@play)
  end

  def new
    @play = Play.new
    respond_with(@play)
    #
    # @play = Play.new
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  def edit
  end

  def create
    # @play = Play.new(play_params)
    # binding.pry ;
    if !Play.exists?(:name => params[:name]) 
      word_vec = get_word_vec(params[:name])
      num = {:num_from => params[:page][:num_from], :num_to => params[:page][:num_to]}
      season = {:spring => params[:spring], :summar => params[:summar], :autumn => params[:autumn], :winter => params[:winter]}
      #すでに登録されているかをチェック
      @play = Play.new(:name => params[:name], :vec => word_vec,:num => num, :season => season)
      @play.save
      respond_with(@play)
    else
     @plays = Play.all
     respond_with(@plays)
    end
  end

  def update
    @play.update(play_params)
    respond_with(@play)
  end

  def destroy
    @play.destroy
    respond_with(@play)
  end

  def remove_zenkaku(word_array)
    new_word_array = Array.new ;
    word_array.each do |word|
      word.scan(/./) do |i|
        if(/[ -~｡-ﾟ]/ =~ i)
          break ;
        else
          new_word_array.push(word) ;
        end
      end
    end
    return new_word_array ;
  end

  def array_to_numarray(array)
    #とれた文字をハッシュ化する
    hash = Hash.new ;
    array.each do |word|
      if hash[word] == nil
        hash[word] = 0
      end
      hash[word] += 1 ; 
    end
    return hash ;
  end

  def min_max_normalization_hash(hash)
    result_hash = Hash.new ;
    min_max = get_max_min_v_from_hash(hash)
    hash.each do |h|
      h[1] = (h[1].to_f - min_max[:min].to_f)/(min_max[:max].to_f-min_max[:min].to_f) ;
      result_hash[h[0]] = h[1] ;
    end 
    return result_hash ;
  end

  #
  # hashのvalueの値でソートする.昇順
  #
  def hash_v_sort(hash)
    return hash.sort{|(k1, v1), (k2, v2)| v2 <=> v1}
  end

  #
  # === 元のhashをsizeでカットする
  #
  def cut_hash(hash, size)
    result_hash = Hash.new ;

    # すでにhashが指定したサイズ以下なら
    if hash.size < size
      return hash
    end   


    hash.each_with_index do |(k, v), i|
      if i == size - 1
        return result_hash ;
      end
      result_hash[k] = v ;
    end
  end

  #
  # hashデータのvのmaxとminを取得
  #
  def get_max_min_v_from_hash(hash)
    result = Hash.new ;
    result[:max] = 0 ;
    result[:min] = 100000 ;

    hash.each_with_index do |(k,v),i|
      # sorted_array.push({k => hyperbolic(v)}) ;
      # sorted_array.push({k => v}) ;
      if result[:max] < v
        result[:max] = v ;
      end
      if result[:min] > v
        result[:min] = v ;
      end
    end

    return result ;
  end




  private
  def set_play
    @play = Play.find(params[:id])
  end

  def play_params
    params.require(:play).permit(:name)
  end



end
