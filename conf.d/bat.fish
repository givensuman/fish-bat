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
