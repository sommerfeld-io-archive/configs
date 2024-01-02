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

    describe package('gh') do
        it { should be_installed }
    end

    describe package('rpi-imager') do
        it { should be_installed }
    end

    describe package('tilix') do
        it { should be_installed }
    end

    describe package('filezilla') do
        it { should be_installed }
    end

    describe package('gnome-tweaks') do
        it { should be_installed }
    end

    describe package('conky-all') do
        it { should be_installed }
    end

    describe package('rar') do
        it { should be_installed }
    end

    describe package('unrar') do
        it { should be_installed }
    end

    describe package('p7zip') do
        it { should be_installed }
    end

    describe package('nmap') do
        it { should be_installed }
    end

    describe file('/usr/bin/yarn') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
        it { should be_executable }
    end

    describe file('/snap/bin/code') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
        it { should be_executable }
    end

    describe file('/snap/bin/postman') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
        it { should be_executable }
    end

    describe package('hugo') do
        it { should be_installed }
    end

    describe package('asciidoctor') do
        it { should be_installed }
    end

    describe package('pre-commit') do
        it { should be_installed }
    end

    describe package('vagrant') do
        it { should be_installed }
    end

    describe package('virtualbox') do
        it { should be_installed }
    end
end

control 'packages-02' do
    impact 1.0
    title 'Validate media player package installations'

    describe package('vlc') do
        it { should be_installed }
    end

    describe package('vlc-plugin-access-extra') do
        it { should be_installed }
    end

    describe package('libbluray-bdj') do
        it { should be_installed }
    end

    describe package('libdvdcss2') do
        it { should be_installed }
    end

    describe package('vlc-plugin-fluidsynth') do
        it { should be_installed }
    end

    describe package('vlc-plugin-jack') do
        it { should be_installed }
    end

    describe package('ffmpeg') do
        it { should be_installed }
    end

    describe package('libavcodec-extra') do
        it { should be_installed }
    end

    describe package('ubuntu-restricted-extras') do
        it { should be_installed }
    end
end

control 'packages-03' do
    impact 1.0
    title 'Validate  audio CD ripper package installations'

    describe package('asunder') do
        it { should be_installed }
    end

    describe package('lame') do
        it { should be_installed }
    end

    describe package('vorbis-tools') do
        it { should be_installed }
    end

    describe package('flac') do
        it { should be_installed }
    end

    describe package('libopus0') do
        it { should be_installed }
    end

    describe package('wavpack') do
        it { should be_installed }
    end
end

control 'packages-04' do
    impact 1.0
    title 'Validate CD/DVD writer package installations'

    describe package('brasero') do
        it { should be_installed }
    end

    describe package('gstreamer1.0-plugins-ugly') do
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

control 'packages-05' do
    impact 1.0
    title 'Validate that certain packages are NOT installed'

    describe package('thunderbird') do
        it { should_not be_installed }
    end

    describe package('libreoffice') do
        it { should_not be_installed }
    end

    describe package('totem') do
        it { should_not be_installed }
    end
end
