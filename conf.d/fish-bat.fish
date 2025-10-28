# For Ubuntu/Debian systems where `bat` is installed as `batcat`
if command -q batcat
    set bat_cmd $(which batcat)
else if command -q bat # For all other systems
    set bat_cmd $(which bat)
end

# Replace `cat` with `bat`
alias rcat="$(which cat)"
alias cat="$(which $bat_cmd)"

# Set manpager to use `bat`
set -gx MANPAGER "sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | '$bat_cmd' -p -lman'"
set -gx MANROFFOPT -c

# Colorize help messages
abbr -a --position anywhere -- --help '--help | '$bat_cmd' -plhelp'
abbr -a --position anywhere -- -h '-h | '$bat_cmd' -plhelp'

function _fish_bat_install --on-event fish-bat_install
    $bat_cmd cache --build
end

function _fish_bat_uninstall --on-event fish-bat_uninstall
    functions --erase rcat
    functions --erase cat

    set --erase MANPAGER
    set --erase MANROFFOPT
end

function _fish_bat_update --on-event fish-bat_update
    _fish_bat_uninstall
    _fish_bat_install
end
