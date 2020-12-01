# frozen_string_literal: true

require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*\.rb'
  t.warning = false
end
