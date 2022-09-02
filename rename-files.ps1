function UpdateFilesFoldersToRepoName ($TemplateName, $RepoName) {
    $files = Get-ChildItem . *.* -rec -exclude rename-files.ps1
    foreach ($file in $files) {
        try {
            if ($file -is [System.IO.FileInfo]) {
                (Get-Content $file.PSPath) |
                Foreach-Object { $_ -replace $TemplateName, $RepoName } |
                Set-Content $file.PSPath

                if ($file.Name -contains $TemplateName) {
                    $oldName = $file.Name
                    $newName = $oldName.replace($TemplateName, $RepoName)
                    Rename-Item -Path $file.FullName -NewName $newName
                }
            }
        }

        catch {
            
        }
    }


    $subdir = Get-Childitem . -Directory -rec
    $subDir | Where-Object { $_.Name -like "*"+$TemplateName+"*" } | ForEach-Object { Rename-Item $_.FullName ($_.Name -replace $TemplateName , $RepoName) }
}

if ($args.Length -lt 2) {
    return
}

Write-Host $args[0] " will be updated to " $args[1]
UpdateFilesFoldersToRepoName $args[0] $args[1]
