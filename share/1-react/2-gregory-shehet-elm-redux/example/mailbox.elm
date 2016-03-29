module Main.Mailbox where

import Html exposing (Html, div, button, span, p, text)
import Html.Events exposing (onClick)

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
    [ button [ onClick address Increment ] [ text "+" ],
      button [ onClick address Decrement ] [ text "-" ],
      p [ ] [ text (toString value) ]
    ]


-- Main

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

actions : Signal Action
actions =
  inbox.signal

model : Signal Model
model =
  Signal.foldp update initialModel actions

main : Signal Html
main =
  Signal.map (view inbox.address) model

