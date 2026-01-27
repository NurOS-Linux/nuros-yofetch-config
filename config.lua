-- NurOS YoFetch Configuration
-- Official configuration for NurOS - the FRESH operating system

local yo = require("Yofetch")

-- Color scheme
local reset = "{style.reset}"
local accent = "{style.bold}{color.blue}"
local bright = "{color.bright_blue}"
local sep = reset .. " {color.cyan}▸{style.reset} "

-- Helper function for info lines
local function info_line(label, value)
    return accent .. label .. sep .. reset .. value
end

-- Helper function for slogan
local function slogan()
    -- Use ANSI escape codes directly for gray color
    local gray = "\27[90m" -- Bright black (gray)
    local reset_ansi = "\27[0m"
    return "   " .. gray .. "Shine brighter than the rest by thinking different" .. reset_ansi
end

-- Layout configuration
yo.padding(3, 0, 1) -- Right, Left, Top
yo.mode("default")  -- Horizontal layout
yo.shell({ "/bin/bash", "-c" })

-- NurOS Logo with blue gradient
yo.logo([[
{color.blue}         ___╓╓___
{color.blue}    _▄▄▓▓▀▀╜╜╨▀▓▓▓╗_
{color.blue}  ╓▓▓▀²          `╙▓▓╖
{color.blue} ╣▓▀   _▄▓▓▓▓▓▓W_   ╙▓▓
{color.blue}╣▓╜  ,▓▓▓▓▓▓▓▓▓▓▓▓_  ²▓▓
{color.blue}╒▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ║▓m
{color.blue}╞▓▓  í▓▓▓▓▓▓▓▓▓▓▓▓▓▓h  ╞▓╡
{color.blue}²▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ║▓h
{color.blue} ║▓▄   ╙▓▓▓▓▓▓▓▓▓▓╜   ƒ▓▓
{color.blue}  ╙▓▓_   ⁿ╙╨╝╝╝╜²   _╢▓╜
{color.blue}   ╙▓▓╗__       _╗▓▓╜
{color.blue}     `╙╝▓▓▓▓▓▓▓▓╝╙
]])

-- Get system information
local kernel = yo.exec("uname -r")
local uptime = yo.exec("uptime -p | sed 's/up //'")

-- Smart package detection
local function get_package_count()
    -- Try tulpar first (NurOS native)
    local tulpar_count = yo.exec("command -v tulpar >/dev/null 2>&1 && tulpar list --count 2>/dev/null || echo ''")
    if tulpar_count ~= "" and tonumber(tulpar_count) and tonumber(tulpar_count) > 0 then
        return tulpar_count .. " (tulpar)"
    end

    -- Fallback to other package managers
    local managers = {
        { "pacman -Qq 2>/dev/null | wc -l",           "pacman" },
        { "dpkg -l 2>/dev/null | grep '^ii' | wc -l", "apt" },
        { "rpm -qa 2>/dev/null | wc -l",              "dnf" },
        { "nix-env -q 2>/dev/null | wc -l",           "nix" },
        { "flatpak list 2>/dev/null | wc -l",         "flatpak" }
    }

    for _, manager in ipairs(managers) do
        local count = yo.exec(manager[1])
        local num = tonumber(count)
        if num and num > 0 then
            return count .. " (" .. manager[2] .. ")"
        end
    end

    return "unknown"
end

local packages = get_package_count()

-- Shell detection
local shell = yo.exec("basename $SHELL")

-- Desktop Environment detection
local function get_de()
    local de = yo.exec("echo $XDG_CURRENT_DESKTOP")
    if de == "" then
        de = yo.exec("echo $DESKTOP_SESSION")
    end
    if de == "" then
        -- Try to detect WM
        de = yo.exec("wmctrl -m 2>/dev/null | grep 'Name:' | cut -d' ' -f2")
    end
    if de == "" then
        de = "TTY"
    end
    return de
end

local de = get_de()

-- Terminal detection
local function get_terminal()
    -- Try multiple methods to detect the actual terminal emulator
    local methods = {
        -- Method 1: Check common terminal environment variables
        "echo $TERMINAL",
        -- Method 2: Search up the process tree for known terminals
        "ps -o comm= $(ps -o ppid= $(ps -o ppid= $(ps -o ppid= $$)))",
        -- Method 3: Use pstree and grep for terminal
        "pstree -s $$ | grep -oE '(kitty|alacritty|konsole|gnome-terminal|terminator|tilix|xterm|urxvt|st|foot|wezterm|rio)' | head -1",
        -- Method 4: Check parent processes
        "cat /proc/$(ps -o ppid= $(ps -o ppid= $$))/comm 2>/dev/null"
    }

    for _, cmd in ipairs(methods) do
        local term = yo.exec(cmd)
        if term ~= "" and term ~= "yofetch" and term ~= "bash" and term ~= "zsh" and term ~= "fish" then
            return term
        end
    end

    -- Fallback to TERM variable
    return yo.exec("echo $TERM")
end

local terminal = get_terminal()

-- Print information
yo.print(info_line("OS", "\27[34mNurOS\27[0m"))
yo.print(info_line("Kernel", kernel))
yo.print(info_line("Uptime", uptime))
yo.print(info_line("Packages", packages))
yo.print(info_line("Shell", shell))
yo.print(info_line("DE", de))
yo.print(info_line("Terminal", terminal))
yo.print("")
yo.print(slogan())
