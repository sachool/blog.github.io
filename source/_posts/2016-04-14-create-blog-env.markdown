---
layout: post
title: "【Vagrant】ブログの投稿環境をつくる"
date: 2016-04-14 17:53:48 +0900
comments: true
categories: ['Vagrant', 'Linux']
descriptions: 
keywords: 
author: kish
---

こんにちは、仙台ファクトリーのkish(@31_kish)です。  

ブログを投稿する環境の作り方を紹介します。  
配布したBOXファイルを使ってVagrantを立ち上げ、仮想環境のLinuxを操作します。  

CUIをバリバリ使う姿はかっこいいと思います！

<!-- more -->

##前提条件
* VirtualBoxがインストールされている
* Vagrantがインストールされている
* シェルはbash  
私はWindowsでminttyを使っています。  


###VagrantにBOXファイルを追加する

```
$ vagrant box add BOX_NAME BOX_FILE_URL
```

`BOX_FILE_URL`にはBOXファイルがある場所を入力してください。  
`BOX_NAME`には任意の名前を入力してください。  
何のBOXなのかわかる名前が良いと思います。  


###Vagrant用のディレクトリを作成する

```
$ mkdir blog
```

`Vagrantfile`というVagrantの設定などが記載されたファイルを作るので  
それを保存するディレクトリを作成しましょう。  
BOXの名前と同じが良いと思います。  


###Vagrantfileの作成する

```
$ cd blog
$ vagrant init BOX_NAME
```

コマンドの実行前に先ほど作成したディレクトリに移動します。  
`vagrant init`を実行すると`Vagrantfile`が生成されます。


###Vagrantfileを修正する

Octopressをローカルでプレビューするために`Vagrantfile`を修正します。  

```
22   # Create a forwarded port mapping which allows access to a specific port
23   # within the machine from a port on the host machine. In the example below,
24   # accessing "localhost:8080" will access port 80 on the guest machine.
25 -  # config.vm.network "forwarded_port", guest: 80, host: 8080
25 + config.vm.network "forwarded_port", guest: 4000, host: 4040

27  # Create a private network, which allows host-only access to the machine
28   # using a specific IP.
29 -  # config.vm.network "private_network", ip: "192.168.33.10"
29 + config.vm.network "private_network", ip: "192.168.33.10"  
```

`-`を`+`のように書き換えてください。  


###Vagrantを立ち上げる

```
$ vagrant up
```

`vagrant up`はVagrantfileのあるディレクトリで実行してください。  
立ち上げたいBOXのディレクトリで実行するとそのBOXが立ち上がります。  


###Vagrantに接続

```
$ vagrant ssh
```

コマンドを実行するとsshでログインされます。  
私の環境ではこのコマンドでログインはできませんでした。  
sshコマンドで接続する方法もご紹介します。  


###SSHで接続したい

ホームディレクトリの`.ssh/config`を編集します。  
なければ作成してください。  

```
Host sachool_blog
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile "C:/Users/***/.vagrant.d/boxes/blog/0/virtualbox/vagrant_private_key"
  IdentitiesOnly yes
  LogLevel FATAL
```

`IdentityFile`の場所は各自変更してください。  


###コミットに表示される名前を変更する

sshでログインすることができましたか？  
ログインできたら、設定を変更しましょう。

```
$ cd ~
$ vim .gitconfig
```

`name`と`email`を自分のものに変更してください。

以上で投稿する環境が整いました！  
投稿する手順については[こちら](../kiji-no-to-ko-tejun/)  

