# @file packages.rb
# @brief Validate software packages.
#
# @description ...
# TODO ...

title 'audit software packages'

control 'required-system-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('apt-transport-https') do
        it { should be_installed }
    end

    describe package('ca-certificates') do
        it { should be_installed }
    end

    describe package('curl') do
        it { should be_installed }
    end

    describe package('software-properties-common') do
        it { should be_installed }
    end
end

control 'tools-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('ncdu') do
        it { should be_installed }
    end

    describe package('htop') do
        it { should be_installed }
    end

    describe package('git') do
        it { should be_installed }
    end
end

control 'docker-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('docker-ce') do
        it { should be_installed }
    end

    describe package('docker-ce-cli') do
        it { should be_installed }
    end
end
