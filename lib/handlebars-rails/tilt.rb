require 'tilt'
require 'barber'

module Handlebars
  class Tilt < ::Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def prepare

    end

    def evaluate(scope, locals, &block)
      source = Barber::InlinePrecompiler.call data
      is_partial = File.basename(scope.logical_path).start_with?('_')
      template_name = scope.logical_path.sub(%r~^templates/~, "")
      template_name.gsub!(%r~/_~, '/') if is_partial
      target = is_partial ?  "partials" : "templates"      
      "if (!Handlebars.templates) Handlebars.templates = {};Handlebars.#{target}['#{template_name}']=#{source}"
    end
  end
end
