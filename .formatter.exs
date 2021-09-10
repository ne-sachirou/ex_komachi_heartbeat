# Used by "mix format"
[
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "examples/plug_example/{config,lib,test}/**/*.{ex,exs}",
    "examples/phx_example/{config,lib,test}/**/*.{ex,exs}"
  ],
  export: [
    line_length: 120,
    locals_without_parens: []
  ]
]
