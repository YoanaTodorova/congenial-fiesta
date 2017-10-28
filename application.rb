require 'sinatra'

get '/' do
  @checksum = ComputeChecksum.call(string: params[:string])
end
