# typed: false
# frozen_string_literal: true

require "json"
running = true
while running
  # Read headers until line breaks
  headers = $stdin.gets("\r\n\r\n")

  # Read the response content based on the length received in the headers
  request = $stdin.read(headers[/Content-Length: (\d+)/i, 1].to_i)

  json = JSON.parse(request, symbolize_names: true)

  request_route = json.fetch(:route)
  params = json[:params]

  response_json = nil
  case request_route
  when "shutdown"
    response_json = { result: "ok", columns: User.column_names }.to_json

    running = false
  end

  $stdout.write("Content-Length: #{response_json.length}\r\n\r\n")
  $stdout.write(response_json)
end