# @file basic.rb
# @brief Validate the basic system configuration.
#
# @description ...
# TODO ...

title 'check basic system configuration'

control 'basic-01' do
    impact 1.0
    title 'Check basic system configuration'
    desc 'Ensure tests are run against the correct machine and ensure basic configuration is correct'

    describe os.family do
        it { should cmp 'debian' }
    end

    describe timezone do
        its('identifier') { should cmp 'Europe/Berlin' }
    end
end
