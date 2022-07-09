#Requires -Version 7.1
$ErrorActionPreference = "Stop" # exit when command fails

# set script variables
$LV_BRANCH = $LV_BRANCH ?? "rolling"
$LV_REMOTE = $LV_REMOTE ??  "darkvim/darkvim.git"
$INSTALL_PREFIX = $INSTALL_PREFIX ?? "$HOME\.local"

$env:XDG_DATA_HOME = $env:XDG_DATA_HOME ?? $env:APPDATA
$env:XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME ?? $env:LOCALAPPDATA
$env:XDG_CACHE_HOME = $env:XDG_CACHE_HOME ?? $env:TEMP

$env:DARKVIM_RUNTIME_DIR = $env:DARKVIM_RUNTIME_DIR ?? "$env:XDG_DATA_HOME\darkvim"
$env:DARKVIM_CONFIG_DIR = $env:DARKVIM_CONFIG_DIR ?? "$env:XDG_CONFIG_HOME\dark"
$env:DARKVIM_CACHE_DIR = $env:DARKVIM_CACHE_DIR ?? "$env:XDG_CACHE_HOME\dark"
$env:DARKVIM_BASE_DIR = $env:DARKVIM_BASE_DIR ?? "$env:DARKVIM_RUNTIME_DIR\dark"

$__dark_dirs = (
    $env:DARKVIM_BASE_DIR,
    $env:DARKVIM_RUNTIME_DIR,
    $env:DARKVIM_CONFIG_DIR,
    $env:DARKVIM_CACHE_DIR
)

function main($cliargs) {
    Write-Output "Removing DarkVim binary..."
    remove_dark_bin
    Write-Output "Removing DarkVim directories..."
    $force = $false
    if ($cliargs.Contains("--remove-backups")) {
        $force = $true
    }
    remove_dark_dirs $force
    Write-Output "Uninstalled DarkVim!"
}

function remove_dark_bin(){
    $dark_bin="$INSTALL_PREFIX\bin\dark"
    if (Test-Path $dark_bin) {
        Remove-Item -Force $dark_bin
    }
    if (Test-Path alias:dark) {
        Write-Warning "Please make sure to remove the 'dark' alias from your `$PROFILE`: $PROFILE"
    }
}

function remove_dark_dirs($force) {
    foreach ($dir in $__dark_dirs) {
        if (Test-Path $dir) {
            Remove-Item -Force -Recurse $dir
        }
        if ($force -eq $true) {
            if (Test-Path "$dir.bak") {
                Remove-Item -Force -Recurse "$dir.bak"
            }
            if (Test-Path "$dir.old") {
                Remove-Item -Force -Recurse "$dir.old"
            }
        }
    }
}

main($args)