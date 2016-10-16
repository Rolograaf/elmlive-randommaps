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
        [ -- THIS WAS CONTAINS AT LEAST SOME GRASS  STANDARD NOT FUZZY
          -- test "map contains some grass" <|
          --     \() ->
          --         Maps.Town.map ( 1, 1 )
          --             |> Map.any (\tile -> tile == "grass")
          --             |> Expect.true "Expected map to contain grass" ,
          fuzz Fuzz.int "contains at least 10% grass" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> countTiles "grass"
                    |> Expect.greaterThan 10
        , fuzz Fuzz.int "contains at least 10% road" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> countTiles "road"
                    |> Expect.greaterThan 10
        , fuzz Fuzz.int "has exactly one inn" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> countTiles "inn"
                    |> Expect.equal 1
        , fuzz Fuzz.int "has at least one armor shop" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> countTiles "armor shop"
                    |> Expect.greaterThan 0
        , fuzz Fuzz.int "has at least one weapon shop" <|
            \seed ->
                Random.step Maps.Town.random (Random.initialSeed seed)
                    |> fst
                    |> countTiles "weapon shop"
                    |> Expect.greaterThan 0
          -- THIS WAS CONTAINS AT LEAST A ROAD FUZZY
          -- Random.step Maps.Town.random (Random.initialSeed seed)
          --     |> fst
          --     |> Map.any (\tile -> tile == "road")
          --     |> Expect.true "Expected map to contain road"
          -- THIS WAS CONTAINS AT LEAST A ROAD STANDARD NOT FUZZY
          -- , test "map contains some road" <|
          --     \() ->
          --         Maps.Town.map ( 2, 2 )
          --             |> Map.any (\tile -> tile == "road")
          --             |> Expect.true "Expected map to contain some road"
        ]



-- Helper function for folding over the map in the tests


countTiles : String -> Map.Map -> Int
countTiles tileToCount map =
    Map.fold
        (\tile acc ->
            if tile == tileToCount then
                acc + 1
            else
                acc
        )
        0
        map


all : Test
all =
    describe "all tests"
        [ mapTests
        , townMapTests
        ]
