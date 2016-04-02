[int]$major = 0
[int]$minor = 0
[int]$bug = 0

Get-ChildItem .\build -Filter *.exe | ForEach-Object {

    if ($_ -match '(?<=_)[^\-]*(?=-.*-.*.exe)' -and $matches[0] -as [int] -gt $major) { $major = $matches[0] -as [int] }
    if ($_ -match '(?<=-)[^\-]*(?=-.*.exe)' -and $matches[0] -as [int] -gt $minor) { $minor = $matches[0] -as [int] }
    if ($_ -match '(?<=-)[^\-]*(?=.exe)' -and $matches[0] -as [int] -gt $bug) { $bug = $matches[0] -as [int] }
}

$type = Read-Host "Major, Minor, or Bug Fix (1, 2, Default = 3)"
while (1)
{
    if ($type -eq '1')
    {
        $major += 1
        $minor = 0
        $bug = 0
        break
    }
    elseif ($type -eq '2')
    {
        $minor += 1
        $bug = 0
        break
    }
    elseif ($type -eq '3' -or $type -eq '')
    {
        $bug += 1
        break
    }
    else
    {
        echo "Invalid input. Please try again."
        $type = Read-Host "Major, Minor, or Bug Fix (1, 2, Default = 3): "
    }
}

$input = ".\Source\craftinghelper.ahk"
$output = ".\build\divisioncraftinghelper_$major-$minor-$bug.exe"

& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "$input" /out "$output" /icon ".\source\icon.ico"
