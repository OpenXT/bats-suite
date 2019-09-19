#!/usr/bin/env bats

@test "check SELinux enforcing" {
    [ "$(getenforce)" = "Enforcing" ]
}

@test "check XSM enforcing" {
    [ "$(xl getenforce)" = "Enforcing" ]
}

@test "no kernel classes/permissions left undefined in the SELinux policy" {
    count=$(grep SELinux.*not defined /var/log/messages|wc -l)

    [ "${count}" -eq 0 ]
}

@test "no avc messages in /var/log/messages" {
    count=$(grep avc:.*denied /var/log/messages|wc -l)

    [ "${count}" -eq 0 ]
}

@test "check NDVM flask label" {
    run xec-vm -n Network -g flask-label

    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "system_u:system_r:ndvm_t" ]
}

@test "check UIVM flask label" {
    run xec-vm -n uivm -g flask-label

    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "system_u:system_r:uivm_t" ]
}

@test "check SyncVM flask label" {
    run xec-vm -n syncvm -g flask-label

    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "system_u:system_r:syncvm_t" ]
}

@test "check xenmgr SELinux label" {
    run ps -o label -C xenmgr

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:xend_t:s0-s0:c0.c1023" ]
}

@test "check dbd SELinux label" {
    run ps -o label -C dbd

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:dbd_t:s0" ]
}

@test "check xenstored SELinux label" {
    run ps -o label -C xenstored

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:xenstored_t:s0" ]
}

@test "check uid SELinux label" {
    run ps -o label -C uid

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:uid_t:s0" ]
}

@test "check xcpmd SELinux label" {
    run ps -o label -C xcpmd

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:xenpmd_t:s0" ]
}

@test "check input_server SELinux label" {
    run ps -o label -C input_server

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:input_server_t:s0" ]
}

@test "check rpc-proxy SELinux label" {
    run ps -o label -C rpc-proxy

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:rpcproxy_t:s0" ]
    [ "${lines[2]}" = "system_u:system_r:rpcproxy_guest_t:s0" ]
    [ "${lines[3]}" = "system_u:system_r:rpcproxy_websockets_t:s0" ]
}

@test "check vusb-daemon SELinux label" {
    run ps -o label -C vusb-daemon

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:vusbd_t:s0" ]
}

@test "check network-daemon SELinux label" {
    run ps -o label -C network-daemon

    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "system_u:system_r:network_daemon_t:s0" ]
}
