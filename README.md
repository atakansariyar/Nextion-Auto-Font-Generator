# Nextion Auto Font Generator

An automated interactive tool that converts `.ttf` and `.otf` fonts to Nextion-compatible `.zi` format with menu-based configuration.

## 📁 Directory Structure

```
ROOT_FOLDER/
├── fonts/              ← Place your .ttf/.otf files here
├── output/             ← Generated .zi files appear here
├── setup.bat           ← Double-click to start (Main Entry)
├── launcher.ps1        ← Interactive menu system
├── generator.ps1       ← Font generation engine
├── settings.ini        ← Auto-generated config (optional)
├── ZiLib.dll           ← Required library
└── README.md
```

## 🚀 Quick Start

### Easiest Method (Recommended)
**Double-click `setup.bat`** — Automatically unblocks files and runs the generator.

### Alternative: Manual PowerShell Method

1. **Edit `settings.ini`** with Notepad:
   ```ini
   [Settings]
   FontName=YourFont.ttf
   StartSize=12
   EndSize=100
   Encoding=iso_8859_9
   ```

2. **Open PowerShell in this folder:**
   - Hold `Shift` + Right-click in the folder
   - Select **"Open PowerShell window here"**

3. **First time only - Unblock files:**
   ```powershell
   Unblock-File -Path .\generator.ps1
   Unblock-File -Path .\ZiLib.dll
   ```

4. **Run the script:**
   ```powershell
   .\generator.ps1
   ```

## ⚙️ Configuration (settings.ini)

Edit `settings.ini` with Notepad to customize:

| Setting | Description | Example |
|---------|-------------|---------|
| `FontName` | Font filename in `fonts/` folder | `Arial.ttf` |
| `StartSize` | Minimum font size (px) | `12` |
| `EndSize` | Maximum font size (px) | `100` |
| `Encoding` | Character encoding | `iso_8859_9` |

### Available Encodings

| Code | Description |
|------|-------------|
| `utf_8` | Universal (Multi-language) |
| `ascii` | Standard ASCII |
| `iso_8859_1` | Latin-1 (Western European) |
| `iso_8859_9` | Latin-5 (Turkish) |
| `iso_8859_5` | Cyrillic |
| `shift_jis` | Japanese |
| `gb2312` | Chinese (Simplified) |

## 📤 Output

Generated files are placed in:
```
output/FontName_ENCODING/
└── FontName_Size_ENCODING.zi
```

Example: `output/Arial_ISO-8859-9/Arial_12_ISO-8859-9.zi`



---

# Nextion Auto Font Generator (Otomatik Font Oluşturucu)

Menü tabanlı yapılandırma ile TTF/OTF fontlarını Nextion uyumlu `.zi` formatına dönüştüren otomatik interaktif araç.

## 📁 Dosya Yapısı

```
ANA_KLASÖR/
├── fonts/              ← Font dosyalarınızı buraya koyun
├── output/             ← Oluşturulan .zi dosyaları burada
├── setup.bat           ← Çift tıklayarak başlatın (Ana Giriş)
├── launcher.ps1        ← İnteraktif menü sistemi
├── generator.ps1       ← Font oluşturma motoru
├── settings.ini        ← Otomatik oluşturulan ayarlar (opsiyonel)
├── ZiLib.dll           ← Gerekli kütüphane
└── README.md
```

## 🚀 Hızlı Başlangıç

### Kullanım (Tek Adım!)
**`setup.bat` dosyasına çift tıklayın** — İnteraktif menü açılır:

### Alternatif: Manuel PowerShell Yöntemi

1. **`settings.ini` dosyasını düzenleyin** (Not Defteri ile):
   ```ini
   [Settings]
   FontName=FontDosyaniz.ttf
   StartSize=12
   EndSize=100
   Encoding=iso_8859_9
   ```

2. **Bu klasörde PowerShell açın:**
   - Klasörde `Shift` basılı tutarak sağ tıklayın
   - **"PowerShell penceresini buradan aç"** seçin

3. **Sadece ilk seferde - Dosya engellemesini kaldırın:**
   ```powershell
   Unblock-File -Path .\generator.ps1
   Unblock-File -Path .\ZiLib.dll
   ```

4. **Scripti çalıştırın:**
   ```powershell
   .\generator.ps1
   ```

## ⚙️ Yapılandırma (settings.ini)

`settings.ini` dosyasını Not Defteri ile düzenleyin:

| Ayar | Açıklama | Örnek |
|------|----------|-------|
| `FontName` | `fonts/` klasöründeki dosya adı | `Arial.ttf` |
| `StartSize` | Minimum font boyutu (px) | `12` |
| `EndSize` | Maksimum font boyutu (px) | `100` |
| `Encoding` | Karakter kodlaması | `iso_8859_9` |

### Mevcut Kodlamalar

| Kod | Açıklama |
|-----|----------|
| `utf_8` | Evrensel (Çoklu dil) |
| `ascii` | Standart ASCII |
| `iso_8859_1` | Latin-1 (Batı Avrupa) |
| `iso_8859_9` | Latin-5 (Türkçe) |
| `iso_8859_5` | Kiril |
| `shift_jis` | Japonca |
| `gb2312` | Çince (Basitleştirilmiş) |

## 📤 Çıktı

Oluşturulan dosyalar şurada:
```
output/FontAdı_KODLAMA/
└── FontAdı_Boyut_KODLAMA.zi
```

Örnek: `output/Arial_ISO-8859-9/Arial_12_ISO-8859-9.zi`

