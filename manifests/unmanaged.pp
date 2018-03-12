# Declare an IP set, without managing its content.
#
# Warning: when changing IP set attributes (type, options)
#          contents won't be kept, set will be recreated as empty
#
# @param ensure Should the IP set be created or removed ?
# @param type Type of IP set.
# @param options IP set options.
# @param keep_in_sync If ``true``, Puppet will update the IP set in the kernel
#   memory. If ``false``, it will only update the IP sets on the filesystem.
define ipset::unmanaged(
  Enum['present', 'absent'] $ensure = 'present',
  IPSet::Type $type = 'hash:ip',
  IPSet::Options $options = {},
  Boolean $keep_in_sync = true,
) {
  ipset { $title:
    ensure          => $ensure,
    set             => '',
    ignore_contents => true,
    type            => $type,
    options         => $options,
    keep_in_sync    => $keep_in_sync,
  }
}
