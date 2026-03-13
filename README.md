# shiny

**shiny** is a small validation library for Gleam. It runs all the checks and collects every problem instead of stopping at the first one.

Returns `Result(a, List(Problem))` — either `Ok(value)` or `Error(problems)`.

## Why shiny?

Without shiny, validation in Gleam looks like this:

```gleam
pub fn validate_email(email: String) {
  case email == "" {
    True ->
      Error([Problem(NotBlank, "Email is required")])
    False ->
      case string.length(email) < 5 {
        True ->
          Error([Problem(MinLength, "Email is too short")])
        False ->
          Ok(email)
      }
  }
}
```

Every new rule adds another level of nesting. It gets ugly fast.

With shiny:

```gleam
import shiny
import shiny/string as string

pub fn validate_email(email: String) {
  shiny.from(email)
  |> string.not_blank("Email is required")
  |> string.min_length(5, "Email is too short")
  |> shiny.validate
}
```

You get back either `Ok("user@example.com")` or all the problems at once:

```gleam
Error([
  Problem(NotBlank, "Email is required"),
  Problem(MinLength, "Email is too short")
])
```

## Goals

- simple pipeline-friendly API
- collects all problems, not just the first one
- focused on single value validation
