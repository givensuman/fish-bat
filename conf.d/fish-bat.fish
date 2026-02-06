# Detect bat command (batcat on Debian/Ubuntu, bat elsewhere)
set -l cmd
if command -q batcat
    set cmd (command -v batcat)
else if command -q bat
    set cmd (command -v bat)
else
    echo "bat is not installed but you're"
    echo "sourcing the fish plugin for it"
    return 1
end

if test "$TERM" = dumb
    echo "you are sourcing the fish plugin for bat"
    echo "in a dumb terminal, which won't support it"
    return 1
end

if command -q cat
    alias rcat (command -v cat)
end
alias cat $cmd

# Configure bat as man page viewer with ANSI escape removal
set -gx MANPAGER "sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | '$cmd' -p -lman'"
set -gx MANROFFOPT -c

# Pipe help output through bat with syntax highlighting
abbr -a --position anywhere -- --help '--help | '$cmd' -plhelp'
abbr -a --position anywhere -- -h '-h | '$cmd' -plhelp'

function _fish_bat_install --on-event fish-bat_install
    set -l cmd
    if command -q batcat
        set cmd (command -v batcat)
    else if command -q bat
        set cmd (command -v bat)
    end

    $cmd cache --build
end

function _fish_bat_uninstall --on-event fish-bat_uninstall
    functions --erase rcat
    functions --erase cat
    set --erase cmd
    set --erase MANPAGER
    set --erase MANROFFOPT
    abbr --erase -- --help
    abbr --erase -- -h
end

function _fish_bat_update --on-event fish-bat_update
    _fish_bat_uninstall
    _fish_bat_install
end
