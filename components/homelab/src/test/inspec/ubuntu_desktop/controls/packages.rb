# @file packages.rb
# @brief Validate software packages.
#
# @description ...
# TODO ...

title 'audit software packages'

control 'packages-01' do
    impact 1.0
    title 'Validate basic package installations'

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

control 'packages-02' do
    impact 1.0
    title 'Validate tool package installations'

    describe package('make') do
        it { should be_installed }
    end

    describe package('ncdu') do
        it { should be_installed }
    end

    describe package('htop') do
        it { should be_installed }
    end

    describe package('git') do
        it { should be_installed }
    end

    describe package('neofetch') do
        it { should be_installed }
    end

    describe package('python3') do
        it { should be_installed }
    end

    describe package('python3-pip') do
        it { should be_installed }
    end
end

control 'docker-packages-01' do
    impact 1.0
    title 'Validate software package installations'

    describe package('docker-ce') do
        it { should be_installed }
    end

    describe package('docker-ce-cli') do
        it { should be_installed }
    end

    describe package('containerd.io') do
        it { should be_installed }
    end

    describe package('docker-buildx-plugin') do
        it { should be_installed }
    end

    describe package('docker-compose-plugin') do
        it { should be_installed }
    end
end

control 'no-deprecated-docker-packages-01' do
    impact 1.0
    title 'Validate that no deprecated docker packages are installed'

    describe package('docker-compose') do
        it { should_not be_installed }
    end

    describe package('docker') do
        it { should_not be_installed }
    end

    describe package('docker-engine') do
        it { should_not be_installed }
    end

    describe package('docker.io') do
        it { should_not be_installed }
    end

    describe package('containerd') do
        it { should_not be_installed }
    end

    describe package('runc') do
        it { should_not be_installed }
    end
end
