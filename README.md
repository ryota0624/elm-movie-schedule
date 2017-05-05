#memo
- [tutolial](https://www.elm-tutorial.org/jp/)
- elm-package install
- elm-reactor
- elm-make App.elm

# elm-monocle

## monocle とは
- 僕は http://qiita.com/miyamo_madoka/items/f225803d275019cc34c1 を読んで知りました
- scalaのMonocleのインスパイアライブラリ
  - [scala Monocle](http://julien-truffaut.github.io/Monocle/)
   - これもHaskellのLensからインスパイア
- 複雑なレコードを操作するためのライブラリ


## どんなときに便利なのか
- 複雑なレコードを操作するとき
### 映画は物語を持つというレコードがあるとして
```
type alias Story =
    { text : String
    }


type alias Movie =
    { name : String
    , story : Story
    }
```
### スターウォーズシリーズの外伝が作られることになりました
```
starwardsSpineOff : Movie
starwardsSpineOff =
    Movie "starwords:SpineOff" (Story "遠い...未定")
```
### 正式タイトルが決まり、ストーリーも更新されます！
```
rogueOne : Movie
rogueOne =
    { starwardsSpineOff
        | name = "rogueOne: A star Wars Story"
        , story = { starwardsSpineOff.story | text = "遠い昔、はるか彼方の銀河系で…。" }
    }
```
### しかし、これではコンパイルが通りません。 なので以下のようにしました
```
rogueOne : Movie
rogueOne =
    let
        oldStory =
            starwardsSpineOff.story

        newStory =
            { oldStory | text = "遠い昔、はるか彼方の銀河系で…。" }
    in
        { starwardsSpineOff
            | name = "rogueOne: A star Wars Story"
            , story = { newStory | text = "遠い昔、はるか彼方の銀河系で…。" }
        }
```
レコード内の奥深くのフィールドを更新して新しいレコードを作ろうとすると見辛いコードが増えていきますね‥


## こんなとき elm-monocleのLensを使うと見栄えがよくなる
```
import Monocle.Lens exposing (Lens, compose)
~~略~~

textOfStory : Lens Story String
textOfStory =
    let
        get story =
            story.text

        set text story =
            { story | text = text }
    in
        Lens get set


type alias Movie =
    { name : String
    , story : Story
    }

nameOfMovie : Lens Movie String
nameOfMovie =
    let
        get movie =
            movie.name

        set name movie =
            { movie | name = name }
    in
        Lens get set

storyOfMovie : Lens Movie Story
storyOfMovie =
    let
        get movie =
            movie.story

        set story movie =
            { movie | story = story }
    in
        Lens get set


rogueOne : Movie
rogueOne =
    starwardsSpineOff
        |> nameOfMovie.set "rogueOne: A star Wars Story"
        >> (compose storyOfMovie textOfStory).set "遠い昔、はるか彼方の銀河系で…。"
```

hogeOfHuga: Lens Huge Huga
という関数が増えていてコード自体の量は増えていますが
「rogueOne」を作るコードはすっきりしていませんか？

hogeOfHuga: Lens Huge Huga
のコードも単純でレコードのフィールド一つに対して定義されていて
レコードからフィールドの値をとる`get`と
レコードのフィールドを更新して新しいレコードを返す`set`を定義しているだけで非常にシンプルです

`starwardsSpineOff |> nameOfMovie.set "rogueOne: A star Wars Story"`は`starwardsSpineOff`の`name`フィールドに`"rogueOne: A star Wars Story"`をセットして新しいMovieを返しています

`(compose storyOfMovie textOfStory)`にある`compose`は名の通り合成で、`Movie`をとって`story`フィールドの`text`に対する`Lens`を定義(getとset)してます

## monocleのOptionalを使うともっと楽しくなる
Movieレコードに変更します
storyをMaybe Storyとしましょう
映画には物語がないようなものもあるでしょう
```
type alias Movie =
    { name : String
    , story : Maybe Story
    }
```
Storyレコードに変更をします
StoryにはgoodPointというフィールドがあるとしましょう
映画には見所があるものとないものがあるのでMaybeで定義しましょう
```
type alias Story =
    { text : String
    , screeningTime : Int
    , goodPoint : Maybe GoodPoint
    , writer : Writer
    }
```
映画の見どころとは言葉で表せないこともあるのでフィールド`text`はMaybeです
```
type alias Text = String
type alias GoodPoint =
    { text : Maybe Text
    }
```

ここでmonocleなしで`Movie`から`goodPoint`のフィールド`text`取ってこようとすると...
```
rogueOne = Movie "rogueOne: A star Wars Story" (Just <| Story "遠い..." (Just <| GoodPoint (Just "イケてる俳優")))

rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    rogueOne.story
        |> Maybe.map
            (\{ goodPoint } ->
                goodPoint
                    |> Maybe.map (\{ text } -> text)
                    |> Maybe.withDefault Nothing
            )
        |> Maybe.withDefault Nothing

```
`map`の連打、`withDefault`の嵐、`Maybe`が増えるほどコードがネストすることを察せます

これがset系の操作になったら
```
updatedRogueOne : Movie
updatedRogueOne =
    let
        newGoodPoint : Maybe GoodPoint
        newGoodPoint =
            rogueOne.story
                |> Maybe.map
                    (\story ->
                        story.goodPoint
                            |> Maybe.map (\goodPoint -> { goodPoint | text = "かっこいい宇宙戦" })
                    )
                |> Maybe.withDefault Nothing

        newStory : Maybe Story
        newStory =
            rogueOne.story |> Maybe.map (\story -> { story | goodPoint = newGoodPoint })
    in
        { rogueOne | story = newStory }
```
僕のウデマエでは非常に大変なコードになってしまいました

### Optionalを使ってみよう
```
import Monocle.Optional exposing (Optional)
import Monocle.Common exposing ((=>))
~~略~~

textOfGoodPoint : Optional GoodPoint Text
textOfGoodPoint =
    let
        get goodPoint =
            goodPoint.text

        set text goodPoint =
            { goodPoint | text = Just text }
    in
        Optional get set

goodPointOfStory : Optional Story GoodPoint
goodPointOfStory =
    let
        get story =
            story.goodPoint

        set goodPoint story =
            { story | goodPoint = Just goodPoint }
    in
        Optional get set

--- Lensの例から定義を変更してます
storyOfMovie : Optional Movie Story
storyOfMovie =
    let
        get movie =
            movie.story

        set story movie =
            { movie | story = Just story }
    in
        Optional get set

rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    rogueOne |> (storyOfMovie => goodPointOfStory => textOfGoodPoint).getOption

updatedRogueOne : Movie
updatedRogueOne =
    rogueOne |> (storyOfMovie => goodPointOfStory => textOfGoodPoint).set "かっこいい宇宙戦"

```
Lensのときのように`hogeOfHuga`のような`Optional`の定義が`Maybe`なフィールドの数だけあります
とはいってもこれらの定義もシンプルですね
```
--- MovieからGoodPointのTextをとってくる
rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    rogueOne |> (storyOfMovie => goodPointOfStory => textOfGoodPoint).getOption

--- MovieのGoodPointのTextを更新して新しいMovieを返す
updatedRogueOne : Movie
updatedRogueOne =
    rogueOne |> (storyOfMovie => goodPointOfStory => textOfGoodPoint).set "かっこいい宇宙戦"

```
`=>`はOptional同士のcomposeをする中置関数です


こうするとよりスッキリ
```
movieStoryGoodPointText =
    storyOfMovie => goodPointOfStory => textOfGoodPoint

rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    rogueOne |> movieStoryGoodPointText.getOption

updatedRogueOne : Movie
updatedRogueOne =
    rogueOne |> movieStoryGoodPointText.set "かっこいい宇宙戦"

```

`Movie`の`Story`の`GoodPoint`の`Text`を取り出すコードや、

`Movie`の`Story`の`GoodPoint`の`Text`を更新して新しい`Movie`を返すコード

は非常にスッキリですよね


`Mayb`eのための`withDefault`や`map`がコードから綺麗さっぱりいなくなっていますね
合成された`Optional`は`get`や`set`するためにフィールドを辿るどこかで`Nothing`があったとき、`get`に対して`Nothing`を返したり`set`をしないということをmonocleがヨロシクしてくれます


### LensとOptionalが混ざっているときには
映画のいいところは絶対に言葉になるはずだ！と強い気持ちでフィールド`text`は`Maybe`でなくなりました
```
type alias GoodPoint =
    { text : Text
    }

rogueOne = Movie "rogueOne: A star Wars Story" (Just <| Story "遠い..." (Just <| GoodPoint "イケてる俳優"))

```

そうすると`textOfGoodPoint`の定義は`Optional`から`Lens`になります
```
textOfGoodPoint : Lens GoodPoint Text
textOfGoodPoint =
    let
        get goodPoint =
            goodPoint.text

        set text goodPoint =
            { goodPoint | text = text }
    in
        Lens get set
```
そして実際に`Movie`から`GoodPoint`の`Text`を取り出すコードと

`Movie`の`GoodPoint`の`Text`を更新して新しい`Movie`を返すコードは以下になります
```
movieStoryGoodPointText =
    storyOfMovie => (composeLens goodPointOfStory textOfGoodPoint)

rogueOneGoodPoint : Maybe Text
rogueOneGoodPoint =
    rogueOne |> movieStoryGoodPointText.getOption

updatedRogueOne : Movie
updatedRogueOne =
    rogueOne |> movieStoryGoodPointText.set "かっこいい宇宙戦"
```

OptionalとLensを合成するために`composeLens`を利用するようにしました

### まとめる
- monocleはネストしたレコードの操作をスッキリ書ける
- LensとOptionalはレコードのある１つのフィールドのgetとsetをセットで渡して定義する
- LensとOptionalは合成してレコード操作していく

### 最後に
- 