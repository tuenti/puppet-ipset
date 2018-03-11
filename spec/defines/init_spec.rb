require 'spec_helper'

describe 'ipset' do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystemmajrelease: '7',
    }
  end

  [
    [
      'array',
      ['10.0.0.1', '192.168.0.1'],
      {content: "10.0.0.1\n192.168.0.1"},
    ],
    [
      'string',
      "10.0.0.1\n192.168.0.1\n",
      {content: "10.0.0.1\n192.168.0.1\n"},
    ],
    [
      'puppet url',
      'puppet:///foo/bar',
      {source: 'puppet:///foo/bar'},
    ],
    [
      'file url',
      'file:///foo/bar',
      {source: '/foo/bar'},
    ],
  ].each do |test_name, set, attributes|
    context "set type #{test_name}" do
      let(:title) { 'simple' }
      let(:params) { { set: set } }

      it do
        is_expected.to contain_class('ipset::params')
        is_expected.to contain_class('ipset::install')
        is_expected.to contain_file('/etc/sysconfig/ipset.d/simple.hdr')
          .only_with(
            ensure: 'file',
            content: "create simple hash:ip family inet hashsize 1024 maxelem 65536\n",
            notify: 'Exec[sync_ipset_simple]',
          )
        is_expected.to contain_file('/etc/sysconfig/ipset.d/simple.set')
          .with({ensure: 'file'}.merge(attributes))
        is_expected.to contain_exec('sync_ipset_simple')
          .with(
            path: ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            command: "/usr/local/sbin/ipset_sync -c '/etc/sysconfig/ipset.d'    -i simple",
            unless: "/usr/local/sbin/ipset_sync -c '/etc/sysconfig/ipset.d' -d -i simple",
            require: 'Package[ipset]',
          )
          .that_subscribes_to('File[/etc/sysconfig/ipset.d/simple.set]')
      end
    end
  end

  context 'custom parameters' do
    let(:title) { 'custom' }
    let :params do
      {
        set: ['10.0.0.0/8', '192.168.0.0/16'],
        type: 'hash:net',
        options: {hashsize: 2048},
        ignore_contents: true,
      }
    end

    it do
      is_expected.to contain_class('ipset::params')
      is_expected.to contain_class('ipset::install')
      is_expected.to contain_file('/etc/sysconfig/ipset.d/custom.hdr')
        .only_with(
          ensure: 'file',
          content: "create custom hash:net family inet hashsize 2048 maxelem 65536\n",
          notify: 'Exec[sync_ipset_custom]',
        )
      is_expected.to contain_file('/etc/sysconfig/ipset.d/custom.set')
        .with(ensure: 'file', content: "10.0.0.0/8\n192.168.0.0/16")
      is_expected.to contain_exec('sync_ipset_custom')
        .with(
          path: ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          command: "/usr/local/sbin/ipset_sync -c '/etc/sysconfig/ipset.d'    -i custom -n",
          unless: "/usr/local/sbin/ipset_sync -c '/etc/sysconfig/ipset.d' -d -i custom -n",
          require: 'Package[ipset]',
        )
    end
  end

  context 'absent' do
    let(:title) { 'absent' }
    let :params do
      {
        ensure: 'absent',
        set: ['10.0.0.0/8', '192.168.0.0/16'],
      }
    end

    it do
      is_expected.to contain_file('/etc/sysconfig/ipset.d/absent.hdr')
        .with(ensure: 'absent')
      is_expected.to contain_file('/etc/sysconfig/ipset.d/absent.set')
        .with(ensure: 'absent')
      is_expected.to contain_exec('ipset destroy absent')
        .with(
          path: ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          command: '/usr/sbin/ipset destroy absent',
          onlyif: '/usr/sbin/ipset list -name absent &>/dev/null',
          require: 'Package[ipset]',
        )
    end
  end
end
