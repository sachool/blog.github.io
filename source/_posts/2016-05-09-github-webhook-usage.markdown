---
layout: post
title: "【Github】Webhooksを利用する"
date: 2016-05-09 18:49:01 +0900
comments: true
categories: [linux, octopress]
descriptions: 
keywords: [Github, Webhook, Ruby, Apache, Linux]
author: kish
---

仙台ファクトリーのkish(@31_kish)です。  
ローカル環境で書いたブログの記事をPushすると、自動的にサーバーが更新される機能を実装しました。  

RubyでCGIを作って、GithubWebhooksを受け取るようにしています。

<!--more-->

## とりあえずスクリプトを書く
``` ruby hoge.rb
system("sh fuga.sh")
```
CGIのほうは、実行されたらシェルスクリプトを叩くだけです。  
何をやっているのか公開してしまうのが不安だったので、シェルスクリプトを経由するようにしています。  

``` sh fuga.sh
cd ..
echo '-----' >> receiver_log
date >> receiver_log
sudo -u user git pull >> receiver_log
exit
```
シェルスクリプトは、実行された日付を出力して `pull` コマンドを `user` 権限で実行する  
というものです。（実際のスクリプトとは少し違います。）

## CGIを有効にする
Apacheの設定で有効にします。

```sh
$ sudo vim /etc/httpd/con.d/hoge.conf
```

```sh hoge.conf
  <Directory "/hoge/fuga/hooks">
    Options +ExecCGI
    Require all granted
    AddHandler cgi-script .rb
  </Directory>
```

## Apacheがsudoで実行できるコマンドを制限する
```sh
$ sudo visudo
```
`visudo`で制限します。

```sh visudo
$ Defaults:apache !requiretty
$ apache ALL=(user) NOPASSWD: file_path/hoge.rb, command_path/git
```

sudoを実行するためにはtty（SSHクライアントやコンソール上での実行）が必須です。    

そのままではwebから実行することができないので、１行目でapacheユーザーのみ  
必須ではなくしています。  
２行目では、apacheユーザーは外部からのアクセスを許可し、user権限でのみ  
sudoを実行できるようにしています。  
その後ろはパスワードなしで実行できるコマンドを制限しています。

## Githubの設定をする
Githubのリポジトリの`Settings`から `Webhooks & services` を設定して完了です。  
Githubの設定を行う前に、スクリプトのテストは十分に行うようにしましょう。


