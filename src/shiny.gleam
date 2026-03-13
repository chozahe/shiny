import gleam/list

pub type ProblemCode {
  NotBlank
  MinLength
  MaxLength
  Min
  Max
  Between
  NotEmpty
  MinItems
  MaxItems
  OneOf
  Custom(String)
}

pub type Problem {
  Problem(code: ProblemCode, message: String)
}

pub opaque type Draft(a) {
  Draft(value: a, problems: List(Problem))
}

/// Start a validation pipeline from a value
pub fn from(value: a) -> Draft(a) {
  Draft(value: value, problems: [])
}

/// Turn a draft into a final validation result.
/// Returns Ok(value) when there are no problems
/// otherwise Error(list_of_problems)
pub fn validate(draft: Draft(a)) -> Result(a, List(Problem)) {
  case list.is_empty(draft.problems) {
    True -> Ok(draft.value)
    False -> Error(draft.problems)
  }
}
