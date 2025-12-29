# Hamlit

[![Gem Version](https://badge.fury.io/rb/hamlit.svg)](http://badge.fury.io/rb/hamlit)
[![test](https://github.com/k0kubun/hamlit/workflows/test/badge.svg)](https://github.com/k0kubun/hamlit/actions?query=workflow%3Atest)

Hamlit is a high performance [Haml](https://github.com/haml/haml) implementation.

## Project status

**Hamlit's implementation was copied to Haml 6.**
From Haml 6, you don't need to switch to Hamlit.

Both Haml 6 and Hamlit are still maintained by [k0kubun](https://github.com/k0kubun).
While you don't need to immediately deprecate Hamlit, Haml 6 has more maintainers
and you'd better start a new project with Haml rather than Hamlit,
given no performance difference between them.

## Introduction

### What is Hamlit?
Hamlit is another implementation of [Haml](https://github.com/haml/haml).
With some [Hamlit's characteristics](REFERENCE.md#hamlits-characteristics) for performance,
Hamlit was 1.94x times faster than the original Haml 5 in [this benchmark](benchmark/run-benchmarks.rb),
which is an HTML-escaped version of [slim-template/slim's one](https://github.com/slim-template/slim/blob/4.1.0/benchmarks/run-benchmarks.rb) for fairness.
Recent benchmarks no longer show this difference in performance.

<img src="benchmark/graph.svg" alt="Hamlit Benchmark" />

```
ruby 4.0.0 (2025-12-25 revision 553f1675f3) +YJIT +PRISM [x86_64-linux]
Warming up --------------------------------------
       erubi v1.13.1    68.899k i/100ms
         slim v5.2.1    61.171k i/100ms
         haml v7.1.0    71.782k i/100ms
       hamlit v4.0.0    73.627k i/100ms
Calculating -------------------------------------
       erubi v1.13.1    707.031k (± 0.9%) i/s    (1.41 μs/i) -      3.583M in   5.067776s
         slim v5.2.1    615.437k (± 0.6%) i/s    (1.62 μs/i) -      3.120M in   5.069276s
         haml v7.1.0    730.772k (± 1.0%) i/s    (1.37 μs/i) -      3.661M in   5.010166s
       hamlit v4.0.0    741.546k (± 0.6%) i/s    (1.35 μs/i) -      3.755M in   5.063918s

Comparison:
       hamlit v4.0.0:   741546.2 i/s
         haml v7.1.0:   730771.6 i/s - same-ish: difference falls within error
       erubi v1.13.1:   707030.8 i/s - 1.05x  slower
         slim v5.2.1:   615436.7 i/s - 1.20x  slower
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
