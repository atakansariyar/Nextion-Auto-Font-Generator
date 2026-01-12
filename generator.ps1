####################################################################################################
#
# generator.ps1 - Nextion Auto Font Generator
# 
# Converts TTF/OTF fonts to Nextion-compatible .zi format
#
# Features:
#   - Batch font generation with configurable size range
#   - Progress bar for visual feedback
#   - Dynamic encoding selection (UTF-8, ISO-8859-9, etc.)
#   - Automatic output folder organization
#
# Usage:
#   1. Place font files in 'fonts/' folder
#   2. Configure settings.ini (FontName, StartSize, EndSize, Encoding)
#   3. Run: .\generator.ps1
#
####################################################################################################

Set-Location $PSScriptRoot
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Check and Load ZiLib.dll
$dllPath = Join-Path -Path $PSScriptRoot -ChildPath "ZiLib.dll"
if (Test-Path $dllPath) {
  Add-Type -Path $dllPath
}
else {
  Write-Host "ERROR: ZiLib.dll not found in the script directory!" -ForegroundColor Red
  exit 1
}

Function Get-Settings {
  $iniPath = Join-Path -Path $PSScriptRoot -ChildPath "settings.ini"
    
  if (-not (Test-Path $iniPath)) {
    Write-Host "ERROR: settings.ini not found!" -ForegroundColor Red
    exit 1
  }

  # Custom parser to handle comments in INI
  $iniContent = Get-Content -Path $iniPath | 
  Where-Object { $_ -match "=" -and $_ -notmatch "^#" } | 
  ConvertFrom-StringData
  return $iniContent
}

Function Invoke-BatchGenerator {
  # Load Settings
  $settings = Get-Settings
  if (-not $settings) { return }

  $fontFileName = $settings.FontName
  $startSize = [int]$settings.StartSize
  $endSize = [int]$settings.EndSize
  $encodingStr = $settings.Encoding

  # ---------------------------------------------------------
  # PATH CONFIGURATION
  # ---------------------------------------------------------
    
  # 1. Define Fonts Directory
  $fontsDir = Join-Path -Path $PSScriptRoot -ChildPath "fonts"
  if (-not (Test-Path $fontsDir)) {
    Write-Host "ERROR: 'fonts' directory not found!" -ForegroundColor Red
    Write-Host "Please create a folder named 'fonts' and put your .ttf files there." -ForegroundColor Gray
    exit 1
  }

  # 2. Validate Font File
  $fontPath = Join-Path -Path $fontsDir -ChildPath $fontFileName
  if (-not (Test-Path $fontPath)) {
    Write-Host "ERROR: Font file '$fontFileName' not found inside 'fonts' folder!" -ForegroundColor Red
    exit 1
  }

  # 3. Define Main Output Directory
  $mainOutputDir = Join-Path -Path $PSScriptRoot -ChildPath "output"
  if (-not (Test-Path $mainOutputDir)) {
    New-Item -ItemType Directory -Path $mainOutputDir -Force | Out-Null
  }

  # ---------------------------------------------------------
  # ENCODING & TARGET FOLDER setup
  # ---------------------------------------------------------

  # Resolve Encoding (internal use for ZiLib)
  try {
    $codePage = [ZiLib.CodePageIdentifier]::$encodingStr
    if (-not $codePage) { throw "Null Encoding" }
  }
  catch {
    Write-Host "ERROR: Invalid Encoding '$encodingStr' in settings.ini." -ForegroundColor Red
    Write-Host "Please use a valid code from the Reference Manual in settings.ini (e.g., iso_8859_9)" -ForegroundColor Gray
    exit 1
  }

  # Prepare Specific Output Folder 
  # Logic: 
  # 1. Get Base Name
  # 2. Convert Encoding to Upper Case (Invariant Culture for 'i' -> 'I')
  # 3. Replace Underscore (_) with Hyphen (-)
    
  $fontBaseName = [System.IO.Path]::GetFileNameWithoutExtension($fontFileName)
    
  $encodingFormatted = $encodingStr.ToUpper([System.Globalization.CultureInfo]::InvariantCulture).Replace("_", "-")
    
  $folderName = "{0}_{1}" -f $fontBaseName, $encodingFormatted
  $finalOutputPath = Join-Path -Path $mainOutputDir -ChildPath $folderName

  if (-not (Test-Path $finalOutputPath)) {
    New-Item -ItemType Directory -Path $finalOutputPath -Force | Out-Null
    Write-Host "Created Directory: output\$folderName" -ForegroundColor Cyan
  }

  # Summary
  Write-Host "------------------------------------------------" -ForegroundColor Cyan
  Write-Host " Source    : fonts\$fontFileName" -ForegroundColor Yellow
  Write-Host " Range     : $startSize - $endSize px" -ForegroundColor Yellow
  Write-Host " Encoding  : $encodingFormatted" -ForegroundColor Yellow
  Write-Host " Output    : output\$folderName" -ForegroundColor Yellow
  Write-Host "------------------------------------------------" -ForegroundColor Cyan

  # Batch Process with Progress Bar
  $sizeRange = $startSize..$endSize
  $totalSizes = $sizeRange.Count
  $successCount = 0
  $failedItems = @()
  $counter = 0
    
  foreach ($currentSize in $sizeRange) {
    $counter++
    $percentComplete = [math]::Round(($counter / $totalSizes) * 100)
        
    # Show progress bar
    Write-Progress -Activity "Generating Fonts" `
      -Status "Processing size $currentSize px ($counter of $totalSizes)" `
      -PercentComplete $percentComplete
        
    try {
      New-ZiFontV5 -textFont $fontPath `
        -textVerticalOffset 0 `
        -textFontSize $currentSize `
        -Codepage $codePage `
        -Path $finalOutputPath
            
      $successCount++
    }
    catch {
      $failedItems += "Size $currentSize : $($_.Exception.Message)"
    }
  }
    
  # Clear progress bar
  Write-Progress -Activity "Generating Fonts" -Completed
    
  # Display results
  $failCount = $failedItems.Count
    
  Write-Host "`n"
  Write-Host "================================================" -ForegroundColor Cyan
  Write-Host " COMPLETED: $successCount / $totalSizes sizes generated" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Yellow" })
    
  if ($failCount -gt 0) {
    Write-Host " FAILED: $failCount sizes" -ForegroundColor Red
    foreach ($err in $failedItems) {
      Write-Host "   - $err" -ForegroundColor Red
    }
  }
    
  Write-Host " Location: $finalOutputPath" -ForegroundColor Gray
  Write-Host "================================================" -ForegroundColor Cyan
}

Function New-ZiFontV5 {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$textFont,

    [Parameter(Position = 1, Mandatory = $false)]
    [string]$iconFont,

    [Parameter(Position = 2, Mandatory = $false)]
    [int]$iconFontFirstCP,

    [Parameter(Position = 3, Mandatory = $false)]
    [int]$iconFontLastCP,

    [Parameter(Position = 4, Mandatory = $false)]
    [int]$iconCPOffset = 0,

    [Parameter(Position = 5, Mandatory = $false)]
    [int]$textVerticalOffset = 0,

    [Parameter(Position = 6, Mandatory = $false)]
    [int]$iconVerticalOffset = 0,

    [Parameter(Position = 7, Mandatory = $true)]
    [int]$textFontSize,

    [Parameter(Position = 8, Mandatory = $false)]
    [int]$iconFontSizeOffset = 0,

    [Parameter(Position = 9, Mandatory = $false)]
    $Codepage = [ZiLib.CodePageIdentifier]::utf_8,

    [Parameter(Position = 10, Mandatory = $true)]
    [string]$Path
  )

  $locationText = [System.Drawing.PointF]::new(0, $textVerticalOffset)
  
  $file = Get-Item $textFont
  if ((($file.Extension -eq ".ttf") -or ($file.Extension -eq ".otf")) -and ($file.Exists)) {
    $pfc = [System.Drawing.Text.PrivateFontCollection]::new()
    $pfc.AddFontFile($textFont)
    $font = [System.Drawing.Font]::new($pfc.Families[0], $textFontSize, "regular", [System.Drawing.GraphicsUnit]::pixel );
  }
  else {
    $font = [ZiLib.Extensions.BitmapExtensions]::GetFont($textFont, $textFontSize, "Regular")
  }

  # Font size tuning for Nextion pixel mapping
  $newfontsize = $textFontSize
  $i = 0
  while ([math]::Abs($textFontSize - $font.Height) -gt 0.1 -and $i++ -lt 10) {
    $newfontsize += ($textFontSize - $font.Height) / 2 * $newfontsize / $font.Height;
    $font = [System.Drawing.Font]::new($font.fontfamily, $newfontsize, "regular", [System.Drawing.GraphicsUnit]::pixel );
  }

  $f = [ZiLib.FileVersion.V5.ZiFontV5]::new()
  $f.CharacterHeight = $textFontSize
  $f.CodePage = $codepage
  $f.Version = 5

  foreach ($ch in 32..255) {
    $bytes = [bitconverter]::GetBytes([uint16]$ch)
    
    if ($f.CodePage.CodePageIdentifier -eq "UTF_8") {
      if ($ch -lt 0x00d800 -or $ch -gt 0x00dfff) {
        $txt = [Char]::ConvertFromUtf32([uint32]($ch)) 
      }
      else { $txt = "?" }
    }
    else {
      if ($ch -gt 255) {
        $txt = $f.CodePage.Encoding.GetChars($bytes, 0, 2)
      }
      else {
        $txt = $f.CodePage.Encoding.GetChars($bytes, 0, 1)
      }
    }

    $character = [ZiLib.FileVersion.Common.ZiCharacter]::FromString($f, $ch, $font, $locationText, $txt)
    $f.AddCharacter($ch, $character)
  }

  $filename = $file.basename
  $f.Name = $filename

  # Output filename format: FontName_Size_ISO-8859-9.zi
  # Force replace underscore with hyphen here as well
  $encSuffix = $codepage.ToString().Replace("_", "-") 
  $outfile = Join-Path -Path $path -ChildPath ("{0}_{1}_{2}.zi" -f $filename, $textFontSize, $encSuffix)
  $f.Save($outfile)
}

Invoke-BatchGenerator