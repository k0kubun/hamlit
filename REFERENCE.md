# Hamlit

Basically Hamlit is the same as Haml.
See [Haml's tutorial](http://haml.info/tutorial.html) if you are not familiar with Haml's syntax.

[REFERENCE - Haml Documentation](http://haml.info/docs/yardoc/file.REFERENCE.html)

## Hamlit's characteristics

### Limited attributes hyphenation
In Haml, `%a{ foo: { bar: 'baz' } }` is rendered as `<a foo-bar='baz'></a>`, whatever foo is.
In Hamlit, this feature is supported only for aria and data attribute. Hamlit renders `%a{ data: { foo: 'bar' } }`
as `<a data-foo='bar'></a>` because it's data attribute. This design allows us to reduce work on runtime
and the idea is originally in [Faml](https://github.com/eagletmt/faml).

### Limited boolean attributes
In Haml, `%a{ foo: false }` is rendered as `<a></a>`, whatever `foo` is.
In Hamlit, this feature is supported for only boolean attributes, which are defined by
http://www.w3.org/TR/xhtml1/guidelines.html or https://html.spec.whatwg.org/.
The list is the same as `ActionView::Helpers::TagHelper::BOOLEAN_ATTRIBUTES`.
In addition, aria-\* and data-\* is also regarded as boolean.

Since `foo` is not boolean attribute, `%a{ foo: false }` is rendered as `<a foo='false'></a>`
This is the same behavior as Rails helpers. Also for `%a{ foo: nil }`,
Hamlit does not remove non-boolean attributes and render `<a foo=''></a>`
(`foo` is not removed). This design allows us to reduce string concatenation and
is the only difference between Faml and Hamlit.

You may be also interested in
[hamlit/hamlit-boolean\_attributes](https://github.com/hamlit/hamlit-boolean_attributes).

## 5 Types of Attributes

Haml has 3 types of attributes: id, class and others.
In addition, Hamlit treats aria/data and boolean attributes specially.
So there are 5 types of attributes in Hamlit.

### id attribute
Almost the same behavior as Haml, except no hyphenation and boolean support.
Arrays are flattened, falsey values are removed (but attribute itself is not removed)
and merging multiple ids results in concatenation by "\_".

```rb
# Input
#foo{ id: 'bar' }
%div{ id: %w[foo bar] }
%div{ id: ['foo', false, ['bar', nil]] }
%div{ id: false }

# Output
<div id='foo_bar'></div>
<div id='foo_bar'></div>
<div id='foo_bar'></div>
<div id=''></div>
```

### class attribute
Almost the same behavior as Haml, except no hyphenation and boolean support.
Arrays are flattened, falsey values are removed (but attribute itself is not removed)
and merging multiple classes results in unique alphabetical sort.

```rb
# Input
.d.a(class='b c'){ class: 'c a' }
%div{ class: 'd c b a' }
%div{ class: ['d', nil, 'c', [false, 'b', 'a']] }
%div{ class: false }

# Output
<div class='a b c d'></div>
<div class='d c b a'></div>
<div class='d c b a'></div>
<div class=''></div>
```

### aria / data attribute
Completely compatible with Haml, hyphenation and boolean are supported.

```rb
# Input
%div{ data: { disabled: true } }
%div{ data: { foo: 'bar' } }

# Output
<div data-disabled></div>
<div data-foo='bar'></div>
```

aria attribute works in the same way as data attribute.

### boolean attributes
No hyphenation but complete boolean support.

```rb
# Input
%div{ disabled: 'foo' }
%div{ disabled: true }
%div{ disabled: false }

# Output
<div disabled='foo'></div>
<div disabled></div>
<div></div>
```

List of boolean attributes is:

```
disabled readonly multiple checked autobuffer autoplay controls loop selected hidden scoped async
defer reversed ismap seamless muted required autofocus novalidate formnovalidate open pubdate
itemscope allowfullscreen default inert sortable truespeed typemustmatch
```

If you want to customize the list of boolean attributes, you can use
[hamlit/hamlit-boolean\_attributes](https://github.com/hamlit/hamlit-boolean_attributes).

"aria-\*" and "data-\*" are also regarded as boolean.

### other attributes
No hyphenation and boolean support. `false` is rendered as "false" (like Rails helpers).

```rb
# Input
%input{ value: true }
%input{ value: false }

# Output
<input value='true'>
<input value='false'>
```

## Engine options

| Option | Default | Feature |
|:-------|:--------|:--------|
| escape\_html | true | HTML-escape for Ruby script and interpolation. This is false in Haml. |
| escape\_attrs | true | HTML-escape for Html attributes. |
| format | :html | You can set :xhtml to change boolean attribute's format. |
| attr\_quote | `'` | You can change attribute's wrapper to `"` or something. |

### Set options for Rails

```rb
# config/initializers/hamlit.rb or somewhere
Hamlit::RailsTemplate.set_options attr_quote: '"'
```

### Set options for Sinatra

```rb
set :haml, { attr_quote: '"' }
```

## Ruby module

`Hamlit::Template` is a module registered to `Tilt`. You can use it like:

```rb
Hamlit::Template.new { "%strong Yay for HAML!" }.render
```

## Creating a custom filter

Currently it doesn't have filter registering interface compatible with Haml.
But you can easily define and register a filter using Tilt like this.

```rb
module Hamlit
  class Filters
    class Es6 < TiltBase
      def compile(node)
        # branch with `@format` here if you want
        compile_html(node)
      end

      private

      def compile_html(node)
        temple = [:multi]
        temple << [:static, "<script>\n"]
        temple << compile_with_tilt(node, 'es6', indent_width: 2)
        temple << [:static, "\n</script>"]
        temple
      end
    end

    register :es6, Es6
  end
end
```

After requiring the script, you can do:

```haml
:es6
  const a = 1;
```

and it's rendered as:

```html
<script>
  "use strict";

  var a = 1;
</script>
```
