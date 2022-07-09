#Requires -Version 7.1
$ErrorActionPreference = "Stop" # exit when command fails

$env:XDG_DATA_HOME = $env:XDG_DATA_HOME ?? $env:APPDATA
$env:XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME ?? $env:LOCALAPPDATA
$env:XDG_CACHE_HOME = $env:XDG_CACHE_HOME ?? $env:TEMP

$env:DARKVIM_RUNTIME_DIR = $env:DARKVIM_RUNTIME_DIR ?? "$env:XDG_DATA_HOME\darkvim"
$env:DARKVIM_CONFIG_DIR = $env:DARKVIM_CONFIG_DIR ?? "$env:XDG_CONFIG_HOME\dark"
$env:DARKVIM_CACHE_DIR = $env:DARKVIM_CACHE_DIR ?? "$env:XDG_CACHE_HOME\dark"
$env:DARKVIM_BASE_DIR = $env:DARKVIM_BASE_DIR ?? "$env:DARKVIM_RUNTIME_DIR\dark"

nvim -u "$env:DARKVIM_RUNTIME_DIR\dark\init.lua" @args
