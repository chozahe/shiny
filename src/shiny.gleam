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

/// Add a problem if predicate returns False.
pub fn ensure(
  draft: Draft(a),
  predicate: fn(a) -> Bool,
  code: ProblemCode,
  message: String,
) -> Draft(a) {
  case predicate(draft.value) {
    True -> draft
    False ->
      Draft(draft.value, list.prepend(draft.problems, Problem(code, message)))
  }
}

/// Add a custom-named problem if predicate returns False
pub fn custom(
  draft: Draft(a),
  predicate: fn(a) -> Bool,
  code: String,
  message: String,
) -> Draft(a) {
  case predicate(draft.value) {
    True -> draft
    False ->
      Draft(
        draft.value,
        list.prepend(draft.problems, Problem(Custom(code), message)),
      )
  }
}

pub fn problems(draft: Draft(a)) -> List(Problem) {
  draft.problems
}

pub fn has_problems(draft: Draft(a)) -> Bool {
  list.is_empty(draft.problems)
}

pub fn problem_count(draft: Draft(a)) -> Int {
  list.length(draft.problems)
}

pub fn value(draft: Draft(a)) -> a {
  draft.value
}

pub fn problem(code: ProblemCode, message: String) -> Problem {
  Problem(code, message)
}

pub fn code(problem: Problem) -> ProblemCode {
  problem.code
}

pub fn message(problem: Problem) -> String {
  problem.message
}
