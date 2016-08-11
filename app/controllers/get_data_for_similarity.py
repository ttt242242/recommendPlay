
# -*- coding: utf_8 -*- 
import sys
import os
sys.path.append('/home/okano/lab/recommend/pythonOkn/')
import basictool
import urllib2
import yaml
import mechanize
import pdb
from bs4 import BeautifulSoup


br = mechanize.Browser()
br.open("https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8")
br.set_handle_robots(False)


br.select_form(nr = 0)  #フォームを入力
# print br.form

# word_list = load_yml( "word_list.yml"
f = open("word_set/word_list_test.yml", 'r')
word_list = yaml.load(f)
f.close() 
for word in word_list:
    br.open("https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8")
    br.set_handle_robots(False)


    br.select_form(nr = 0)  #フォームを入力
    word = word.encode('utf-8')

    if os.path.exists("data_set/"+word+".txt") == False:  #まだ、検索していなければ
        br["search"] = word  #
        response = br.submit() ;

        # print response.geturl()     #飛んだページ

        # print br.find_link(text=word)  #テストという名前のリンクを探す
        req =  br.click_link(text=word)     #テストという名前のリンクをクリック
        br.open(req)
        # print br.response().read()      #
        f = open('data_set/'+word+'.txt', 'w')
        f.write(br.response().read())
        f.close() 
        # print br.geturl()           #アドレス表示


