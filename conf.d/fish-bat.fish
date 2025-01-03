function _fish_bat_install --on-event fish-bat_install
    # For Ubuntu and Debian-based `bat` packages
    # the `bat` program is named `batcat`
    if command -q batcat
        alias rcat="$(which cat)"
        alias cat="$(which batcat)"

        # Set manpager to use `bat`
        set -gx MANPAGER sh\ -c\ \'col\ -bx\ \|\ batcat\ -l\ map\ -p\'
        set -gx MANROFFOPT -c

    else if command -q bat # For all other systems
        alias rcat="$(which cat)"
        alias cat="$(which bat)"

        # Set manpager to use `bat`
        set -gx MANPAGER sh\ -c\ \'col\ -bx\ \|\ bat\ -l\ map\ -p\'
        set -gx MANROFFOPT -c

    else
        echo "bat is not installed but you're"
        echo "sourcing the fish plugin for it"
    end
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
