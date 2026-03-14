import gleam/list

/// Built-in problem codes used by standard validators.
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

/// A single validation problem with machine-readable code and message.
pub type Problem {
  Problem(code: ProblemCode, message: String)
}

/// Validation draft that carries a value and accumulated problems.
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

/// Get all accumulated problems from a draft.
pub fn problems(draft: Draft(a)) -> List(Problem) {
  draft.problems
}

/// Returns True when the draft currently has no problems.
pub fn has_problems(draft: Draft(a)) -> Bool {
  list.is_empty(draft.problems)
}

/// Count the number of accumulated problems in a draft.
pub fn problem_count(draft: Draft(a)) -> Int {
  list.length(draft.problems)
}

/// Extract the current value from a draft.
pub fn value(draft: Draft(a)) -> a {
  draft.value
}

/// Construct a problem from a code and human-readable message.
pub fn problem(code: ProblemCode, message: String) -> Problem {
  Problem(code, message)
}

/// Extract the problem code.
pub fn code(problem: Problem) -> ProblemCode {
  problem.code
}

/// Extract the human-readable problem message.
pub fn message(problem: Problem) -> String {
  problem.message
}
