# Hamlit

[![Gem Version](https://badge.fury.io/rb/hamlit.svg)](http://badge.fury.io/rb/hamlit)
[![test](https://github.com/k0kubun/hamlit/workflows/test/badge.svg)](https://github.com/k0kubun/hamlit/actions?query=workflow%3Atest)

Hamlit is a high performance [Haml](https://github.com/haml/haml) implementation.

## Project status

**Hamlit's implementation was copied to Haml 6.**
From Haml 6, you don't need to switch to Hamlit.

Both Haml 6 and Hamlit are still maintained by [@k0kubun](https://github.com/k0kubun).
While you don't need to immediately deprecate Hamlit, Haml 6 has more maintainers
and you'd better start a new project with Haml rather than Hamlit,
given no performance difference between them.

## Introduction

### What is Hamlit?
Hamlit is another implementation of [Haml](https://github.com/haml/haml).
With some [Hamlit's characteristics](REFERENCE.md#hamlits-characteristics) for performance,
Hamlit is **1.94x times faster** than the original Haml 5 in [this benchmark](benchmark/run-benchmarks.rb),
which is an HTML-escaped version of [slim-template/slim's one](https://github.com/slim-template/slim/blob/4.1.0/benchmarks/run-benchmarks.rb) for fairness. ([Result on Travis](https://travis-ci.org/github/k0kubun/hamlit/jobs/732178446))

<img src="https://raw.githubusercontent.com/k0kubun/hamlit/afcc2b36c4861c2f764baa09afd9530ca25eeafa/benchmark/graph/graph.png" width="600x" alt="Hamlit Benchmark" />

```
      hamlit v2.13.0:   247404.4 i/s
        erubi v1.9.0:   244356.4 i/s - 1.01x slower
         slim v4.1.0:   238254.3 i/s - 1.04x slower
         faml v0.8.1:   197293.2 i/s - 1.25x slower
         haml v5.2.0:   127834.4 i/s - 1.94x slower
```

### Why is Hamlit fast?

#### Less string concatenation by design
As written in [Hamlit's characteristics](REFERENCE.md#hamlits-characteristics),
Hamlit drops some not-so-important features which require works on runtime.
With the optimized language design, we can reduce the string concatenation
to build attributes.

#### Static analyzer
Hamlit analyzes Ruby expressions with Ripper and render it on compilation if the expression
is static. And Hamlit can also compile string literal with string interpolation to reduce
string allocation and concatenation on runtime.

#### C extension to build attributes
While Hamlit has static analyzer and static attributes are rendered on compilation,
dynamic attributes must be rendered on runtime. So Hamlit optimizes rendering on runtime
with C extension.

## Usage

See [REFERENCE.md](REFERENCE.md) for details.

### Rails

Add this line to your application's Gemfile or just replace `gem "haml"` with `gem "hamlit"`.
It enables rendering by Hamlit for \*.haml automatically.

```rb
gem 'hamlit'
```

If you want to use view generator, consider using [hamlit-rails](https://github.com/mfung/hamlit-rails).

### Sinatra

Replace `gem "haml"` with `gem "hamlit"` in Gemfile, and require "hamlit".

While Haml disables `escape_html` option by default, Hamlit enables it for security.
If you want to disable it, please write:

```rb
set :haml, { escape_html: false }
```


## Command line interface

You can see compiled code or rendering result with "hamlit" command.

```bash
$ gem install hamlit
$ hamlit --help
Commands:
  hamlit compile HAML    # Show compile result
  hamlit help [COMMAND]  # Describe available commands or one specific command
  hamlit parse HAML      # Show parse result
  hamlit render HAML     # Render haml template
  hamlit temple HAML     # Show temple intermediate expression

$ cat in.haml
- user_id = 123
%a{ href: "/users/#{user_id}" }

# Show compiled code
$ hamlit compile in.haml
_buf = [];  user_id = 123;
; _buf << ("<a href='/users/".freeze); _buf << (::Hamlit::Utils.escape_html((user_id))); _buf << ("'></a>\n".freeze); _buf = _buf.join

# Render html
$ hamlit render in.haml
<a href='/users/123'></a>
```

## Contributing

### Reporting an issue

Please report an issue with following information:

- Full error backtrace
- Haml template
- Ruby version
- Hamlit version
- Rails/Sinatra version

### Coding styles

Please follow the existing coding styles and do not send patches including cosmetic changes.

## License

Copyright (c) 2015 Takashi Kokubun
