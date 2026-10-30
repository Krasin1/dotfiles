#!/bin/sh
# ddcci 0.4.5 не собирается на новых ядрах: strncpy() убрали из ядра.
# Скрипт патчит исходники DKMS (strncpy -> strscpy) и пересобирает модуль.
#
# Запускать после обновления ядра/пакета ddcci:
#   ~/dotfiles/backlight/fix-dkms.sh

set -eu

die() { echo "error: $*" >&2; exit 1; }
as_root() { if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi; }

set -- /usr/src/ddcci-*/dkms.conf
[ -e "$1" ] || die "ddcci source not found in /usr/src"
conf=$1
src=${conf%/dkms.conf}

pkg=$(sed -n 's/^PACKAGE_NAME="\(.*\)"$/\1/p' "$conf")
ver=$(sed -n 's/^PACKAGE_VERSION="\(.*\)"$/\1/p' "$conf")
[ -n "$pkg" ] && [ -n "$ver" ] || die "cannot parse $conf"

patch_file=$(dirname "$0")/dkms-strscpy.patch
src_file=$src/ddcci/ddcci.c
[ -r "$patch_file" ] || die "patch not found: $patch_file"
[ -r "$src_file" ] || die "source not found: $src_file"

if grep -q 'strncpy(' "$src_file"; then
    echo "patching $src"
    as_root patch -p1 -d "$src" <"$patch_file"
else
    echo "$src is already patched"
fi

echo "building $pkg $ver"
as_root dkms build -m "$pkg" -v "$ver"
as_root dkms install -m "$pkg" -v "$ver"
as_root modprobe ddcci_backlight

printf 'backlight devices: '
ls /sys/class/backlight/ 2>/dev/null | tr '\n' ' '
echo
