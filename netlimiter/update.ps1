import-module au

function global:au_SearchReplace {
    $url = "https://www.netlimiter.com/files/download/nl4/netlimiter-$($Latest.Version).exe"
    Invoke-WebRequest -Uri $url -OutFile '_netlimiter.exe'
    $checksum = (Get-FileHash '_netlimiter.exe' -Algorithm SHA256).Hash
    Remove-Item '_netlimiter.exe' -Force

    @{
        ".\tools\chocolateyinstall.ps1"   = @{
            "(^[$]version\s*=\s*)('.*')"  = "`$1'$($Latest.Version)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$checksum'"
        }
        ".\netlimiter.nuspec"   = @{
            "(?i)(\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.netlimiter.com/'
    $version = $download_page.links | ? href -match '/releases/' | select -exp href | % { ($_ -split '/')[3] -replace '-', '.' } | select -first 1
    @{
        Version      = $version
        Checksum     = $checksum
        ReleaseNotes = "https://www.netlimiter.com/releases/nl4/$($version -replace '\.', '-')"
    }
}

update
