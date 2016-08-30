describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'does not escape content without interpolation' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
      HTML
        :plain
          <script>
      HAML
    end

    it 'does not escape interpolated content' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
        <script>

      HTML
        :plain
          <script>
          #{'<script>'}
      HAML
    end

    it 'escapes only interpolated content if esacpe_html is set' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
        &lt;script&gt;

      HTML
        :plain
          <script>
          #{Hamlit::Utils.escape_html '<script>'}
      HAML
    end
  end
end
