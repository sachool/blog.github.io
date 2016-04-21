---
layout: post
title: "【CentOS7】Octopressでブログ作成"
date: 2016-04-21 17:17:07 +0900
comments: true
categories: [octopress, centos, linux]
descriptions: 
keywords: 
---

CentOS7をインストールした直後から  
Octopressをプレビューできるまでの手順を紹介します。

私の環境では、VirtualBoxでCentOSの仮想環境を作成して行っています。  

バッククオート(｀)の中で＃を使うと、ページが生成できないようです。  
投稿の際はご注意ください。

<!-- more -->

## パッケージをアップデートして再起動する
**rootユーザーで行います。**
まずは念のためアップデートしておきます。
```
＃ yum -y update
```
終わったら再起動
```
＃ reboot
```


## net-tools、vimをインストールする
最小構成のCentOS7では `ifconfig` , `vim` が使えないのでインストールします。
```
＃ yum -y install net-tools vim
```


## 一般ユーザーを作成する

ここではadminというユーザーを作成します。

```
＃ useradd admin
＃ passwd admin
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully
```


## rootにログインできるユーザーを管理者のみにする
adminをwheelグループに追加します。
```
＃ usermod -G wheel admin
＃ vim /etc/pam.d/su
```
```
auth required pam_wheel.so use_id <- コメントを解除する
```


## SELinuxを無効化する
```
＃ vim /etc/sysconfig/selinux
```
```
SELINUX=disabled <- このように変更する
```


## SSHの設定をする
```
＃ vim /etc/ssh/sshd_config
```
```
Port 22 <- 接続を受け付けるポート

PermitedRootLogin no <- rootログインを禁止

PasswordAuthentication yes <- パスワード認証を許可する
```


## sshdを再起動する
```
＃ systemctl restart sshd
```  

**ここまでroot**  

**ここからはadminで行う**


## gitをインストールする
```
$ sudo yum -y install git
```


## 必要なパッケージをインストールする
rubyのインストールに必要なパッケージです。
```
$ sudo yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel bzip2
```


## rbenvをインストールする
[CentOSにrbenvをインストールする方法](http://www.task-notes.com/entry/20150624/1435114800)  
参考にしました。  


環境変数にパスを通すため、一旦rootで作業をします。
```
$ su -
パスワード
```
```
＃ git clone https://github.com/sstephenson/rbenv.git /usr/local/src/rbenv
＃ echo 'export RBENV_ROOT="/usr/local/src/rbenv"' >> /etc/profile.d/rbenv.sh
＃ echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
＃ echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
＃ source /etc/profile.d/rbenv.sh
＃ rbenv -v
rbenv 1.0.0-19-g29b4da7
```

## ruby-buildをインストール
```
＃ git clone https://github.com/sstephenson/ruby-build.git /usr/local/src/rbenv/plugins/ruby-build
```

## rubyをインストール
インストールするバージョンを確認します。
```
＃ rbenv install --list
```
今回は2.3.0をインストールします。
```
＃ rbenv install 2.3.0
＃ rbenv global 2.3.0
＃ ruby -v
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-linux]
```
インストールが完了したら、rootからログアウトします。
```
$ exit
```


## OctopressをGithubからcloneする
```
$ mkdir ocopress
$ git clone git://github.com/imathis/octopress.git octopress/
$ cd octopress
```

## bundlerをインストール
```
$ sudo gem install bundler
```
`gemコマンドが見つかりません`  
というメッセージが表示されたらサーバーにログインし直してください。  
それでも同じメッセージが表示されたらrootユーザーに切り替えて実行してください。  

`javascript runtime`が見つからないというエラーが発生するため  
`Gemfile`に追記してインストールします。

```
$ vim Gemfile
```
```
gem 'therubyracer'
gem 'execjs'
```
```
$ bundle --path vendor/bundle
```

## Octopressのデフォルトテーマをインストール
```
$ bundle exec rake install
 Copying classic theme into ./source and ./sass
mkdir -p source
cp -r .themes/classic/source/. source
mkdir -p sass
cp -r .themes/classic/sass/. sass
mkdir -p source/_posts
mkdir -p public
```

## ページを生成
```
$ bundle exec rake generate
```


## Gemfileに追記する
プレビューに`thin`を利用するためファイルを修正していきます。
```
$ vim Gemfile
```
```
gem 'thin', '~>1.5.0'
```

追記したらインストール

```
$ bundle --path vendor/bundle
```

## Rakefileを修正
```
$ vim Rakefile
```
```
-   puts "Starting to watch source with Jekyll and Compass. Starting Rack on port #{server_port}"

+   puts "Starting to watch source with Jekyll and Compass. Starting Thin on port #{server_port}"
---

-   rackupPid = Process.spawn("rackup --port #{server_port}")

+   thinPid = Process.spawn("thin start --port #{server_port}")
---

-     [jekyllPid, compassPid, rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }

+     [jekyllPid, compassPid, thinPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
---

-   [jekyllPid, compassPid, rackupPid].each { |pid| Process.wait(pid) }

+   [jekyllPid, compassPid, thinPid].each { |pid| Process.wait(pid) }
---
```
`-`の行を`+`のように書き換えてください。  

修正が完了したらプレビューしてみます。
```
$ bundle exec rake preview
Starting to watch source with Jekyll and Compass. Starting Thin on port 4000
>> Using rack adapter
>> Thin web server (v1.5.1 codename Straight Razor)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:4000, CTRL+C to stop
>>> Compass is watching for changes. Press Ctrl-C to Stop.
Configuration file: /home/admin/octopress/_config.yml
            Source: source
       Destination: public
      Generating...
                    done.
 Auto-regeneration: enabled for 'source'
    write public/stylesheets/screen.css
```

ブラウザでサーバーのIPアドレスのポート4000にアクセスすると、ブログが表示されます。  
VirtualBoxを利用している方はポートフォワーディングなどの設定をして  
ゲストOSとホストOSが通信できる状態にしてください。

プレビューを起動している状態だと、記事の編集がリアルタイムで確認することができます。

ブログのタイトルなどの設定は`_config.yml`を編集してください。

***

参考URL  
[OctopressのRake Previewにthinを利用してプレビューを高速化する](http://blog.glidenote.com/blog/2012/10/31/thin-octopress/)  
[エンジニアのブログは Octopress が最適](http://blog.shiroyama.us/blog/2014/02/26/octopress/)  
[Octopress - 環境構築！](http://www.mk-mode.com/octopress/2012/12/10/octopress-construction-of-environment/)  

