describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders sass filter' do
      skip
      assert_render(<<-HAML, <<-HTML)
        :sass
          .users_controller
            .show_action
              margin: 10px
              padding: 20px
      HAML
        <style>
          .users_controller .show_action {
            margin: 10px;
            padding: 20px; }
        </style>
      HTML
    end

    it 'renders sass filter with string interpolation' do
      skip
      assert_render(<<-'HAML', <<-HTML)
        :sass
          .users_controller
            .show_action
              content: "#{'<&>'}"
      HAML
        <style>
          .users_controller .show_action {
            content: "<&>"; }
        </style>
      HTML
    end
  end
end