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
    $folderName = [System.IO.Path]::GetFileNameWithoutExtension($xmlFile.Directory.Name)
    if ( $systemLists.containsKey($systemName))
    {
        $muosSystemFile = $systemLists[[System.IO.Path]::GetFileNameWithoutExtension($systemName)]
        $systemName = $folderName
    } else {
        $muosSystemFile = "arcade.ini" # hardcoded since TBS GO EXTRA have weird folders for arcade games
        $systemName = "ARCADE"
    }

    # use muOS assign content to set system name
    $muosSystemName = (Invoke-WebRequest -URI https://raw.githubusercontent.com/MustardOS/internal/refs/heads/main/init/MUOS/info/assign/$muosSystemFile).Content | Where-Object { $_ -match 'catalogue=' }
    $muosSystemName = $muosSystemFile.Split('=')[1]

    Copy-Item -Path "${xmlFile.Directory}\box" -Destination "$muosInfo\$muosSystemFile\box"
    Copy-Item -Path "${xmlFile.Directory}\preview" -Destination "$muosInfo\$muosSystemFile\preview"
    Invoke-WebRequest "https://raw.githubusercontent.com/Vidnez/retro-systems-icons-for-GarlicOS/refs/heads/master/system/$systemName.png" -OutFile "$muosInfo\Folder\box\$folderName.png"
}

# add portmaster icon for reproducibility

Invoke-WebRequest "https://raw.githubusercontent.com/Vidnez/retro-systems-icons-for-GarlicOS/refs/heads/master/system/PORTS.png" -OutFile "$muosInfo\Folder\box\PORTS.png"