import gleam/bool
import gleam/string
import shiny.{type Draft, NotBlank}

pub fn not_blank(draft: Draft(String), message: String) -> Draft(String) {
  shiny.ensure(draft, is_not_blank, NotBlank, message)
}

pub fn min_length(
  draft: Draft(String),
  min: Int,
  message: String,
) -> Draft(String) {
  shiny.ensure(draft, has_min_length(min), shiny.MinLength, message)
}

pub fn max_length(
  draft: Draft(String),
  max: Int,
  message: String,
) -> Draft(String) {
  shiny.ensure(draft, has_max_length(max), shiny.MaxLength, message)
}

fn is_not_blank(value: String) -> Bool {
  value
  |> string.trim
  |> string.is_empty
  |> bool.negate
}

fn has_min_length(min: Int) -> fn(String) -> Bool {
  fn(value) { string.length(value) >= min }
}

fn has_max_length(max: Int) -> fn(String) -> Bool {
  fn(value) { string.length(value) <= max }
}
