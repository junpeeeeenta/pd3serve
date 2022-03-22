## Usage
本APIの仕様：https://app.swaggerhub.com/apis-docs/junpeeeeenta/pd3serve/1.0.0 

### サーバの立ち上げ方法 
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
つぎに[roswell](https://roswell.github.io/Installation.html)と[clack](https://github.com/fukamachi/clack)をインストールしてください。

以上ですべてのインストールが完了します。
## See Also
本プロジェクトは、主に以下を使用しています。
- [caveman2](https://github.com/fukamachi/caveman)
- [PD3](https://github.com/DigitalTriplet/PD3)
- [drawio](https://github.com/jgraph/drawio)

## Author

* jumpei

## Copyright

Copyright (c) 2021 jumpei

