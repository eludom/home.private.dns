# functions for swapping out resolv.conf 

function resolv() {

    conf=${1:-"NONE"}

    if [ ! -f ${conf} ]; then
        warn "$conf does not exit"
        return
    fi
    
    sudo chattr -i /etc/resolv.conf
    sudo cp "${conf}" /etc/resolv.conf
    sudo chattr +i /etc/resolv.conf # tell systemd to take a hike
}

alias resolv-ed="resolv ${HOME}/etc/resolv.conf.ed /etc/resolv.conf"
alias resolv-rhubarb="resolv ${HOME}/etc/resolv.conf.rhubarb /etc/resolv.conf"
alias resolv-quad9="resolv ${HOME}/etc/resolv.conf.quad9 /etc/resolv.conf"
