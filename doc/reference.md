# Reference

## Classes
* [`ipset::params`](#ipsetparams): Module parameters.
## Defined types
* [`ipset`](#ipset): Declare an IP Set.
* [`ipset::unmanaged`](#ipsetunmanaged): Declare an IP set, without managing its content.  Useful when you have a dynamic process that generates an IP set content, but still want to 
## Classes

### ipset::params

Module parameters.


#### Parameters

The following parameters are available in the `ipset::params` class.

##### `use_firewall_service`

Data type: `Optional[Enum['iptables', 'firewalld']]`

Define the firewall service used by the server.
Defaults to the Linux distribution default.

Default value: `undef`


## Defined types

### ipset

Declare an IP Set.

#### Examples
##### An IP set containing individual IP addresses, specified in the code.
```puppet
ipset { 'a-few-ip-addresses':
  set => ['10.0.0.1', '10.0.0.2', '10.0.0.42'],
}
```

##### An IP set containing IP networks, specified with Hiera.
```puppet
ipset { 'hiera-networks':
  set  => lookup('foo', IP::Address::V4::CIDR),
  type => 'hash:net',
}
```

##### An IP set of IP addresses, based on a file stored in a module.
```puppet
ipset { 'from-puppet-module':
  set => "puppet:///modules/${module_name}/ip-addresses",
}
```

##### An IP set of IP networks, based on a file stored on the filesystem.
```puppet
ipset { 'from-filesystem':
  set => 'file:///path/to/ip-addresses',
}
```


#### Parameters

The following parameters are available in the `ipset` defined type.

##### `set`

Data type: `IPSet::Set`

IP set content or source.

##### `ensure`

Data type: `Enum['present', 'absent']`

Should the IP set be created or removed ?

Default value: 'present'

##### `type`

Data type: `IPSet::Type`

Type of IP set.

Default value: 'hash:ip'

##### `options`

Data type: `IPSet::Options`

IP set options.

Default value: {}

##### `ignore_contents`

Data type: `Boolean`

If ``true``, only the IP set declaration will be
managed, but not its content.

Default value: `false`

##### `keep_in_sync`

Data type: `Boolean`

If ``true``, Puppet will update the IP set in the kernel
memory. If ``false``, it will only update the IP sets on the filesystem.

Default value: `true`


### ipset::unmanaged

Declare an IP set, without managing its content.

Useful when you have a dynamic process that generates an IP set content,
but still want to define and use it from Puppet.

<aside class="warning">
When changing IP set attributes (type, options) contents won't be kept,
set will be recreated as empty.
</aside>

#### Examples
##### 
```puppet
ipset::unmanaged { 'unmanaged-ipset-name': }
```


#### Parameters

The following parameters are available in the `ipset::unmanaged` defined type.

##### `ensure`

Data type: `Enum['present', 'absent']`

Should the IP set be created or removed ?

Default value: 'present'

##### `type`

Data type: `IPSet::Type`

Type of IP set.

Default value: 'hash:ip'

##### `options`

Data type: `IPSet::Options`

IP set options.

Default value: {}

##### `keep_in_sync`

Data type: `Boolean`

If ``true``, Puppet will update the IP set in the kernel
memory. If ``false``, it will only update the IP sets on the filesystem.

Default value: `true`


