---
marp: true
paginate: true
---

# GraphQL 概論

WebDINO Japan エンジニア
[渡邉浩平](https://github.com/kou029w)
![w:200](https://github.com/kou029w.png)

<!-- @license https://cdn.jsdelivr.net/npm/highlightjs-graphql@1.0.2/LICENSE -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.1.0/build/styles/default.min.css">
<script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.1.0/build/highlight.min.js"></script>
<script>module={};</script>
<script src="https://cdn.jsdelivr.net/npm/highlightjs-graphql@1.0.2/graphql.min.js"></script>
<script>hljs.registerLanguage("graphql", hljsDefineGraphQL);hljs.highlightAll();</script>

---

## はじめに

内容

- GraphQL とは
- なぜ GraphQL を使うのか
- GraphQL Query ハンズオン

GraphQL の基礎を学び、実際に GraphQL API からデータを取得できるようになる

---

## GraphQL とは

https://graphql.org

---

### GraphQL とは API の問い合わせ言語

サーバーへの問い合わせ (GraphQL Query)

```graphql
query {
  pokemon(name: "Pikachu") {
    classification
  }
}
```

サーバーからの応答 (JSON)

```json
{
  "data": {
    "pokemon": {
      "classification": "Mouse Pokémon"
    }
  }
}
```

https://graphql-pokemon2.vercel.app

---

### 歴史

- 2012 年 Facebook による開発
- 2015 年 オープンソース化
- 2019 年 [GraphQL Foundation](https://graphql.org/foundation/)に移管

オープンソースな仕様になっており、自由に[貢献できる](https://github.com/graphql/graphql-spec/blob/main/CONTRIBUTING.md)

---

### 仕様

サーバーとクライアントの間のやり取りに使われる言語仕様
https://spec.graphql.org

#### 問い合わせ言語 - GraphQL Query

クライアントがサーバーに JSON のデータを問い合わせるための言語
https://graphql.org/learn/queries/

身近な問い合わせ言語の例: SQL

#### スキーマ言語 - GraphQL Schema

データ構造と操作を宣言するための言語
https://graphql.org/learn/schema/

身近なスキーマ言語の例: [JSON Schema](https://json-schema.org/), [XML Schema](http://www.w3.org/TR/xmlschema11-1/)

---

### 何でないか

- データベースではない
- JavaScript ではない

---

## なぜ GraphQL を使うのか

1. 単一リクエスト
2. 型システム
3. 便利なツール

---

### 1. 単一リクエスト

REST は複数のエンドポイントへの問い合わせを行うという典型的な課題がある

GraphQL は単一のリクエストで指定したデータを取得できる
=> 効率的なデータの読み込み

- クライアントのデータ取得の効率化
- データの表現の柔軟さ
- エンドポイントの管理の容易さ

Facebook が GraphQL を開発した理由は、[モバイルネイティブアプリへの移行のため](https://reactjs.org/blog/2015/05/01/graphql-introduction.html)
スマホの普及に伴う低速、省電力なデバイスの利用の増加が背景

<!--

---

#### REST の課題 オーバーフェッチ・アンダーフェッチ・エンドポイント管理

-->

---

#### REST vs GraphQL

| 特徴                         | REST | GraphQL |
| ---------------------------- | ---- | ------- |
| オーバーフェッチの解消       | ❌   | ✅      |
| アンダーフェッチの解消       | ❌   | ✅      |
| エンドポイントの管理の容易さ | ❌   | ✅      |
| エンドポイントの実装の単純さ | ✅   | ❌      |

GraphQL は複数のリソースを単一の HTTP POST (Query のみなら GET) リクエストで取得できる
=> REST の典型的な課題を解消できる
その代わり、エンドポイントの実装は REST と比較して複雑になりやすい

---

#### REST

![h:600 REST](https://graphql-engine-cdn.hasura.io/learn-hasura/assets/graphql-react/rest-api.png)
https://hasura.io/learn/graphql/intro-graphql/graphql-vs-rest/

---

#### GraphQL

![h:600 GraphQL](https://graphql-engine-cdn.hasura.io/learn-hasura/assets/graphql-react/graphql-api.gif)
https://hasura.io/learn/graphql/intro-graphql/graphql-vs-rest/

---

### 2. 型システム

さまざまなフロントエンド環境のサポート

単一 API の構築と正確なデータ構造の維持
クライアントアプリケーションを実行するフロントエンドフレームワークとプラットフォームの多様化が背景

---

#### GraphQL Schema

```graphql=
"""ポケモンを表します"""
type Pokemon {
  """このオブジェクトのID"""
  id: ID!

  """このポケモンの名前"""
  name: String

  # ...
}

"""ポケモンの寸法を表します"""
type PokemonDimension {
  # ...
}
```

---

```graphql
"""ポケモンを表します"""
type Pokemon {
}

"""ポケモンの寸法を表します"""
type PokemonDimension {
}
```

オブジェクトの種類

---

```graphql
"""
ポケモンを表します
"""
type Pokemon {
  """
  このオブジェクトのID
  """
  id: ID!

  """
  このポケモンの名前
  """
  name: String

  """
  このポケモンの分類
  """
  classification: String

  """
  このポケモンの高さの最大と最小
  """
  height: PokemonDimension
}
```

---

#### 特定のプログラミング言語に依存しない

```javascript
// JavaScript
const pokemonQuery = `{ pokemon(name: "Pikachu") { classification } }`;

fetch(`http://example/?${new URLSearchParams({ query: pokemonQuery })}`)
  .then((r) => r.json())
  .then(({ data }) => console.log(data?.pokemon?.classification));
// => "Mouse Pokémon"
```

```kotlin
// Kotlin
val response = apolloClient.query(pokemonQuery).await()
Log.d(response?.data?.pokemon?.classification)
```

```swift
// Swift
apollo.fetch(query: pokemonQuery) { result in
  guard let data = try? result.get().data else { return }
  print(data.pokemon?.classification)
}
```

<!-- _footer: https://www.apollographql.com -->

---

### 3. 便利なツール

短期間での開発

クライアントアプリケーションの設計変更に対応するためのツールが提供されている
継続的デプロイ (CD) が背景

---

#### 代表的なツールの紹介

- GraphiQL … 一般的な IDE
- GraphQL Playground … より強力な IDE
- Public GraphQL APIs … 公開されている GraphQL API の一覧
- GraphQL Code Generator … 自動コード生成
- Hasura … GraphQL サーバー

---

#### GraphiQL

![h:600 GraphiQL](https://raw.githubusercontent.com/graphql/graphiql/main/packages/graphiql/resources/graphiql.jpg)

<!-- _footer: https://github.com/graphql/graphiql -->

---

#### GraphQL Playground

![h:600 GraphQL Playground](https://i.imgur.com/AE5W6OW.png)

<!-- _footer: https://github.com/graphql/graphql-playground -->

---

#### Public GraphQL APIs

公開されている GraphQL API 一覧の紹介
GraphQL がどういうものか実際に試してみるのに便利

たとえば

- [GitHub](https://docs.github.com/ja/graphql)
- [Contentful](https://www.contentful.com/developers/docs/tutorials/general/graphql/)
- [Shopify](https://shopify.dev/api)

https://apis.guru/graphql-apis/

---

#### GraphQL Code Generator

コードの生成

```console
$ graphql-codegen
```

使う

```typescript
import { usePokemonQuery } from "./generated";

export default () => {
  const { data } = usePokemonQuery();
  return data?.pokemon?.classification;
};
```

[React](https://www.graphql-code-generator.com/docs/plugins/typescript-react-query), [Vue](https://www.graphql-code-generator.com/docs/plugins/typescript-vue-apollo), [Kotlin](https://www.graphql-code-generator.com/docs/plugins/kotlin), etc.

https://www.graphql-code-generator.com

---

#### Hasura

GraphQL サーバー
接続したデータベースを自動的に GraphQL API として提供

https://hasura.io

---

## ここまでのまとめ

GraphQL の基礎知識

- GraphQL とは API の問い合わせ言語仕様
- 特徴
  - 単一リクエスト
  - 型システム
  - 便利なツール

---

# GraphQL Query ハンズオン

---

## GraphQL Query ハンズオン

内容

- 3 種類の操作
- Query によるデータの取得

実際に GraphQL API からデータを取得できるようになる

---

## GraphQL Operation

3 種類の操作

- query - 読み取り
- mutation - 書き込み
- subscription - イベントストリーム

1 つのリクエストに複数の操作を含めることができる

---

## Query - データの取得

---

### 基本的な構文

```graphql
query {
  pokemon(name: "Pikachu") {
    classification
  }
}
```

`query` … 操作
`name` … 引数
`"Pikachu"` … 値
`pokemon`, `classification` … フィールド

---

子孫関係

```graphql
query {
  pokemon(name: "Pikachu") {
    classification
    height {
      minimum
      maximum
    }
  }
}
```

`height` フィールドの中の `minimum`, `maximum` フィールド

---

変数を使った query の再利用

```graphql
query ($name: String!) {
  pokemon(name: $name) {
    classification
    height {
      minimum
      maximum
    }
  }
}
```

\+

```json
{
  "name": "Pikachu"
}
```

`$name` … 変数
`String!` … 型

---

操作を名付ける

```graphql
query fetchPikachu {
  pokemon(name: "Pikachu") {
    classification
  }
}
```

`fetchPikachu` … 操作名

---

フィールドを名付ける

```graphql
query {
  pikachu: pokemon(name: "Pikachu") {
    classification
  }
}
```

`pikachu` … エイリアス

---

フラグメント

```graphql
fragment dimension on PokemonDimension {
  minimum
  maximum
}

query {
  pokemon(name: "Pikachu") {
    classification
    height {
      ...dimension
    }
    weight {
      ...dimension
    }
  }
}
```

`dimension` … フラグメント

---

ディレクティブ

```graphql
query ($showClassification: Boolean!) {
  pokemon(name: "Pikachu") {
    classification @include(if: $showClassification)
  }
}
```

\+

```json
{
  "showClassification": true
}
```

`@include` … ディレクティブ

---

## まとめ

- 3 種類の操作
- Query によるデータの取得

---

## フィードバック

[このスライドを編集する](https://github.com/kou029w/intro-to-graphql/edit/main/README.md) / [問題を報告する](https://github.com/kou029w/intro-to-graphql/issues/new)

---

## 後付

---

### より理解を深めるための知識

- [山本陽平「Web を支える技術」](https://gihyo.jp/book/2010/978-4-7741-4204-3) - HTTP の基礎知識、REST
- [Eve Porcello、Alex Banks「初めての GraphQL」](https://www.oreilly.co.jp/books/9784873118932/)
- [GraphQL \| A query language for your API](https://graphql.org/)
- [How to GraphQL \- The Fullstack Tutorial for GraphQL](https://www.howtographql.com/)
- [Fullstack GraphQL Tutorial Series \| Learn GraphQL Frontend and Backend](https://hasura.io/learn/)

---

### セキュリティ

セキュリティの懸念事項は一般的な Web サービスと同様に存在

- [OWASP Top Ten](https://owasp.org/www-project-top-ten/)
- [GraphQL \- OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/GraphQL_Cheat_Sheet.html)

---

### 認証・認可

GraphQL 仕様に含まないので一般的な Web の認証・認可の設計と同様に行う

- [OpenID](https://openid.net/)
- [OAuth](https://oauth.net/)
- [JWT](https://jwt.io/)

---

### キャッシュ

GraphQL には[グローバルなオブジェクトの識別子の宣言によるキャッシュ機構](https://graphql.org/learn/caching/)がある

もし HTTP GET メソッドを使用する場合、[HTTP キャッシュ](https://developer.mozilla.org/ja/docs/Web/HTTP/Caching)を利用できる

---

### JSON Serialization

| GraphQL Value     | JSON Value    |
| ----------------- | ------------- |
| Map               | Object        |
| List              | Array         |
| Null              | null          |
| String/Enum Value | String        |
| Boolean           | true or false |
| Int/Float         | Number        |

https://spec.graphql.org/June2018/#sec-JSON-Serialization
