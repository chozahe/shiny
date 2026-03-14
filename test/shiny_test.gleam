import gleeunit
import gleeunit/should
import shiny

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn validate_returns_ok_when_no_problems_test() {
  let result =
    shiny.from(42)
    |> shiny.validate

  result
  |> should.equal(Ok(42))
}

pub fn ensure_false_adds_problem_and_validate_returns_error_test() {
  let result =
    shiny.from("abc")
    |> shiny.ensure(fn(value) { value == "" }, shiny.NotBlank, "must be blank")
    |> shiny.validate

  result
  |> should.equal(Error([shiny.problem(shiny.NotBlank, "must be blank")]))
}

pub fn custom_and_ensure_accumulate_problems_test() {
  let draft =
    shiny.from("abc")
    |> shiny.ensure(fn(_) { False }, shiny.MinLength, "too short")
    |> shiny.custom(fn(_) { False }, "email", "invalid email")

  draft
  |> shiny.problem_count
  |> should.equal(2)

  draft
  |> shiny.problems
  |> should.equal([
    shiny.problem(shiny.Custom("email"), "invalid email"),
    shiny.problem(shiny.MinLength, "too short"),
  ])
}

pub fn has_problems_reports_empty_problem_list_test() {
  let clean = shiny.from("ok")
  let dirty =
    shiny.from("x")
    |> shiny.ensure(fn(_) { False }, shiny.NotBlank, "required")

  clean
  |> shiny.has_problems
  |> should.equal(True)

  dirty
  |> shiny.has_problems
  |> should.equal(False)
}

pub fn value_and_problem_accessors_test() {
  let draft = shiny.from(7)
  let p = shiny.problem(shiny.Max, "too big")

  draft
  |> shiny.value
  |> should.equal(7)

  p
  |> shiny.code
  |> should.equal(shiny.Max)

  p
  |> shiny.message
  |> should.equal("too big")
}
