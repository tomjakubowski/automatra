require 'sinatra/base'
require 'json'
require 'oily_png'
require './lib/automaton'

class Automatra < Sinatra::Base
  set :views, File.dirname(__FILE__)
  get '/' do
    markdown :'README'
  end

  get %r{/\b([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\b\.(txt|png|json)} do |rule, ext|
    initial, width, steps = params[:initial], params[:width], params[:steps]
    # set default / int cast width here because we need it for special
    # initial choices
    width ||= 128
    width = Integer(width)
    if initial == "random"
      initial = rand(2**width)
    elsif initial == "centered"
      initial = 2 ** (width/2)
    end
    initial ||= 1
    steps ||= width

    initial, steps = Integer(initial), Integer(steps)

    width = 512 if (width > 512)
    steps = 512 if (steps > 512)

    baz = Automaton.new(rule.to_i, initial, width)
    case ext
    when 'txt'
      content_type 'text/plain'
      stream do |out|
        steps.times do
          foo = baz.state
          foo.each { |n| out << (n == 0 ? ' ' : '#') }
          out << "\n"
          baz.next_state!
        end
      end
    when 'png'
      pixels = Array.new(steps) do
        state = baz.state
        baz.next_state!
        state.map{ |n| n * 255}
      end
      image = ChunkyPNG::Image.new(width, steps, pixels.flatten)
      content_type 'image/png'
      stream { |out| out << image.to_datastream }
    when 'json'
      content_type 'application/json'
      Array.new(steps) do 
        state = baz.state
        baz.next_state!
        state
      end.to_json
    end
  end
end