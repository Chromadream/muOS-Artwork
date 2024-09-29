# this script corrects TBS' "absolute path" m3u files for multidisc games

$m3us = Get-ChildItem -Path "F:\TBS GO EXTRA PLUS" -Filter *.m3u -Recurse

foreach ($m3u in $m3us) {
    Copy-Item -Path $m3u -Destination "$m3u.backup"
    Get-Content -Path $m3u | ForEach-Object {
        $_ -replace "^_hidden", ".hidden"
    } | Out-File -FilePath "$m3u.done" -Force
}
$m3us | ForEach-Object { Move-Item -Path "$_.done" -Destination "$_" -Force }