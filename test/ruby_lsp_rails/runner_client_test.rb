# typed: true
# frozen_string_literal: true

require "test_helper"
require "ruby_lsp/ruby_lsp_rails/runner_client"

module RubyLsp
  module Rails
    class RunnerClientTest < ActiveSupport::TestCase
      setup do
        @client = T.let(RunnerClient.new, RunnerClient)
      end

      teardown do
        @client.shutdown

        assert_predicate @client.instance_variable_get(:@stdin), :closed?
        assert_predicate @client.instance_variable_get(:@stdout), :closed?
        assert_predicate @client.instance_variable_get(:@stderr), :closed?
        refute_predicate @client.instance_variable_get(:@wait_thread), :alive?
      end

      test "model returns information for the requested model" do
        columns = [
          ["id", "integer"],
          ["first_name", "string"],
          ["last_name", "string"],
          ["age", "integer"],
          ["created_at", "datetime"],
          ["updated_at", "datetime"],
        ]
        response = T.must(@client.model("User"))
        assert_equal(columns, response.fetch(:columns))
        assert_match(%r{db/schema\.rb$}, response.fetch(:schema_file))
      end

      test "returns nil if model doesn't exist" do
        assert_nil @client.model("Foo")
      end

      test "returns nil if class is not a model" do
        assert_nil @client.model("Time")
      end

      test "returns nil if class is an abstract model" do
        assert_nil @client.model("ApplicationRecord")
      end
    end
  end
end
