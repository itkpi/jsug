module Main where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)

import Keyboard
import Window
import Time


-- MODEL

type alias Model =
  { x: Int
  , y: Int
  , direction : Action
  }

initialModel : Model
initialModel =
  { x = 0
  , y = -100
  , direction = Top
  }


-- UPDATE

type Action
  = NoOp
  | Left
  | Right
  | Top
  | Bottom

update : Action -> Model -> Model
update action ship =
  case action of
    NoOp ->
      ship
    Left ->
      { ship | x = ship.x - 1, direction = action }
    Right ->
      { ship | x = ship.x + 1, direction = action }
    Top ->
      { ship | y = ship.y + 1, direction = action }
    Bottom ->
      { ship | y = ship.y - 1, direction = action }


-- VIEW

drawGame : Float -> Float -> Form
drawGame w h =
  rect w h
    |> filled gray

drawShip : Float -> Model -> Form
drawShip gameHeight ship =
  let
    d =
      case ship.direction of
        Bottom -> -60
        Top    ->  0
        Left   -> -30
        Right  ->  30
        _      ->  0
  in
    ngon 3 20
      |> filled blue
      |> rotate (degrees 90)
      |> move ((toFloat ship.x), (toFloat ship.y))
      |> rotate (degrees d)

view : (Int, Int) -> Model -> Element
view (w, h) ship =
  let
    (w', h') = (toFloat w, toFloat h)
  in
    collage w h
      [ drawGame w' h'
      , drawShip h' ship
      , toForm (show ship)
      ]


-- SIGNALS

directionX : Signal Action
directionX =
  let
    x = Signal.map .x Keyboard.arrows
    delta = Time.fps 1000

    toAction n =
      case n of
        -1 -> Left
        1  -> Right
        _  -> NoOp

    actions = Signal.map toAction x
  in
    Signal.sampleOn delta actions

directionY : Signal Action
directionY =
  let
    y = Signal.map .y Keyboard.arrows
    delta = Time.fps 1000

    toAction n =
      case n of
        -1 -> Bottom
        1  -> Top
        _  -> NoOp

    actions = Signal.map toAction y
  in
    Signal.sampleOn delta actions

input : Signal Action
input =
  Signal.mergeMany [directionX, directionY]

model : Signal Model
model =
  Signal.foldp update initialModel input

main : Signal Element
main =
  Signal.map2 view Window.dimensions model
