---
marp: true
paginate: true
---

# GraphQL概論

WebDINO Japan エンジニア
[渡邉浩平](https://github.com/kou029w)
![w:200](https://github.com/kou029w.png)

---

## GraphQLとは

https://graphql.org

---

### GraphQLとはAPIのクエリ言語

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

## GraphQLとは

- APIのクエリ言語
- クエリ言語の型を宣言するGraphQLスキーマ言語
- Webクライアントとサーバーのためのアプリケーション層の仕様

### GraphQL以外の身近な言語の例:
- クエリ言語: SQL
- スキーマ言語: [JSON Schema](https://json-schema.org/), [XSD](http://www.w3.org/TR/xmlschema11-1/)

---

## 歴史

- 2012年 Facebookによる開発
- 2015年 オープンソース化
- 2019年 [GraphQL Foundation](https://graphql.org/foundation/)に移管

オープンソースな仕様になっており、自由に[貢献可能](https://github.com/graphql/graphql-spec/blob/main/CONTRIBUTING.md)

---

## 主な仕様

- [使用可能なデータの構造とその操作を宣言するための言語 (スキーマ言語)](https://graphql.org/learn/introspection/)
- [サーバーにデータを要求するための言語 (クエリ言語)](https://graphql.org/learn/queries/)
- [クエリの実行方法 (Resolvers)](https://graphql.org/learn/execution/)
- [クライアントの受け取るデータ形式 (JSON)](https://graphql.org/learn/serving-over-http/#response)

---

## 何でないか

- データベースではない
- JavaScriptではない

---

## なぜGraphQLを使うのか

1. 単一リクエスト
2. 型システム
3. 開発ツール

---

### 1. 単一リクエスト

効率的なデータ読み込み

オーバーフェッチを最小限に抑え、サーバーへのラウンドトリップを少なくする
FacebookがGraphQLを開発した理由は、[モバイルネイティブアプリへの移行のため](https://reactjs.org/blog/2015/05/01/graphql-introduction.html)
スマホの普及に伴う低速、省電力なデバイスの利用の増加が背景

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

単一APIの構築と正確なデータ構造の維持
クライアントアプリケーションを実行するフロントエンドフレームワークとプラットフォームの多様化が背景

---

#### GraphQLスキーマ言語

```graphql=
"""ポケモンを表します"""
type Pokemon {
  """このオブジェクトのID"""
  id: ID!

  """このポケモンの全国図鑑No."""
  number: String

  """このポケモンの名前"""
  name: String

  """このポケモンの重さの最大と最小"""
  weight: PokemonDimension

  """このポケモンの高さの最大と最小"""
  height: PokemonDimension

  """このポケモンの分類"""
  classification: String

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
"""ポケモンを表します"""
type Pokemon {
  """このオブジェクトのID"""
  id: ID!

  """このポケモンの名前"""
  name: String

  """このポケモンの分類"""
  classification: String

  """このポケモンの高さの最大と最小"""
  height: PokemonDimension
}
```

オブジェクトに含まれるフィールド

---

#### 特定のプログラミング言語に依存しない

```javascript
// JavaScript
const pokemonQuery = `{ pokemon(name: "Pikachu") { classification } }`;

fetch(`http://example/?${new URLSearchParams({ query: pokemonQuery })}`)
  .then(r => r.json())
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

https://www.apollographql.com

---

### 3. 開発ツール

短期間での開発

クライアントアプリケーションの設計変更に対応するためのツールが提供されている
継続的デプロイ (CD) が背景

---

#### IDE - GraphiQL

![h:600 GraphiQL](https://raw.githubusercontent.com/graphql/graphiql/main/packages/graphiql/resources/graphiql.jpg)

https://github.com/graphql/graphiql

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

GraphQLサーバー
接続したデータベースを自動的にGraphQL APIとして提供

https://hasura.io

---

## まとめ

- GraphQLとはデータを問い合わせるクエリ言語仕様と周辺技術
- 単一リクエスト/型システム/開発ツール

---

## GraphQLをもっと知る

---

## GraphQL Operation

3種類の操作

- query - 読み取り
- mutation - 書き込み
- subscription - イベントストリーム

1つのリクエストに複数の操作を含めることが可能

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

変数を使ったqueryの再利用

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

- 3種類の操作
- Queryによるデータの取得

---

## 後付

---

### より理解を深めるための知識

- [山本陽平「Webを支える技術」](https://gihyo.jp/book/2010/978-4-7741-4204-3) - HTTPの基礎知識、REST
- [GraphQL \| A query language for your API](https://graphql.org/)
- [How to GraphQL \- The Fullstack Tutorial for GraphQL](https://www.howtographql.com/)
- [Fullstack GraphQL Tutorial Series \| Learn GraphQL Frontend and Backend](https://hasura.io/learn/)

---

### 何を話していないか

- [Mutation](https://graphql.org/learn/queries/#mutations)
- [Introspection](https://graphql.org/learn/introspection/)
- [エラーレスポンス](http://spec.graphql.org/June2018/#sec-Errors)
- [Validation](https://graphql.org/learn/validation/)
- [Execution](https://graphql.org/learn/execution/)
- [Subscription](https://spec.graphql.org/June2018/#sec-Subscription)

---

### セキュリティ

セキュリティの懸念事項は一般的なWebサービスと同様に存在

- [OWASP Top Ten](https://owasp.org/www-project-top-ten/)
- [GraphQL \- OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/GraphQL_Cheat_Sheet.html)

---

### 認証・認可

GraphQL仕様に含まないので一般的なWebの認証・認可の設計と同様に行う

- [OpenID](https://openid.net/)
- [OAuth](https://oauth.net/)
- [JWT](https://jwt.io/)

---

### キャッシュ

HTTP GETメソッドによる一般的な[HTTP キャッシュ](https://developer.mozilla.org/ja/docs/Web/HTTP/Caching)に加え、GraphQLでは[グローバルなオブジェクトの識別子の宣言](https://graphql.org/learn/global-object-identification/)による[キャッシュ](https://graphql.org/learn/caching/)が存在

---

### JSON Serialization

GraphQL Value	|JSON Value
---|---
Map	|Object
List	|Array
Null	|null
String/Enum Value	|String
Boolean	|true or false
Int/Float	|Number

https://spec.graphql.org/June2018/#sec-JSON-Serialization
