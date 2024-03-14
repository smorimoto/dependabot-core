# typed: strong
# frozen_string_literal: true

require "dependabot/nuget/discovery/evaluation_details"
require "sorbet-runtime"

module Dependabot
  module Nuget
    class DependencyDetails
      extend T::Sig

      sig { params(json: T::Hash[String, T.untyped]).returns(DependencyDetails) }
      def self.from_json(json)
        name = T.let(json.fetch("Name"), String)
        version = T.let(json.fetch("Version"), String)
        type = T.let(json.fetch("Type"), String)
        evaluation = EvaluationDetails
                     .from_json(T.let(json.fetch("EvaluationResult"), T.nilable(T::Hash[String, T.untyped])))
        is_dev_dependency = T.let(json.fetch("IsDevDependency"), T::Boolean)
        is_direct = T.let(json.fetch("IsDirect"), T::Boolean)
        is_transitive = T.let(json.fetch("IsTransitive"), T::Boolean)
        is_override = T.let(json.fetch("IsOverride"), T::Boolean)
        is_update = T.let(json.fetch("IsUpdate"), T::Boolean)

        DependencyDetails.new(name: name,
                              version: version,
                              type: type,
                              evaluation: evaluation,
                              is_dev_dependency: is_dev_dependency,
                              is_direct: is_direct,
                              is_transitive: is_transitive,
                              is_override: is_override,
                              is_update: is_update)
      end

      sig do
        params(name: String,
               version: String,
               type: String,
               evaluation: T.nilable(EvaluationDetails),
               is_dev_dependency: T::Boolean,
               is_direct: T::Boolean,
               is_transitive: T::Boolean,
               is_override: T::Boolean,
               is_update: T::Boolean).void
      end
      def initialize(name:, version:, type:, evaluation:, is_dev_dependency:, is_direct:, is_transitive:,
                     is_override:, is_update:)
        @name = name
        @version = version
        @type = type
        @evaluation = evaluation
        @is_dev_dependency = is_dev_dependency
        @is_direct = is_direct
        @is_transitive = is_transitive
        @is_override = is_override
        @is_update = is_update
      end

      sig { returns(String) }
      attr_reader :name

      sig { returns(String) }
      attr_reader :version

      sig { returns(String) }
      attr_reader :type

      sig { returns(T.nilable(EvaluationDetails)) }
      attr_reader :evaluation

      sig { returns(T::Boolean) }
      attr_reader :is_dev_dependency

      sig { returns(T::Boolean) }
      attr_reader :is_direct

      sig { returns(T::Boolean) }
      attr_reader :is_transitive

      sig { returns(T::Boolean) }
      attr_reader :is_override

      sig { returns(T::Boolean) }
      attr_reader :is_update
    end
  end
end
