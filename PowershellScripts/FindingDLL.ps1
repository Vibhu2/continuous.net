$localuser=Get-LocalUser | Select-Object -ExpandProperty Name

foreach ($User in $localuser) {
    
    Get-ChildItem -Path "C:\Users\$User\AppData\Local\Programs\3CXDesktopApp\" -Recurse -Filter 'ffmpeg.dll' -ErrorAction SilentlyContinue
    Get-ChildItem -Path "C:\Users\$User\AppData\Local\Programs\3CXDesktopApp\" -Recurse -Filter 'D3compiler_47.dll' -ErrorAction SilentlyContinue

}
