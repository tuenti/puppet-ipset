type IPSet::Options = Struct[{
    Optional[family]   => Enum['inet', 'inet6'],
    Optional[hashsize] => Integer[128],
    Optional[maxelem]  => Integer[128],
    Optional[netmask]  => IP::Address,
    Optional[timeout]  => Integer[1],
}]
