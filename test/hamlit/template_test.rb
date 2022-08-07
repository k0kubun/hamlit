describe Hamlit::Template do
  # Simple imitation of Sinatra::Templates#compila_template
  def compile_template(engine, data, options = {})
    template = Tilt[engine]
    template.new(nil, 1, options) { data }
  end

  specify 'Tilt returns Hamlit::Template for haml engine' do
    assert_equal Hamlit::Template, Tilt[:haml]
  end

  it 'renders properly via tilt' do
    result = compile_template(:haml, %q|%p hello world|).render(Object.new, {})
    assert_equal %Q|<p>hello world</p>\n|, result
  end

  it 'has preserve method' do
    result = compile_template(:haml, %q|= preserve "hello\nworld"|).render(Object.new, {})
    assert_equal %Q|hello&amp;#x000A;world\n|, result
  end

  describe 'escape_attrs' do
    it 'escapes attrs by default' do
      result = compile_template(:haml, %q|%div{ data: '<script>' }|).render(Object.new, {})
      assert_equal %Q|<div data='&lt;script&gt;'></div>\n|, result
    end

    it 'can be configured not to escape attrs' do
      result = compile_template(:haml, %q|%div{ data: '<script>' }|, escape_attrs: false).render(Object.new, {})
      assert_equal %Q|<div data='<script>'></div>\n|, result
    end
  end

  describe 'escape_html' do
    it 'escapes html' do
      result = compile_template(:haml, %q|= '<script>' |).render(Object.new, {})
      assert_equal %Q|&lt;script&gt;\n|, result
    end

    it 'can be configured not to escape attrs' do
      result = compile_template(:haml, %q|= '<script>' |, escape_html: false).render(Object.new, {})
      assert_equal %Q|<script>\n|, result
    end
  end

  describe 'disable_capture' do
    it 'captures a block content' do
      object = Object.new
      def object.render(&block)
        block.call
      end
      result = compile_template(:haml, <<-'HAML'.unindent, escape_html: false, disable_capture: false).render(object, {})
        %h1 out
        = render do
          %h2 in
      HAML
      assert_equal <<-'HTML'.unindent, result
        <h1>out</h1>
        <h2>in</h2>
      HTML
    end
  end
end
