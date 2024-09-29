# This script will move the created images from skraper
# very opinionated

# Grab all XML files from current dir
$xmlFiles = Get-ChildItem -Path "F:\TBS GO EXTRA PLUS" -Filter *.xml -Recurse

#Set Output INFO path
# This will out put the Metadata text file in a muOS compliant way
# Replace this with the output folder you'd prefer
$muosInfo = "F:\muOS\info\catalogue"

$systemLists = (Invoke-WebRequest -URI https://raw.githubusercontent.com/MustardOS/internal/refs/heads/main/init/MUOS/info/assign.json).Content | ConvertFrom-Json -AsHashtable

# Load the XML file
foreach ($xmlFile in $xmlFiles) {
    # Extract the system name from the file path
    # This will put things in the muOS directory structure according to current catalogue structure
    Write-Host $xmlFile.Directory.Name
    $systemName = $xmlFile.Directory.Name
    $folderName = $systemName
    $systemName = $systemName.Trim().ToLower()
    $exists= $systemLists.containsKey($systemName)
    if ($exists)
    {
        $muosSystemFile = $systemLists[$systemName]
        $systemName = $folderName
    }else{
        $muosSystemFile = "Arcade.ini" # hardcoded since TBS GO EXTRA have weird folders for arcade games  
        $systemName = "ARCADE"
    }
    # use muOS assign content to set system name
    
    $didwefindanything = (Get-ChildItem -Path . -Filter $muosSystemFile -Recurse)
    $path = $didwefindanything | Select-Object FullName
    $muosSystemFile = Get-Content -Path $path.FullName  | Where-Object { $_ -match 'catalogue=' }
    $muosSystemFile = $muosSystemFile.Split('=')[1]

    $origin=$xmlFile.Directory
    $dest = "$muosInfo\$muosSystemFile"
    if (-not (Test-Path -LiteralPath "$dest\box")) {
        New-Item -ItemType Directory -Path "$dest\box" | Out-Null
    }
    if (-not (Test-Path -LiteralPath "$dest\preview")) {
        New-Item -ItemType Directory -Path "$dest\preview" | Out-Null
    }
    Copy-Item -Path "$origin\box\*" -Destination "$dest\box"
    Copy-Item -Path "$origin\preview\*" -Destination "$dest\preview"
    if (-not (Test-Path -LiteralPath "$muosInfo\Folder\box\")) {
        New-Item -ItemType Directory -Path "$muosInfo\Folder\box\" | Out-Null
    }
    Invoke-WebRequest "https://raw.githubusercontent.com/Vidnez/retro-systems-icons-for-GarlicOS/refs/heads/master/system/$systemName.png" -OutFile "$muosInfo\Folder\box\$folderName.png"
}

# add portmaster icon for reproducibility

Invoke-WebRequest "https://raw.githubusercontent.com/Vidnez/retro-systems-icons-for-GarlicOS/refs/heads/master/system/PORTS.png" -OutFile "$muosInfo\Folder\box\PORTS.png"