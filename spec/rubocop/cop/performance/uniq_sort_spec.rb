# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::UniqSort, :config do
  it 'registers an offense when using `.sort.uniq`' do
    expect_offense(<<~RUBY)
      [].sort.uniq
        ^^^^^^^^^^ Use `.uniq.sort` instead of `.sort.uniq`.
    RUBY

    expect_correction(<<~RUBY)
      [].uniq.sort
    RUBY
  end

  it 'does not register an offense when using `.uniq.sort`' do
    expect_no_offenses(<<~RUBY)
      [].uniq.sort
    RUBY
  end

  it 'registers an offense when using `.sort.uniq!`' do
    expect_offense(<<~RUBY)
      [].sort.uniq!
        ^^^^^^^^^^^ Use `.uniq.sort!` instead of `.sort.uniq!`.
    RUBY

    expect_correction(<<~RUBY)
      [].uniq.sort!
    RUBY
  end

  it 'does not register an offense when using `.uniq.sort!`' do
    expect_no_offenses(<<~RUBY)
      [].uniq.sort!
    RUBY
  end

  # NOTE: Is it even safe to switch the ! version? What if they're relying on the nil return value?
  # TODO: Double bang? .sort!.uniq! vs .uniq!.sort!
  # TODO: Check return values of bang methods (e.g. does .sort! return nil if already sorted?)
  # TODO: Block versions of .sort.uniq and .uniq.sort (1 or both have key fn blocks passed)
  # TODO: Intermediate variable? (e.g. x = [].sort; x.uniq! => x.uniq.sort!)
  # TODO: Tap? (e.g. [].sort.tap(&:uniq!) => [].uniq.sort!)
end
