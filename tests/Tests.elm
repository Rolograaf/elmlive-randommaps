module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Map


mapTests : Test
mapTests =
    describe "Map module"
        [ test "any with all points false" <|
            \() ->
                Map.any (\tile -> False) (always "grass")
                    |> Expect.false "Expected any to return false"
        , test "any with all points true" <|
            \() ->
                Map.any (\tile -> True) (always "grass")
                    |> Expect.true "Expected any to return true"
        , test "any with first points false, but others true" <|
            \() ->
                Map.any (\tile -> tile == "grass")
                    (\{ x } ->
                        if x == 0 then
                            "rock"
                        else
                            "grass"
                    )
                    |> Expect.true "Expected any to return true"
        , test "any with first row false, but others true" <|
            \() ->
                Map.any (\tile -> tile == "grass")
                    (\{ y } ->
                        if y == 0 then
                            "rock"
                        else
                            "grass"
                    )
                    |> Expect.true "Expected any to return true"
        ]


all : Test
all =
    describe "all tests"
        [ mapTests ]



-- all : Test
-- all =
--     describe "Town Map generation"
--         [ test "map contains grass" <|
--             \() ->
--                 createRandomMap
--                     |> Map.any (\tile -> tile == "grass")
--                     |> Expect.true
--         ]
