module Benchmark.Runner.InProgress exposing (Class, styles, view)

import Benchmark.Reporting as Reporting exposing (Report(..))
import Benchmark.Runner.Box as Box
import Benchmark.Runner.Text as Text
import Benchmark.Status as Status exposing (Status(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Sheet as Sheet


view : Report -> Element Class variation msg
view report =
    report
        |> progressBars []
        |> (::) (Text.hero TextClass "Benchmarks Running")
        |> column Unstyled []


progressBars : List String -> Report -> List (Element Class variation msg)
progressBars reversedParents report =
    case report of
        Single name status ->
            [ barsWithPath (List.reverse reversedParents) [ ( name, status ) ] ]

        Series name statuses ->
            [ barsWithPath (List.reverse <| name :: reversedParents) statuses ]

        Group name reports ->
            reports
                |> List.map (progressBars (name :: reversedParents))
                |> List.concat


barsWithPath : List String -> List ( String, Status ) -> Element Class variation msg
barsWithPath parents children =
    column Unstyled
        [ paddingTop Box.spaceBetweenSections ]
        (Text.path TextClass parents
            :: List.map (\( a, b ) -> progressBar a b) children
        )


progressBar : String -> Status -> Element Class variation msg
progressBar name status =
    row Box
        [ paddingXY Box.barPaddingX Box.barPaddingY
        , width (percent 100)
        ]
        [ caption name status ]
        |> within [ filledPortion name status ]


caption : String -> Status -> Element Class variation msg
caption name status =
    let
        informativeStatus =
            case status of
                Cold ->
                    "Warming JIT"

                Unsized ->
                    "Finding sample size"

                Pending _ _ ->
                    "Collecting samples"

                Failure _ ->
                    "Failed!"

                Success _ _ ->
                    "Finished"
    in
    row Unstyled
        [ width (px 500), spread, verticalCenter ]
        [ text name
        , el Status [] (text informativeStatus)
        ]


filledPortion : String -> Status -> Element Class variation msg
filledPortion name status =
    if Status.progress status > 0 then
        el Progress
            [ paddingTop Box.barPaddingY
            , paddingBottom Box.barPaddingY
            , paddingLeft Box.barPaddingX
            , clip
            , width
                (status
                    |> Status.progress
                    |> (*) 100
                    |> percent
                )

            -- display as a progressbar for a11y
            , attribute "role" "progressbar"
            , attribute "aria-valuenow"
                (status
                    |> Status.progress
                    |> (*) 100
                    |> floor
                    |> String.fromInt
                )
            , attribute "aria-valuemin" "0"
            , attribute "aria-valuemax" "100"
            ]
            (caption name status)

    else
        empty



-- STYLES


type Class
    = Unstyled
    | Path
    | Box
    | Progress
    | Status
    | TextClass Text.Class


styles : List (Style Class variation)
styles =
    [ style Unstyled []
    , style Box Box.style
    , style Progress
        [ Color.text (Style.rgb (248 / 255) (248 / 255) (248 / 255))
        , Color.background (Style.rgb (87 / 255) (171 / 255) (226 / 255))
        ]
    , style Status
        [ Font.size 14 ]
    , Text.styles
        |> Sheet.map TextClass identity
        |> Sheet.merge
    ]
