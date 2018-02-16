[
  inputs: [
    "mix.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "examples/plug_example/{config,lib,test}/**/*.{ex,exs}",
    "examples/phx_example/{config,lib,test}/**/*.{ex,exs}"
  ],
  export: [
    line_length: 80,
    locals_without_parens: []
  ]
]
