# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  export: [
    locals_without_parens: [earlyret: 1, defearlyret: 2, defpearlyret: 2, ret_if: 2]
  ]
]
