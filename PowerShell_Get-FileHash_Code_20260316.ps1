<#
.SYNOPSIS
    Demonstrate file comparison, timestamp manipulation, and file hashing with PowerShell Get-FileHash.

.DESCRIPTION
    This script is a curated, copy/paste-friendly set of PowerShell command examples for demonstrating
    why file attributes and visible text comparisons can be misleading, and why Get-FileHash is the
    reliable way to verify byte-level file integrity.

    It demonstrates:
      - Comparing file properties and text measurements
      - Changing file timestamps in Windows
      - Linux / WSL equivalent timestamp commands (reference only)
      - Computing file hashes with Get-FileHash
      - Viewing file bytes with Format-Hex
      - Checking Get-FileHash help and the underlying .NET runtime
      - Comparing multiple hash algorithms
      - Hashing a string by using -InputStream with a MemoryStream

    Each section is independent—use only what you need.

.NOTES
    Author      : Darien Hawkins
    Channel     : https://www.youtube.com/@darienstips9409
    Video       : https://www.youtube.com/watch?v=Cw2YXEqpaS8
    Requires    : Windows PowerShell 5.1 or PowerShell 7+
    Focus       : PowerShell Get-FileHash, file integrity, hashes, timestamps, encoding
#>

# =========================================================
# 1. Compare file properties and text measurements
# =========================================================

$filePair = @(
    'C:\Temp\folderA\aaa.txt'
    'C:\Temp\folderB\aaa.txt'
)

# Get basic file properties
Get-ItemProperty -Path $filePair |
    Select-Object Name, FullName, Length, CreationTime, LastWriteTime

# Measure visible text content
Get-Content -Path $filePair -Raw |
    Measure-Object -Character -Line


# =========================================================
# 2. Copy a file and modify timestamps in Windows
# =========================================================

$servicesFile = Get-Item 'C:\Windows\System32\drivers\etc\services'
$copiedFilePath = 'C:\Temp\attribRUnreliableServices.txt'

Copy-Item -Path $servicesFile.FullName -Destination $copiedFilePath -Force

$file = Get-Item $copiedFilePath

# Show original properties
Get-Item -Path $file.FullName |
    Select-Object Name, FullName, Length, CreationTime, LastWriteTime

# Change timestamps
$file.CreationTime   = '03/14/2067 03:14:59 AM'
$file.LastWriteTime  = '03/14/2067 03:14:59 AM'
$file.LastAccessTime = '03/14/2067 03:14:59 AM'

# Show modified properties
Get-Item -Path $file.FullName |
    Select-Object Name, FullName, Length, CreationTime, LastWriteTime


# =========================================================
# 3. Linux / WSL equivalent commands (reference)
# =========================================================

<#
touch -am -t 206703140314 ~/attribRUnreliableServices
stat ~/attribRUnreliableServices
#>


# =========================================================
# 4. Get file hash values
# =========================================================

Get-FileHash -Path $filePair |
    Format-List


# =========================================================
# 5. View the first 10 lines of a file in hex
# =========================================================

$hexPair = @(
    'C:\Temp\folderA\aaaA.txt'
    'C:\Temp\folderB\aaaA.txt'
)

Format-Hex -Path $hexPair |
    Select-Object -First 10


# =========================================================
# 6. Get help for Get-FileHash
# =========================================================

Get-Help Get-FileHash


# =========================================================
# 7. Show the underlying .NET runtime version
# =========================================================

[System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription


# =========================================================
# 8. Get hash values for a file using different algorithms
# =========================================================

$folderPath = 'C:\Temp\Windows_Update_Catalog\KB5074828'
$update     = 'windows11.0-kb5074828-x64-ndp481_88bbe39d8dc9e306cd2d5faa817c8656e6d798d7.msu'
$updatePath = Join-Path -Path $folderPath -ChildPath $update

# SHA1
Get-FileHash -Path $updatePath -Algorithm SHA1 |
    Format-List

# Default algorithm (SHA256)
Get-FileHash -Path $updatePath |
    Format-List

# Additional SHA-2 algorithms
'SHA256', 'SHA384', 'SHA512' | ForEach-Object {
    Get-FileHash -Path $updatePath -Algorithm $_ |
        Format-List
}

# MD5
Get-FileHash -Path $updatePath -Algorithm MD5 |
    Format-List


# =========================================================
# 9. Get hash values for a string using MemoryStream
# =========================================================

$somethingToSay = 'Hello world. Please like, subscribe, and share this video with others.'

$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)

$writer.Write($somethingToSay)
$writer.Flush()

# Reset stream position before hashing
$stringAsStream.Position = 0
Get-FileHash -InputStream $stringAsStream |
    Select-Object Algorithm, Hash

# Reset again before hashing a second time with another algorithm
$stringAsStream.Position = 0
Get-FileHash -InputStream $stringAsStream -Algorithm SHA512 |
    Select-Object Algorithm, Hash

# Cleanup
$writer.Dispose()
$stringAsStream.Dispose()