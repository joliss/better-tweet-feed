if defined? Hamlbars
  Hamlbars::Template.render_templates_for :ember

  module Haml
    module Helpers
      %w(with if_ else_ unless_ each collection view outlet debugger).each do |method|
        class_eval <<-eof
          def #{method}(expression='', options={}, &block)
            hb "#{method.chomp('_')} \#{expression}", options, &block
          end
        eof
      end
    end
  end
end
