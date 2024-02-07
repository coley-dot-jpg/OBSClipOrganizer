# Customize clip path and add other non-steam games here
$clipDir = "D:\Videos"
$otherGames = "Valorant", "Fortnite"

# Get the names off all the applications that we could clip
$steamPath = "D:\SteamLibrary\steamapps\common"
[string[]]$steamGames = Get-ChildItem $steamPath -directory | Name

$otherGames = "Valorant", "Fortnite"

$allGames = $steamGames + $otherGames

# Check if a new clip was made
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "D:\My Projects\ClipOrganizer"#$clipDir
$watcher.Filter = "*.txt"#;.'/;.'/;.'/;.'/;.'/ "*.mp4"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
$action = { $fromPath = $Event.SourceEventArgs.FullPath
            # Check what game is currently running
            $currentGame = Get-Process | Where {$_.ProcessName -In $allGames} | Select -expand Name
            if ($currentGame -eq $null) {$currentGame = "Desktop"}
            echo $currentGame

            $toDir = $clipDir + '\' + $currentGame
            $toPath = $toDir + '\' + $fromPath

            if (!(Test-Path -PathType Container $toPath)) {New-Item -ItemType Directory -Force -Path "$author"}
            Move-Item -Path $fromPath -Destination $toPath
            #$logline = "$(Get-Date), $changeType, $path"
            #Add-content "D:\log.txt" -value $logline
}    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
    #Register-ObjectEvent $watcher "Changed" -Action $action
    #Register-ObjectEvent $watcher "Deleted" -Action $action
    #Register-ObjectEvent $watcher "Renamed" -Action $action

# Keep the script running
while ($true) {
    sleep 5
}