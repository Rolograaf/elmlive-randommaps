module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz
import String
import Map
import Dict exposing (Dict)
import Maps.Town
import Random


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
                    (\( x, y ) ->
                        if x == 0 then
                            "rock"
                        else
                            "grass"
                    )
                    |> Expect.true "Expected any to return true"
        , test "any with first row false, but others true" <|
            \() ->
                Map.any (\tile -> tile == "grass")
                    (\( x, y ) ->
                        if y == 0 then
                            "rock"
                        else
                            "grass"
                    )
                    |> Expect.true "Expected any to return true"
        ]


townMapTests : Test
townMapTests =
    describe "Town Map generation"
        [ -- test "map contains some grass" <|
          --     \() ->
          --         Maps.Town.map ( 1, 1 )
          --             |> Map.any (\tile -> tile == "grass")
          --             |> Expect.true "Expected map to contain grass" ,
          fuzz Fuzz.int "contains some grass" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> Map.any (\tile -> tile == "grass")
                    |> Expect.true "Expected map to contain grass"
        , fuzz Fuzz.int "contains some road" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> Map.any (\tile -> tile == "road")
                    |> Expect.true "Expected map to contain road"
          -- , test "map contains some road" <|
          --     \() ->
          --         Maps.Town.map ( 2, 2 )
          --             |> Map.any (\tile -> tile == "road")
          --             |> Expect.true "Expected map to contain some road"
        ]


all : Test
all =
    describe "all tests"
        [ mapTests
        , townMapTests
        ]
