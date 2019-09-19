#!/usr/bin/env bats

@test "check Network name resolution" {
    # Wait a limited amount of time for the name 'Network' to be registered
    COUNTER=30
    while [ $COUNTER -ne 0 ] ; do
        run grep -q ' Network$' /etc/hosts
        [ "$status" -ne 0 ] || break
        sleep 1
        COUNTER=$(( COUNTER - 1 ))
    done
    run grep -q ' Network$' /etc/hosts
    [ "$status" -eq 0 ]
}

@test "check sshargo to NDVM" {
    [ "$(sshargo -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no Network echo hello)" = "hello" ]
}

@test "verify MB/s of src and dst rates of sustained transfer over sshargo to NDVM" {
    rates=$({ sshargo -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no Network dd if=/dev/zero bs=1M count=50 | dd of=/dev/null bs=1M iflag=fullblock; } 2>&1 | sed -ne 's/^.*, \([^,]*\).[0-9] MB\/s/\1/p')
    [ "$(echo $rates|cut -f1 -d' ')" -gt 25 ]
    [ "$(echo $rates|cut -f2 -d' ')" -gt 25 ]
}
