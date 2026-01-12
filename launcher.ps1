####################################################################################################
#
# launcher.ps1 - Nextion Auto Font Generator - Interactive Menu
#
# Provides an interactive menu to:
#   - Select font from fonts/ folder
#   - Configure size range
#   - Select encoding
#   - Run the generator
#
####################################################################################################

Set-Location $PSScriptRoot
$Host.UI.RawUI.WindowTitle = "Nextion Auto Font Generator"

# Color shortcuts
function Write-Title { param($text) Write-Host $text -ForegroundColor Cyan }
function Write-Option { param($num, $text) Write-Host "  [$num] " -ForegroundColor Yellow -NoNewline; Write-Host $text }
function Write-Selected { param($label, $value) Write-Host "  $label : " -NoNewline; Write-Host $value -ForegroundColor Green }

# Available encodings
$encodings = @(
    @{ Code = "iso_8859_9"; Name = "ISO-8859-9  (Turkish)" }
    @{ Code = "utf_8"; Name = "UTF-8       (Universal)" }
    @{ Code = "ascii"; Name = "ASCII       (Standard)" }
    @{ Code = "iso_8859_1"; Name = "ISO-8859-1  (Western European)" }
    @{ Code = "iso_8859_5"; Name = "ISO-8859-5  (Cyrillic)" }
    @{ Code = "iso_8859_15"; Name = "ISO-8859-15 (Latin-9 with Euro)" }
    @{ Code = "shift_jis"; Name = "Shift-JIS   (Japanese)" }
    @{ Code = "gb2312"; Name = "GB2312      (Chinese Simplified)" }
)

# ============================================================
# STEP 1: Select Font
# ============================================================
function Select-Font {
    Clear-Host
    Write-Title "================================================"
    Write-Title "   NEXTION AUTO FONT GENERATOR"
    Write-Title "================================================"
    Write-Host ""
    Write-Title "STEP 1: Select Font"
    Write-Host ""
    
    $fontsDir = Join-Path -Path $PSScriptRoot -ChildPath "fonts"
    
    if (-not (Test-Path $fontsDir)) {
        Write-Host "ERROR: 'fonts' folder not found!" -ForegroundColor Red
        Write-Host "Please create a 'fonts' folder and add .ttf/.otf files." -ForegroundColor Gray
        return $null
    }
    
    $fonts = @(Get-ChildItem -Path "$fontsDir\*.ttf" -File -ErrorAction SilentlyContinue) + @(Get-ChildItem -Path "$fontsDir\*.otf" -File -ErrorAction SilentlyContinue)
    
    if ($fonts.Count -eq 0) {
        Write-Host "ERROR: No font files found in 'fonts' folder!" -ForegroundColor Red
        Write-Host "Please add .ttf or .otf files to the 'fonts' folder." -ForegroundColor Gray
        return $null
    }
    
    $i = 1
    foreach ($font in $fonts) {
        $sizeKB = [math]::Round($font.Length / 1KB, 1)
        Write-Option $i "$($font.Name) ($sizeKB KB)"
        $i++
    }
    
    Write-Host ""
    $selection = Read-Host "Enter number (1-$($fonts.Count))"
    
    $index = 0
    if ([int]::TryParse($selection, [ref]$index) -and $index -ge 1 -and $index -le $fonts.Count) {
        return $fonts[$index - 1]
    }
    
    Write-Host "Invalid selection!" -ForegroundColor Red
    return $null
}

# ============================================================
# STEP 2: Select Size Range
# ============================================================
function Select-SizeRange {
    Clear-Host
    Write-Title "================================================"
    Write-Title "   NEXTION AUTO FONT GENERATOR"
    Write-Title "================================================"
    Write-Host ""
    Write-Title "STEP 2: Size Range"
    Write-Host ""
    Write-Host "  Common ranges:" -ForegroundColor Gray
    Write-Option 1 "12 - 48  (Small displays)"
    Write-Option 2 "12 - 72  (Medium displays)"
    Write-Option 3 "12 - 100 (Large displays)"
    Write-Option 4 "Custom range"
    Write-Host ""
    
    $selection = Read-Host "Enter number (1-4)"
    
    switch ($selection) {
        "1" { return @{ Start = 12; End = 48 } }
        "2" { return @{ Start = 12; End = 72 } }
        "3" { return @{ Start = 12; End = 100 } }
        "4" {
            Write-Host ""
            $startSize = Read-Host "  Start size (min 8)"
            $endSize = Read-Host "  End size (max 255)"
            
            $start = [int]$startSize
            $end = [int]$endSize
            
            if ($start -lt 8) { $start = 8 }
            if ($end -gt 255) { $end = 255 }
            if ($start -gt $end) { $start, $end = $end, $start }
            
            return @{ Start = $start; End = $end }
        }
        default {
            return @{ Start = 12; End = 100 }
        }
    }
}

# ============================================================
# STEP 3: Select Encoding
# ============================================================
function Select-Encoding {
    Clear-Host
    Write-Title "================================================"
    Write-Title "   NEXTION AUTO FONT GENERATOR"
    Write-Title "================================================"
    Write-Host ""
    Write-Title "STEP 3: Encoding"
    Write-Host ""
    
    $i = 1
    foreach ($enc in $encodings) {
        Write-Option $i $enc.Name
        $i++
    }
    
    Write-Host ""
    $selection = Read-Host "Enter number (1-$($encodings.Count)) [default: 1]"
    
    if ([string]::IsNullOrWhiteSpace($selection)) {
        return $encodings[0].Code
    }
    
    $index = 0
    if ([int]::TryParse($selection, [ref]$index) -and $index -ge 1 -and $index -le $encodings.Count) {
        return $encodings[$index - 1].Code
    }
    
    return $encodings[0].Code
}

# ============================================================
# STEP 4: Confirm and Run
# ============================================================
function Confirm-AndRun {
    param($font, $sizeRange, $encoding)
    
    Clear-Host
    Write-Title "================================================"
    Write-Title "   NEXTION AUTO FONT GENERATOR"
    Write-Title "================================================"
    Write-Host ""
    Write-Title "STEP 4: Confirm"
    Write-Host ""
    Write-Selected "Font" $font.Name
    Write-Selected "Size" "$($sizeRange.Start) - $($sizeRange.End) px"
    Write-Selected "Encoding" $encoding.ToUpper().Replace("_", "-")
    Write-Host ""
    
    $confirm = Read-Host "Start generation? (Y/N) [Y]"
    
    if ([string]::IsNullOrWhiteSpace($confirm) -or $confirm -match "^[Yy]") {
        return $true
    }
    
    return $false
}

# ============================================================
# MAIN
# ============================================================

# Step 1: Font Selection
$selectedFont = Select-Font
if (-not $selectedFont) {
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Step 2: Size Range
$sizeRange = Select-SizeRange

# Step 3: Encoding
$encoding = Select-Encoding

# Step 4: Confirm
$confirmed = Confirm-AndRun -font $selectedFont -sizeRange $sizeRange -encoding $encoding

if (-not $confirmed) {
    Write-Host "`nCancelled. Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

# Update settings.ini with selected values
$iniPath = Join-Path -Path $PSScriptRoot -ChildPath "settings.ini"
$iniContent = @"
# ============================================================
# NEXTION AUTO FONT GENERATOR CONFIGURATION
# Auto-generated by launcher.ps1
# ============================================================

[Settings]
FontName=$($selectedFont.Name)
StartSize=$($sizeRange.Start)
EndSize=$($sizeRange.End)
Encoding=$encoding
"@

Set-Content -Path $iniPath -Value $iniContent -Encoding UTF8

# Run the generator
Write-Host ""
Write-Title "Starting generation..."
Write-Host ""

& (Join-Path -Path $PSScriptRoot -ChildPath "generator.ps1")

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
