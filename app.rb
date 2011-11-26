require 'sinatra/base'

class Automatra < Sinatra::Base
  get '/' do
    'instructions:'
  end
  
  get %r{/([01][0-9][0-9]|2[0-4][0-9]|25[0-5])\.(png|json)} do |rule, ext|
    "rule #{rule}, ext #{ext}"
  end
end