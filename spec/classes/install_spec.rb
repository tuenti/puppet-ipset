require 'spec_helper'

def shared_checks
  it do
    is_expected.to contain_class('ipset::params')
    is_expected.to contain_package('ipset').only_with(
      ensure: 'latest',
      alias: 'ipset',
    )
    is_expected.to contain_file('/etc/sysconfig/ipset.d')
      .only_with(ensure: 'directory')
    ['init', 'sync'].each do |script|
      is_expected.to contain_ipset__install__helper_script("ipset_#{script}")
      is_expected.to contain_file("/usr/local/sbin/ipset_#{script}").only_with(
        ensure: 'file',
        owner: 'root',
        group: 'root',
        mode: '0754',
        source: "puppet:///modules/ipset/ipset_#{script}"
      )
    end
  end
end

describe 'ipset::install' do
  context 'RedHat 6' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemmajrelease: '6',
      }
    end

    ipset_conf_content = <<EOF
task

exec /usr/local/sbin/ipset_init -c "/etc/sysconfig/ipset.d"

# run before all sysv-init scripts, where the firewall (iptables) is
start on starting rc RUNLEVEL=[2345]
EOF

    shared_checks

    it do
      is_expected.to contain_package('libmnl').only_with(
        ensure: 'installed',
        before: 'Package[ipset]',
      )
      is_expected.to contain_exec('ipset_disable_distro').with(
        command: "/bin/bash -c '/etc/init.d/ipset stop && /sbin/chkconfig ipset off'",
        unless: "/bin/bash -c '/sbin/chkconfig | /bin/grep ipset | /bin/grep -qv :on'",
        require: 'Package[ipset]',
      )
      is_expected.to contain_file('/etc/init/ipset.conf').with(
        ensure: 'file',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: ipset_conf_content,
      ).that_requires('Exec[ipset_disable_distro]')
      is_expected.to contain_service('ipset_enable_upstart').only_with(
        name: 'ipset',
        enable: true,
        provider: 'upstart',
      ).that_subscribes_to('File[/etc/init/ipset.conf]')
    end
  end

  ['iptables', 'firewalld'].each do |firewall_service|
    context "RedHat 7 - #{firewall_service}" do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemmajrelease: '7',
        }
      end
      let(:pre_condition) do
        <<-EOS
          class { '::ipset::params':
            use_firewall_service => '#{firewall_service}',
          }
        EOS
      end

      ipset_service_content = <<EOF
[Unit]
Description=define and fill-in ipsets
Documentation=https://github.com/mighq/puppet-ipset
Before=#{firewall_service}.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/sbin/ipset_init -c "/etc/sysconfig/ipset.d"

[Install]
WantedBy=basic.target
EOF

      shared_checks

      it do
        is_expected.to contain_file('/usr/lib/systemd/system/ipset.service').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0644',
          content: ipset_service_content,
        )
        is_expected.to contain_service('ipset').only_with(
          ensure: 'running',
          enable: true,
          require: 'Ipset::Install::Helper_script[ipset_init]',
        ).that_subscribes_to('File[/usr/lib/systemd/system/ipset.service]')
      end
    end
  end
end
