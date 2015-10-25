describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders css' do
      skip
      assert_render(<<-HAML, <<-HTML)
        :css
          .foo {
            width: 100px;
          }
      HAML
        <style>
          .foo {
            width: 100px;
          }
        </style>
      HTML
    end

    it 'parses string interpolation' do
      skip
      assert_render(<<-'HAML', <<-HTML)
        :css
          .foo {
            content: "#{'<&>'}";
          }
      HAML
        <style>
          .foo {
            content: "<&>";
          }
        </style>
      HTML
    end
  end
end