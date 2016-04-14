---
layout: post
title: "記事の投稿手順"
date: 2016-04-14 12:19:09 +0900
comments: true
categories: Octopress
descriptions: 
keywords: 
---


Octopressに記事を投稿してみましょう。  


<!-- more -->

###記事の投稿  
`$ bundle exec rake new_post`  
`Enter a title for your post:`  
 記事の投稿手順タイトルを入力します。  
source/_post/に`*.markdown`というファイルが作られます。  
それが記事のページとなります。編集してみましょう。  

`$ vim source/_post/*.markdown`  

```
---
layout: post
title: "title"
date: 2013-04-16 22:25
comments: true
categories: ['カテゴリ名', 'カテゴリその２']
description: 
keywords: 
---
ここに本文を書く
```

記事に画像を載せる場合はimagesディレクトリに入れてください。  
`![alt octopress](/images/sample.png)`  

※altはhtmlのの属性です。  
()の中身がファイルのパスになります。  

書き終えたら保存して閉じてください。  

`$ bundle exec rake gen_deploy`  
記事の投稿が完了です。  
So Cool!

`$ bundle exec rake preview`

プレビューすることもできます。
localhost:4040/blogへアクセスしてください。

