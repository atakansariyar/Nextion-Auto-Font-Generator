# Nextion Auto Font Generator

Automated tool that converts TTF/OTF fonts to Nextion-compatible .zi format with interactive menu-based configuration.

## Directory Structure

```
ROOT_FOLDER/
├── fonts/              (Place your .ttf/.otf files here)
├── output/             (Generated .zi files appear here)
├── setup.bat
├── launcher.ps1
├── generator.ps1
├── settings.ini
├── ZiLib.dll
└── README.md
```

**Note:** Create a `fonts/` folder and place your font files there before running the generator.

## Usage

### Method 1: Interactive Menu (Recommended)

Double-click `setup.bat` and follow the prompts.

### Method 2: Manual Configuration

1. Edit `settings.ini`:
   ```ini
   [Settings]
   FontName=YourFont.ttf
   StartSize=12
   EndSize=100
   Encoding=iso_8859_9
   ```

2. Open PowerShell in this folder (Shift + Right-click → "Open PowerShell window here")

3. Unblock files (first time only):
   ```powershell
   Unblock-File -Path .\generator.ps1
   Unblock-File -Path .\ZiLib.dll
   ```

4. Run the generator:
   ```powershell
   .\generator.ps1
   ```

## Configuration

Edit `settings.ini` to customize font generation:

| Setting | Description | Example |
|---------|-------------|---------|
| `FontName` | Font filename in fonts/ folder | `Arial.ttf` |
| `StartSize` | Minimum font size in pixels | `12` |
| `EndSize` | Maximum font size in pixels | `100` |
| `Encoding` | Character encoding | `iso_8859_9` |

### Supported Encodings

| Code | Description |
|------|-------------|
| `utf_8` | Universal (Multi-language) |
| `ascii` | Standard ASCII |
| `iso_8859_1` | Latin-1 (Western European) |
| `iso_8859_9` | Latin-5 (Turkish) |
| `iso_8859_5` | Cyrillic |
| `shift_jis` | Japanese |
| `gb2312` | Chinese (Simplified) |

## Output

Generated files are saved to:
```
output/FontName_ENCODING/FontName_Size_ENCODING.zi
```

Example: `output/Arial_ISO-8859-9/Arial_12_ISO-8859-9.zi`

---

# Nextion Auto Font Generator

TTF/OTF fontlarını Nextion uyumlu .zi formatına dönüştüren otomatik araç.

## Dosya Yapısı

```
ANA_KLASÖR/
├── fonts/              (Font dosyalarınızı buraya koyun)
├── output/             (Oluşturulan .zi dosyaları burada)
├── setup.bat
├── launcher.ps1
├── generator.ps1
├── settings.ini
├── ZiLib.dll
└── README.md
```

**Not:** Generator'ı çalıştırmadan önce `fonts/` klasörü oluşturun ve font dosyalarınızı oraya yerleştirin.

## Kullanım

### Yöntem 1: İnteraktif Menü (Önerilen)

`setup.bat` dosyasına çift tıklayın ve yönergeleri takip edin.

### Yöntem 2: Manuel Yapılandırma

1. `settings.ini` dosyasını düzenleyin:
   ```ini
   [Settings]
   FontName=FontDosyaniz.ttf
   StartSize=12
   EndSize=100
   Encoding=iso_8859_9
   ```

2. Bu klasörde PowerShell açın (Shift + Sağ tık → "PowerShell penceresini buradan aç")

3. Dosya engellemesini kaldırın (sadece ilk seferde):
   ```powershell
   Unblock-File -Path .\generator.ps1
   Unblock-File -Path .\ZiLib.dll
   ```

4. Generator'ı çalıştırın:
   ```powershell
   .\generator.ps1
   ```

## Yapılandırma

`settings.ini` dosyasını düzenleyin:

| Ayar | Açıklama | Örnek |
|------|----------|-------|
| `FontName` | fonts/ klasöründeki dosya adı | `Arial.ttf` |
| `StartSize` | Minimum font boyutu (piksel) | `12` |
| `EndSize` | Maksimum font boyutu (piksel) | `100` |
| `Encoding` | Karakter kodlaması | `iso_8859_9` |

### Desteklenen Kodlamalar

| Kod | Açıklama |
|-----|----------|
| `utf_8` | Evrensel (Çoklu dil) |
| `ascii` | Standart ASCII |
| `iso_8859_1` | Latin-1 (Batı Avrupa) |
| `iso_8859_9` | Latin-5 (Türkçe) |
| `iso_8859_5` | Kiril |
| `shift_jis` | Japonca |
| `gb2312` | Çince (Basitleştirilmiş) |

## Çıktı

Oluşturulan dosyalar:
```
output/FontAdı_KODLAMA/FontAdı_Boyut_KODLAMA.zi
```

Örnek: `output/Arial_ISO-8859-9/Arial_12_ISO-8859-9.zi`
