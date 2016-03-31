module Main.StartApp where

import Html exposing (Html, div, button, span, p, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

-- Model

type alias Model = Int

initialModel : Model
initialModel = 0

-- Update

type Action =
  NoOp
  | Increment
  | Decrement


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Increment ->
      model + 1
    Decrement ->
      model - 1

-- View

view : Signal.Address Action -> Int -> Html
view address value =
  div []
    [ button [ onClick address Increment ] [ text "+" ]
    , button [ onClick address Decrement ] [ text "-" ]
    , p [ ] [ text (toString value) ]
    ]


-- Main

main : Signal Html
main =
  StartApp.start
  { model = initialModel
  , view = view
  , update = update
  }

