cd $PSScriptRoot

[int]$major = 0
[int]$minor = 0
[int]$bug = 0

Get-ChildItem .\build -Filter *.exe | ForEach-Object {
	$_ -match '(?<=_)[^\-]*(?=-.*-.*.exe)' > $null
	$tempMajor = $matches[0] -as [int]
	$_ -match '(?<=-)[^\-]*(?=-.*.exe)' > $null
	$tempMinor = $matches[0] -as [int]
	$_ -match '(?<=-)[^\-]*(?=.exe)' > $null
	$tempBug = $matches[0] -as [int]

	if ($tempMajor -gt $major) {
		$major = $tempMajor
		$minor = $tempMinor
		$bug = $tempBug
	 } elseif ($tempMajor -eq $major -and $tempMinor -gt $minor) {
		$major = $tempMajor
		$minor = $tempMinor
		$bug = $tempBug
	 } elseif ($tempMajor -eq $major -and $tempMinor -eq $minor -and $tempBug -gt $bug) {
		$major = $tempMajor
		$minor = $tempMinor
		$bug = $tempBug
	 }
}
echo "$major-$minor-$bug"
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

(Get-Content $input) | ForEach-Object {
    $_ -replace '^currentVersion.+', "currentVersion := `"$major-$minor-$bug`""
} | Set-Content $input

$output = ".\build\divisioncraftinghelper_$major-$minor-$bug.exe"

& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "$input" /out "$output" /icon ".\source\icon.ico"

echo "$major-$minor-$bug" | Set-Content ".\version"