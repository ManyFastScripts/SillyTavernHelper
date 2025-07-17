#!/usr/bin/bash
# MFS Powered
# Write by Cartethyia

STREPO="https://github.com/SillyTavern/SillyTavern.git"
STREPO_MIRROR="https://bgithub.xyz/SillyTavern/SillyTavern.git"

fatal() {
    echo -e "\033[1;31m[FATAL] ${1}\033[0m"
    exit 1
}

warn(){
    echo -e "\033[1;33m[WARN] ${1}\033[0m"
}

ST_installDeps() {
    for i in git nodejs curl; do
        if ! (command -v ${i} >/dev/null 2>&1); then
            echo "${i} is not installed. Now installing..."
            pkg i -y ${i}
        fi
    done
}

ST_install() {
    cd ${HOME}
    if ! (git clone ${STREPO} SillyTavern --branch=release --depth=1); then
        warn "Unable to clone from main repository."
        warn "Now trying the mirror repository."
        if ! (git clone ${STREPO_MIRROR} SillyTavern --branch=release --depth=1); then
            fatal "Unable to clone the source. Check your Internet connection first."
        fi
    fi
    cd ${HOME}/SillyTavern
    curl -LO https://raw.githubusercontent.com/ManyFastScripts/SillyTavernHelper/refs/heads/main/STH.sh
    chmod +x STH.sh
    echo "To start SillyTavern, use the command below:"
    echo ""
    echo 'cd ${HOME}/SillyTavern && ./STH.sh start'
}

ST_update() {
    git reset --hard
    git pull
}

ST_prepare() {
    npm config set registry https://registry.npmmirror.com # Always set to cn mirror
    npm install || fatal "Install npm first!"
}

ST_start() {
    ST_prepare
    npm run start
}

for i in ${*}; do
    case ${i} in
    install) ST_install ;;
    update) ST_update ;;
    prepare) ST_prepare ;;
    start) ST_start ;;
    esac
done
