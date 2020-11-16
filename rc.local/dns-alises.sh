# functions for swapping out resolv.conf
#
# Usage: resolv [show|list|help|NAME]
#
# NOTES
#   This is Linux specific and uses chattr to keep systemd
#   from overrwriting the resolv.conf file we want
#

SOURCE_DIR="${HOME}/etc"

function resolv() {

    conf=${1:-"help"}

    if [ "$conf" == "help" ]; then

       cat <<EOF >/dev/stderr
Usage: resolv [show|list|help|NAME]

Examples:
  resolv quad9 # switch to quad9 resolv.conf
  resolv show  # show the current /etc/resolv.conf
  resolv list  # list avalable $HOME/etc/resolv.conf.NAME options


FILES:
  This assumes that there are files in $HOME/etc/resolv.conf.NAME
  such as

    /etc/resolv.conf.quad9
    /etc/resolv.conf.google
    /etc/resolv.conf.homenet

  which will be copied to /etc/resolv.conf
EOF
       return 0
    fi

    if [ "${conf}" == "show" ]; then
       echo cat /etc/resolv.conf >/dev/stderr
       cat /etc/resolv.conf
       return 0
    fi

    if [ "${conf}" == "list" ]; then
       ls -1 ${SOURCE_DIR}/resolv.conf.*
       return 0
    fi

    COPY_THIS="${SOURCE_DIR}/resolv.conf.$conf" 
       
    if [ ! -f ${COPY_THIS} ]; then
        echo "${COPY_THIS} does not exit" >/dev/stderr
        return 1
    fi
    
    sudo chattr -i /etc/resolv.conf
    sudo cp "${COPY_THIS}" /etc/resolv.conf
    sudo chattr +i /etc/resolv.conf # tell systemd to take a hike
    echo copied "${COPY_THIS}" /etc/resolv.conf to /etc/resolv >/dev/stderr
    return 0
}

