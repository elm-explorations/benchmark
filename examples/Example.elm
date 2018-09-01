module Example exposing (dict, main, match)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Dict
import Regex exposing (Regex)


dict : Benchmark
dict =
    let
        dest =
            Dict.singleton "a" 1
    in
    Benchmark.describe "dictionary"
        [ Benchmark.benchmark "get" (\_ -> Dict.get "a" dest)
        , Benchmark.benchmark "insert" (\_ -> Dict.insert "b" 2 dest)
        ]


regex : Regex
regex =
    Regex.fromString "^a+"
        |> Maybe.withDefault Regex.never


match : Benchmark
match =
    Benchmark.benchmark "regex match" <|
        \_ ->
            Regex.contains regex
                "aaaaaaaaaaaaaaaaaaaaaaaaaa"


main : BenchmarkProgram
main =
    program <|
        Benchmark.describe "sample"
            [ dict
            , match
            ]
