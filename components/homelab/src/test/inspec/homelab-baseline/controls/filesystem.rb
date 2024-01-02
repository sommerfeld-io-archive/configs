# @file filesystem.rb
# @brief Validate the basic filesystem layout.
#
# @description ...
# TODO ...

title 'audit files and folders'

control 'filesystem-01' do
    impact 1.0
    title 'Validate filesystem setup (files and folders)'
    desc 'Ensure all mandatory files and folders are created at their respective default location (ensure a common filesystem layout)'

    describe file("/home/#{vars.default_user}/.config") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/.config/autostart") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/work") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/work/repos") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/work/repos/sommerfeld-io") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/work/repos/sebastian-sommerfeld-io") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/tmp") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/#{vars.default_user}/.gitconfig") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end

    describe file('/opt/scripts') do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file('/opt/docker-wrappers') do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end
end
