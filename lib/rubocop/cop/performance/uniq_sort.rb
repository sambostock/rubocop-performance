# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @safety
      #   Delete this section if the cop is not unsafe (`Safe: false` or
      #   `SafeAutoCorrect: false`), or use it to explain how the cop is
      #   unsafe.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class UniqSort < Base
        extend AutoCorrector
        include RangeHelp

        MSG = 'Use `.%<correct_first>s.%<correct_second>s` instead of `.%<first>s.%<second>s`.'

        RESTRICT_ON_SEND = %i[sort sort! uniq uniq!].freeze

        # @!method inverted?(node)
        def_node_matcher :inverted?, <<~PATTERN
          (send $(send _ ${:sort :sort!}) ${:uniq :uniq!})
        PATTERN

        def on_send(node)
          inverted?(node) do |nested_node, first, second|
            # TODO: Need to preserve bang semantics (e.g. .a.b => .b.a, .a.b! => .b.a!, .a!.b! => .b!.a!)

            message = format(MSG, first: first, second: second, correct_first: second, correct_second: first)
            range = range_between(nested_node.loc.dot.begin_pos, node.loc.selector.end_pos)
            add_offense(range, message: message) do |corrector|
              corrector.replace(range, ".#{first}.#{second}")
            end
          end
        end
      end
    end
  end
end
