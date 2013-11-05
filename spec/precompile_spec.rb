require 'spec_helper'
require 'sprockets'

describe "sprockets integration" do
  before do
    @sprockets = Sprockets::Environment.new
    app_path = Pathname(__FILE__).join('../app')
    @sprockets.append_path app_path.join('assets/javascripts')
    @sprockets.append_path app_path.join('views')
    @sprockets.register_engine '.hbs', Handlebars::Tilt
    @context = Handlebars::TemplateHandler.handlebars
    source =  <<-JS
    (function(Handlebars) {
      //BEGIN SPROCKETS OUTPUT
      #{@sprockets['templates.js'].source}
      //END SPROCKETS OUTPUT
    })
    JS
    @context.runtime.eval(source).call(@context.handlebars)
  end
  it 'precompiles templates' do
    @context.handlebars.templates['foobars/whole'].call('thing' => 'enchilada').should match 'whole enchilada'
  end
  it 'precompiles partials' do
    @context.compile('{{>foobars/partial}}').call(:thing => 'enchilada').should match 'partial enchilada'
    @context.handlebars.partials['foobars/partial'].call(:thing => 'enchilada').should match 'partial enchilada'
  end
end

def h(*args)
  ERB::Util.h args.join(', ')
end
