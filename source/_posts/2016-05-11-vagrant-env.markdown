---
layout: post
title: "新卒エンジニアがVagrantを使ってみた"
date: 2016-05-11 15:13:54 +0900
comments: true
categories: [vagrant] 
descriptions: 
keywords:
author: kou
---
どうも！仙台ファクトリー新卒のkouです。  
今回は、Vagrantを使ってみたのでまとめてみたいと思います。  
Vagrantを使って仮想OSの立ち上げまでできるようになることを目指します。

<!-- more -->

## １． Vagrantとは

### Vagrantの概要
Vagrantは、仮想環境を簡単に構築できるツールです。  
仮想化ソフトであるVirtual Boxと併用して使います。  
これまで面倒だった環境構築もコマンドを数行打つだけで完了させることができます。
  
Vagrantを利用することで次のことが実現できます。

- ローカル環境と本番環境を揃える
- チームで開発する際の環境を揃える（＊構成管理ツールが必要）

他にもいろいろできることはありますが、Vagrantを使うことでの最大の恩恵は
`大幅な時間の節約`  
これに尽きるのではないかと思います。  Vagrantの使い方を覚えることで、環境構築に費やす非生産的な時間から解放されて時間を有効に使えるようになると思います。

### Vagrantで押さえておきたい用語
- Boxファイル  
 →Vagrant用にカスタマイズされたOSのイメージファイル。  
 　ネット上で配布されているものもある。（配布先は後述）自作も可能。  
  `＊BoxファイルがないとVagrantは使えないので注意`
 
- Vagrantfile  
 →仮想マシンの設定が書かれているファイル。  
 　ネットワーク設定やマシンスペック設定などが書かれている。  
 `＊Vagrant初期化時に生成される`
 　


## ２．事前準備
- [VirtualBox公式サイト](https://www.virtualbox.org/)より、OSに合ったVirtualBoxをダウンロードしインストール
- [Vagrant公式サイト](https://www.vagrantup.com/l)より、OSに合ったVagrantをダウンロードしインストール
- [Vagrantbox.es](http://)（＊1）より、必要なboxファイルをダウンロードorリンクの取得

#### Vagrantがインストールされたか確認

Vagrantをインストールしたら、コマンドラインで
```
$ vagrant -v
```
を入力し、vagrantが正しくインストールされているか確認しましょう。
```
Vagrant 1.8.1
```
というようにバージョンが表示されれば正常にインストールされています。

＊1 Vagrantbox.esは有志が作ったサイト。ここに公開されているBOXファイルの安全性は保障されてないので使用は自己責任で。

## ３．Vagrantの設定

ここからは、コマンドラインで操作を行います。

#### １．Boxの追加
```
$ vagrant box add [Box名] [BoxのURL]

例：boxファイルをサーバーから取得する場合
$ vagrant box add centos http://github.com/~~~/centos.box

例：boxファイルをフォルダから指定する場合
$ vagrant box add centos C:/Users/[ユーザー名]/centos.box
```


#### ２．Boxの追加の確認
```
$ vagrant box list
```
と入力し、
```
[Box名]
```
と表示されればVagrantへのBOXの追加は完了です。

#### ３．作業用フォルダの作成
仮想環境用の作業フォルダを作成します。
今回は（ユーザー名）ディレクトリ直下にcentosというフォルダを作成します。
```
ユーザーフォルダ直下に移動
$ cd /c/users/[ユーザー名]

centosフォルダを作成
$ mkdir centos

作成したフォルダに移動
$ cd centos
```
＊フォルダの作成は、デスクトップ上で行っても構いません。

`vagrantを立ち上げる際は作成したフォルダに移動してから以降のコマンドを実行するようにします`

#### ４．vagrantの初期化
```
$ vagrant init [Box名]
例
$ vagrant init centos
```
これで、centosフォルダ上に1.で追加したboxファイルを起動するように設定されたvagrantfileが作成されます。

#### ５．vagrantの立ち上げ
```
$ vagrant up
```
これでvagrantが起動し、仮想マシンが立ち上がります。

#### ６．仮想マシンへログイン
```
$ vagrant ssh
```

これで仮想マシンを弄れるようになります。
＊windowsのコマンドプロンプトではssh接続ができないので、MinGWなどをインストールすることをお勧めします。

#### ７．vagrantの終了
仮想マシンを弄り終わったら次のコマンドで停止してあげましょう。
```
$ vagrant halt
```

#### ８．vagrantの削除
仮想マシンが不要になったら次のコマンドで削除できます。
```
$ vagrant destroy
```



## ４．まとめ
今回は、簡単なローカル開発環境の構築を行ってみました。
まだまだ使いこなせてませんが、少しずつ使い慣れていきたいと思います。  

今後は、Chefも触ってみて環境構築も自動化することを目指したいと思います。
自動化できるところは自動化して生産性UP!


今回は以上です。
