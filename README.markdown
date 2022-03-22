## Usage
### 本APIの仕様 
https://app.swaggerhub.com/apis-docs/junpeeeeenta/pd3serve/1.0.0 から参照してほしい．

### 本システムの立ち上げ方法 
[インストール](#installation)後、以下のコマンドを実行すれば本システム (サーバ) を立上げることができる．
```sh
$ cd ~/common-lisp/pd3serve
~/common-lisp/pd3serve$ APP_ENV=production clackup --port your_port --address your_ipaddress app.lisp

To load "pd3serve":
  Load 1 ASDF system:
    pd3serve
; Loading "pd3serve"
..................................................
[package pd3serve.config].........................
[package pd3serve.view]...........................
[package pd3serve.djula]..........................
[package pd3serve.db].............................
[package pd3serve]................................
[package pd3serve.web]...
Hunchentoot server is going to start.
Listening on your_ipaddress:your_port.

```

## Installation
本システムをインストールする方法を述べる．  
まず，あるディレクトリ内に以下5つのレポジトリをクローンする．  
- pd3：https://github.com/junpeeeeenta/PD3.git
- pd3serve：https://github.com/junpeeeeenta/pd3serve.git
- drawio：https://github.com/junpeeeeenta/drawio.git
- line-reader：https://github.com/junpeeeeenta/line-reader.git
- xmlreader：https://github.com/junpeeeeenta/xmlreader.git

それぞれ以下のコマンドでクローンできる．  
```sh
git clone https://github.com/junpeeeeenta/PD3.git
git clone https://github.com/junpeeeeenta/pd3serve.git
git clone https://github.com/junpeeeeenta/drawio.git
git clone https://github.com/junpeeeeenta/line-reader.git
git clone https://github.com/junpeeeeenta/xmlreader.git
```

例えば，「common-lisp」ディレクトリ内に5つのレポジトリをクローンした場合，以下のようになる．  

```sh
~/common-lisp$ ls
PD3 pd3serve drawio line-reader xmlreader
```
つぎにroswellとclackをインストールする．  
それぞれ，下記のURLを参照してほしい．  
・roswell：https://roswell.github.io/Installation.html  
・clack：https://github.com/fukamachi/clack

以上でインストールが完了した．  
システムの立ち上げおよび使用方法については，[Usage](#Usage)を参照してほしい．

## Author

* jumpei

## Copyright

Copyright (c) 2021 jumpei

