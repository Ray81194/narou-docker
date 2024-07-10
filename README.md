# Narou.rb Docker Image

Narou.rb を Docker で実行するための Docker Image です。<br>
Docker さえあれば一切環境構築なしで Narou.rb WEB UI を立ち上げることができます。

イメージ内容は下記で構成されます。

- Alpine Linux
- Ruby 3.3.3
- [改造版AozoraEpub3](https://github.com/kyukyunyorituryo/AozoraEpub3) v1.1.1b24Q

※Linux 版の kindlegen は含まれません

# 使い方

docker コマンドで直接コンテナを立ち上げます。<br>

```sh
$ docker compose up -d
```

docker から始まるコマンド１行で WEB UI が起動します。<br>
http://localhost:33000/ にアクセスしてください。
