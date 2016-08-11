require 'yaml'

class PlaysController < ApplicationController
  before_action :set_play, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @plays = Play.all
    respond_with(@plays)
  end

  def simple_recommend
    # params[:word] 
    # system("python get_data_for_similarity.py")
    run_txt_hash
    @greeting = calc_similarity
    render "index"
  end

  def calc_similarity
    result= ""
    word_list = YAML.load_file("#{Rails.root}/app/controllers/word_set/word_list_test.yml") ;
    # word_list = YAML.load_file("word_list.yml") ;
    # word_list2 = YAML.load_file("word_list.yml") ;
    word_list2 = YAML.load_file("#{Rails.root}/app/controllers/word_set/word_list_test.yml") ;

    word_vec = []
    word_list.each do |word|
      word_vec.push(YAML.load_file("#{Rails.root}/app/controllers/data_set/"+word+".yml")) ;
    end

    word_vec.each_with_index do |word, i|
      word_vec.each_with_index do |word2, i2|
        # if word != word2
        print word_list[i]+":"+word_list[i2]+"  "
        result+= word_list[i]+":"+word_list[i2]+"  "
        result += cos(word, word2).to_s
        # end
      end
    end
    return result;
  end


  def run_txt_hash
    print Dir.pwd
    # word_list = YAML.load_file("//word_list_test.yml")
    word_list = YAML.load_file("#{Rails.root}/app/controllers/word_list_test.yml")
    all_array = Array.new ;
    word_name = ""
    word_list.each do |word|
      word_name += word 
      word_name += "_"
      f = open("#{Rails.root}/app/controllers/data_set/"+word+".txt")
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

    # makeYamlFile("data_set/"+word_name+".yml",hash) ;

  end


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





  def show
    respond_with(@play)
  end

  def new
    # @play = Play.new
    # respond_with(@play)
    @play = Play.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create


    # @play = Play.new(play_params)
    @play = Play.new(play_params)
    @play.save
    respond_with(@play)
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
