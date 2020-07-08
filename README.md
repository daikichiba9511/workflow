# workflow

環境構築のベースライン

## 概要

Dockerコンテナにパッケージ管理ツール`poetry`を使って分析環境を構築する。

## 使い方

### ビルドとコンテナ起動

以下のコマンドで、Dockerイメージをビルドしてコンテナの生成とコンテナをバックワードで起動できる。

```bash
docker-compose up -d
```

_※`Dockerfile`を変更しリビルドしたい場合は`docker-compose up -d --build`を実行する_

### コンテナの基本的操作

docker コンテナの基本的な操作である以下についてコマンドを記載する。

- docker imageの確認
- docker containerの確認
- docker containerの起動
- 起動したdocker containerへの接続
- docker containerの停止

#### docker command

- docker imageの確認

docker imageは以下のコマンドで確認する。

```bash
docker images
```

- docker containerの確認

docker containerは以下のコマンドで確認する。

-a は全てのcontainerをみるオプション。付けなければ起動中のcontainer のみが表示される

```bash
docker ps -a
```

- docker containerの起動

docker containerは以下のコマンドで起動する。

```bash
docker start <起動したいcontainerのid or name>
```

- 起動したdocker containerへの接続

起動したdocker containerへは以下のコマンドで接続する.

```bash
docker attach <起動したいcontainerのid or name>
```

**NOTE** : 上記のコマンドではjupyterlabが起動する。
今回ビルド時にdocker-compose.yml内でcommandにjupterlabを指定してるからである。

```bash
docker attach -it <起動したいcontainerのid or name>
```

上記の`-it`のオプションを付けたコマンドはpythonのREPLが起動する。これはDockerfileのベースがpython3.7-slimを指定してるからであると思う（未確認）。`-it`は対話的に作業を行うオプションなので一々コンテナから抜けなくてよくなる。

このdirecotry内のDockerfileで生成するimageを元に作成したcontainer内でbashの作業を行いたい時は以下のコマンドを使用する

```bash
docker exec -it <起動したいcontainerのid or name> /bin/bash
```

### jupyterlabへのアクセス

コンテナ実行後、以下にアクセスすることでJupyter labにアクセスできる。

これは[docker-compose.yml](/docker-compose.yml)内でホストのport 8888 とコンテナ内の port 8888 をフォーワードでつないでいるため

[http://localhost:8888/lab](http://localhost:8888/lab)

## テスト実行

以下のコマンドで`tests/`配下のテストコードを実行できる。

```bash
pytest
```

## poetry

以下はpoetryを用いたパッケージの追加と削除について説明する。詳細はreference[5]を参照されたい。

### パッケージの追加

以下のコマンドでPythonパッケージを追加できる。その際に依存関係はlockファイルに、追加パッケージの名前とver. はtoml に追記される

- プロダクト用パッケージ

```bash
poetry add <追加したいパッケージ>
```

- 開発用パッケージ

```bash
poetry add --dev <追加したいパッケージ>
```

### パッケージの削除


- プロダクト用パッケージ

```bash
poetry remove <削除したいパッケージ>
```

- 開発用パッケージ

```bash
poetry remove --dev <削除したいパッケージ>
```

## reference

- [1] [Dockerコンテナにパッケージ管理ツールpoetryを使ってPythonの分析環境を構築する方法](https://qiita.com/yolo_kiyoshi/items/332ae902aeb730fbd068)

- [2] [Poetry + Docker + Intellijの開発環境を整える](https://blog.apitore.com/2020/03/06/poetry-docker-intellij/)

- [3] [MyWorkflow.jl/Dockerfile　(teraskakisatoshi)](https://github.com/terasakisatoshi/MyWorkflow.jl/blob/master/Dockerfile)

- [4] [Docker Documents](https://docs.docker.com/)

- [5] [poetry Documents](https://python-poetry.org/docs/)