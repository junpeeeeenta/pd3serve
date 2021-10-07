# pd3serve
デジタルトリプレットの枠組みに基づき、エンジニアリングプロセス(EP)の再利用を支援するWEBシステムです。まず、PD3(Process Modeling Language for Digital Triplet)をプロセスモデリング言語としてEPを記述します。つぎに、PD3のオントロジーでRDF化し、セマンティックWEBでの共有を可能にします。
***
## Usage
***WEBAPIの仕様書を現在作成中です。***

[インストール](#installation)後、以下のコマンドを実行してください。
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
何らかのディレクトリの中に、5つのレポジトリをクローンしてください。
- pd3
- pd3serve
- drawio
- line-reader
- xmlreader

それぞれ以下のコマンドでクローン可能です。
```sh
git clone https://github.com/junpeeeeenta/PD3.git
git clone https://github.com/junpeeeeenta/pd3serve.git
git clone https://github.com/junpeeeeenta/drawio.git
git clone https://github.com/junpeeeeenta/line-reader.git
git clone https://github.com/junpeeeeenta/xmlreader.git
```

例えば、common-lispディレクトリ内に5つのレポジトリをクローンした場合、以下のようになります。

```sh
~/common-lisp$ ls
PD3 pd3serve drawio line-reader xmlreader
```

## See Also
本プロジェクトは、主に以下を使用しています。
- [caveman2](https://github.com/fukamachi/caveman)
- [PD3](https://github.com/DigitalTriplet/PD3)

## Author

* jumpei goto

## Copyright

Copyright (c) 2021 jumpei goto

