# This script will move the created images from skraper
# very opinionated

# Grab all XML files from current dir
$xmlFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.xml -Recurse

Write-Host $xmlFiles

#Set Output INFO path
# This will out put the Metadata text file in a muOS compliant way
# Replace this with the output folder you'd prefer
$muosInfo = "F:\muOS\info\catalogue"

$systemLists = (Invoke-WebRequest -URI https://raw.githubusercontent.com/MustardOS/internal/refs/heads/main/init/MUOS/info/assign.json).Content | ConvertFrom-Json

# Load the XML file
foreach ($xmlFile in $xmlFiles) {
    # Extract the system name from the file path
    # This will put things in the muOS directory structure according to current catalogue structure
    if ( $systemLists.containsKey([System.IO.Path]::GetFileNameWithoutExtension($xmlFile.Directory.Name)))
    {
        $systemName = $systemLists[[System.IO.Path]::GetFileNameWithoutExtension($xmlFile.Directory.Name)]
    } else {
        $systemName = "arcade.ini" # hardcoded since TBS GO EXTRA have weird folders for arcade games
    }

    # use muOS assign content to set system name
    $systemName = (Invoke-WebRequest -URI https://raw.githubusercontent.com/MustardOS/internal/refs/heads/main/init/MUOS/info/assign/$systemName).Content | Where-Object { $_ -match 'catalogue=' }
    $systemName = $systemName.Split('=')[1]

    <# foreach ($game in $xml.SelectNodes("//game")) {
        $gamePath = $game.SelectSingleNode("path").InnerText
        $gameDesc = $game.SelectSingleNode("desc").InnerText #-replace "`r|`n", " " # Early versions stripped linebreaks
        $gameGenre = $game.SelectSingleNode("genre").InnerText

        # Extracting filename from the path
        # This ensures the metadata get's the correct name /INFO/content/System/meta/filename.txt
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($gamePath)
    
        # Created the files!
        $outputFolderPath = "$muosInfo\$systemName\text\"
        $outputFilePath = Join-Path -Path $outputFolderPath -ChildPath "$fileName.txt"

        # Create the directories if needed
        if (-not (Test-Path -LiteralPath $outputFolderPath)) {
            New-Item -ItemType Directory -Path $outputFolderPath | Out-Null
        }
        #$content = "$descText`r`ndesc=$gameDesc`r`n`r`n$kindText`r`nkind=$gameGenre`r`n`r`n$timeText`r`n`r`n$coreText`r`n`r`n$modeText"
        $content = $gameDesc
        Write-Host "Writing $outputFilePath"
        Set-Content -LiteralPath $outputFilePath -Value $content
    } #>

    Copy-Item -Path "${xmlFile.Directory}\box" -Destination "$muosInfo\$systemName\box"
    Copy-Item -Path "${xmlFile.Directory}\preview" -Destination "$muosInfo\$systemName\preview"
}