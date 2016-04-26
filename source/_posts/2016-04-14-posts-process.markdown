---
layout: post
title: "記事の投稿手順"
date: 2016-04-14 12:19:09 +0900
comments: true
categories: Octopress
description: Octopressへの投稿手順について
keywords: ['Octopressへの投稿']
author: kish
---

こんにちは、仙台ファクトリーのkish(@31_kish)です。  
まずはブログについて簡単にご紹介します。  

このブログは`Octopress`を利用しています。  
`Octopress`で記事を書くときは基本的にMarkdown記法を使います。  
Markdown記法については[こちら](http://kojika17.com/2013/01/starting-markdown.html)が参考になります。  
学んだことを積極的にアウトプットしていきたいと思います！  

実際の記事の書き方を紹介します。

<!-- more -->

###新規ページを作る前に
**必ずローカル環境を最新の状態にしてください！**

```
$ git pull
```


###新規ページの生成  

```
$ bundle exec rake new_post
Enter a title for your post:
```  
 記事の投稿手順タイトルを入力すると  
`source/_posts/*.markdown`という新規ページが生成されます。  


###新規ページを編集する
`$ vim source/_posts/*.markdown`  

```
---
layout: post
title: "*"
date: 2013-04-16 22:25
comments: true
categories: 
description: 
keywords: 
---

ここに本文を書いていく。

```

`title: ""`には記事のタイトルを入力してください。  
`categories`には該当するカテゴリを入力してください。  
該当するものがない場合は入力すると自動的に作成されます。  
複数のカテゴリを登録する場合は`['category1', 'category2']`と入力します。  

###画像を載せる
`source/images/`に画像をアップロードしてください。   
`![alt octopress](/images/sample.png)`

altはhtmlの属性です。  
()の中身がファイルのパスになります。  
URLを指定することも可能です。

編集が完了したら保存します。


###作成したページを確認する

`$ bundle exec rake preview`  

`localhost:4040/blog`にブラウザからアクセスすると  
確認することができます。


###編集が終わったら

`$ bundle exec rake gen_deploy`  

デプロイすると`sachool.jp/blog`が更新されます。

最後に、`Push`するのを忘れずに！  

```
$ git add -A
$ git commit -a
$ git push -u origin source
```

コミットメッセージはわかりやすいものを入力してください。  
例：記事を投稿した  
以上でブログの更新ができました。

