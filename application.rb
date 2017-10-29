require 'sinatra'

Dir.glob('./{lib}/*.rb').each { |file| require file }

post '/compute' do
  @string = params[:string]
  @checksum = ComputeChecksum.call(string: params[:string])

  haml :'checksum/index'
end

get '/' do
  haml :'checksum/index'
end
