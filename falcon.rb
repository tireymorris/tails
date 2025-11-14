load :rack, :self_signed_tls, :supervisor

hostname = File.basename(__dir__)
port = ENV.fetch('PORT', 9292).to_i

rack hostname do
  cache true
  endpoint Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}")
end
