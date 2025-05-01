#!/usr/bin/env fish

set -l plugin_dir (dirname (dirname (status filename)))
source $plugin_dir/conf.d/fish-bat.fish

# Test 1: Check if bat/batcat is installed (required for plugin)
if not command -q bat; and not command -q batcat
    echo "❌ bat/batcat is not installed"
    exit 1
end

# Test 2: Test alias creation for cat and rcat
if command -q batcat
    set -l expected_cat (which batcat)
else
    set -l expected_cat (which bat)
end

functions -q cat
and echo "✅ cat alias created"
or begin
    echo "❌ cat alias not created"
    exit 1
end

functions -q rcat
and echo "✅ rcat alias created"
or begin
    echo "❌ rcat alias not created"
    exit 1
end

# Test 3: Test man page configuration
test -n "$MANPAGER"
and echo "✅ MANPAGER is set"
or begin
    echo "❌ MANPAGER is not set"
    exit 1
end

test -n "$MANROFFOPT"
and echo "✅ MANROFFOPT is set"
or begin
    echo "❌ MANROFFOPT is not set"
    exit 1
end

# Test 4: Test uninstall function
_fish_bat_uninstall

functions -q cat
and begin
    echo "❌ cat alias was not removed"
    exit 1
end
or echo "✅ cat alias removed"

functions -q rcat
and begin
    echo "❌ rcat alias was not removed"
    exit 1
end
or echo "✅ rcat alias removed"

test -n "$MANPAGER"
and begin
    echo "❌ MANPAGER was not unset"
    exit 1
end
or echo "✅ MANPAGER unset"

test -n "$MANROFFOPT"
and begin
    echo "❌ MANROFFOPT was not unset"
    exit 1
end
or echo "✅ MANROFFOPT unset"

echo "✅ All basic tests passed"