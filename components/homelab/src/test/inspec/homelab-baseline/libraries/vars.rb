# @file vars.rb
# @brief Library module which provides some helper functions.
#
# @description ...
# TODO ...

class Vars < Inspec.resource(1)
    name 'vars'
    desc 'Variables to use from test cases'

    attr_reader :default_user

    def initialize
        super
        @default_user = 'sebastian'
    end
end
