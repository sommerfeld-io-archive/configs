# @file vars.rb
# @brief Library module which provides variables for test cases.
#
# @description This file provides variables and attributes to use within InSpec
# test scripts. It centralizes key information required for test execution to avoid
# repeating the same information in multiple test cases.


class Vars < Inspec.resource(1)
    name 'vars'
    desc 'Variables to use from test cases'

    attr_reader :default_user

    def initialize
        super
        @default_user = 'sebastian'
    end
end
