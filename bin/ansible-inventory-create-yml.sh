#!/bin/bash

cat <<EOF >inventory_draft
all: #
    hosts:
        box-unprovisioned:
            ansible_user: root
            ansible_ssh_pass:
            ansible_host: x.y.z
        x.y.z:
            ansible_user: ubuntu
            ansible_host: x.y.z
    vars:
        group_all_var: value
    children:   # key order does not matter, indentation does
        base_box:
            hosts:
                # same host as above, additional group membership
                box-unprovisioned:
            vars:
                group_last_var: value

#        other_group:
#            children:
#                group_x:
#                    hosts:
#                        test5   # Note that one machine will work without a colon
                #group_x:
                #    hosts:
                #        test5  # But this won't
                #        test7  #
#                group_y:
#                    hosts:
#                        test6:  # So always use a colon
#            vars:
#                g2_var2: value3
#            hosts:
#                test4:
#                    ansible_host: 127.0.0.1
EOF
