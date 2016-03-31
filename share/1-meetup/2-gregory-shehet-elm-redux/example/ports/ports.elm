module Main.Ports where

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

-- Model

type alias Model = Int

initialModel : Model
initialModel = 0

-- Update

type Action =
  NoOp
  | Update String


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    Update action ->
      case action of
        "Increment" ->
          model + 1
        "Decrement" ->
          model - 1
        _ ->
         model

-- View

view : Int -> Html
view value =
  div [] [ text (toString value) ]

-- PORTS

port modelValue : Signal String

port modelChanges : Signal Model
port modelChanges =
  model

-- SIGNALS

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

actions : Signal Action
actions =
  Signal.merge inbox.signal (Signal.map Update modelValue)

model : Signal Model
model =
  Signal.foldp update initialModel actions

main : Signal Html
main =
  Signal.map view  model

