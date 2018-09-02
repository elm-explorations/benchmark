module Benchmark.Runner.Box exposing (barPaddingX, barPaddingY, spaceBetweenSections, style)

import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Shadow as Shadow


spaceBetweenSections : Float
spaceBetweenSections =
    25


barPaddingX : Float
barPaddingX =
    15


barPaddingY : Float
barPaddingY =
    7


style : List (Property class variation)
style =
    [ Color.background (Style.rgb (248 / 255) (248 / 255) (248 / 255))
    , Shadow.box
        { offset = ( 0, 1 )
        , size = 0
        , blur = 2
        , color = Style.rgba (15 / 255) (30 / 255) (45 / 255) 0.1
        }
    , Font.size 24
    ]
