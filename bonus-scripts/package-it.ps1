$muosInfo = "F:\muOS\info\catalogue"

New-Item -ItemType Directory -Path "F:\m\mnt\mmc\MUOS\info\catalogue" | Out-Null

Copy-Item -Recurse -Path "$muosInfo\*" -Destination "F:\m\mnt\mmc\MUOS\info\catalogue"

Compress-Archive -Path "F:\m\*" -DestinationPath tbs.muos.zip