import gleam/bool
import gleam/string
import shiny.{type Draft, NotBlank}

pub fn not_blank(draft: Draft(String), message: String) -> Draft(String) {
  shiny.ensure(draft, is_not_blank, NotBlank, message)
}

fn is_not_blank(value: String) -> Bool {
  value
  |> string.trim
  |> string.is_empty
  |> bool.negate
}
