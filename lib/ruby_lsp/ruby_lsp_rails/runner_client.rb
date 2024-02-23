# typed: strict
# frozen_string_literal: true

require "json"
require "open3"

module RubyLsp
  module Rails
    class RunnerClient
      class << self
        extend T::Sig

        sig { returns(RunnerClient) }
        def create_client
          new
        rescue Errno::ENOENT, StandardError => e # rubocop:disable Lint/ShadowedException
          warn("Ruby LSP Rails failed to initialize server: #{e.message}\n#{e.backtrace&.join("\n")}")
          warn("Server dependent features will not be available")
          NullClient.new
        end
      end

      class InitializationError < StandardError; end
      class IncompleteMessageError < StandardError; end

      extend T::Sig

      sig { void }
      def initialize
        # Spring needs a Process session ID. It uses this ID to "attach" itself to the parent process, so that when the
        # parent ends, the spring process ends as well. If this is not set, Spring will throw an error while trying to
        # set its own session ID
        begin
          Process.setsid
        rescue Errno::EPERM
          # If we can't set the session ID, continue
        end

        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client", mode: "a+")
        stdin, stdout, stderr, wait_thread = Open3.popen3(
          "bin/rails",
          "runner",
          "#{__dir__}/server.rb",
          "start",
        )
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client1", mode: "a+")
        @stdin = T.let(stdin, IO)
        @stdout = T.let(stdout, IO)
        @stderr = T.let(stderr, IO)
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client2", mode: "a+")
        @wait_thread = T.let(wait_thread, Process::Waiter)
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client3", mode: "a+")
        @stdin.binmode # for Windows compatibility
        @stdout.binmode # for Windows compatibility

        warn("Ruby LSP Rails booting server")
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client4", mode: "a+")
        read_response
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***starting client5", mode: "a+")
        warn("Finished booting Ruby LSP Rails server")
      rescue Errno::EPIPE, IncompleteMessageError
        raise InitializationError, @stderr.read
      end

      sig { params(name: String).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
      def model(name)
        make_request("model", name: name)
      rescue IncompleteMessageError
        warn("Ruby LSP Rails failed to get model information: #{@stderr.read}")
        nil
      end

      sig { void }
      def shutdown
        send_notification("shutdown")
        Thread.pass while @wait_thread.alive?
        [@stdin, @stdout, @stderr].each(&:close)
      end

      sig { returns(T::Boolean) }
      def stopped?
        [@stdin, @stdout, @stderr].all?(&:closed?) && !@wait_thread.alive?
      end

      private

      sig do
        params(
          request: String,
          params: T.nilable(T::Hash[Symbol, T.untyped]),
        ).returns(T.nilable(T::Hash[Symbol, T.untyped]))
      end
      def make_request(request, params = nil)
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***making request from client", mode: "a+")
        send_message(request, params)
        read_response
      end

      sig { params(request: String, params: T.nilable(T::Hash[Symbol, T.untyped])).void }
      def send_message(request, params = nil)
        message = { method: request }
        message[:params] = params if params
        json = message.to_json

        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***sending: #{json}", mode: "a+")
        @stdin.write("Content-Length: #{json.length}\r\n\r\n", json)
      end

      alias_method :send_notification, :send_message

      sig { returns(T.nilable(T::Hash[Symbol, T.untyped])) }
      def read_response
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***reading response", mode: "a+")

        headers = @stdout.gets("\r\n\r\n")
        unless headers
          File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "no headers so raising", mode: "a+")
        end
        raise IncompleteMessageError unless headers

        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "***after raise", mode: "a+")

        raw_response = @stdout.read(headers[/Content-Length: (\d+)/i, 1].to_i)
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "got response: #{raw_response}", mode: "a+")
        response = JSON.parse(T.must(raw_response), symbolize_names: true)

        if response[:error]
          warn("Ruby LSP Rails error: " + response[:error])
          return
        end

        r = response.fetch(:result)
        File.write("/home/spin/src/github.com/Shopify/shopify/client.txt", "result: #{r}", mode: "a+")
        r
      end
    end

    class NullClient < RunnerClient
      extend T::Sig

      sig { void }
      def initialize # rubocop:disable Lint/MissingSuper
      end

      sig { override.void }
      def shutdown
        # no-op
      end

      sig { override.returns(T::Boolean) }
      def stopped?
        true
      end

      private

      sig { override.params(request: String, params: T.nilable(T::Hash[Symbol, T.untyped])).void }
      def send_message(request, params = nil)
        # no-op
      end

      sig { override.returns(T.nilable(T::Hash[Symbol, T.untyped])) }
      def read_response
        # no-op
      end
    end
  end
end
