# 🚀 GitHub'a Upload Talimatları

Bu repo'yu yeni bir GitHub repository'sine yüklemek için aşağıdaki adımları izle.

## 1️⃣ GitHub'da Yeni Repository Oluştur

1. **github.com**'a git
2. **+** tuşuna tıkla → **New repository**
3. **Repository name**: `fafi-27` (veya istediğin ad)
4. **Description**: "Fafi 27 Enhanced - Smart board + mobile gamepad football game"
5. **.gitignore**: Python seç (biz zaten ekledik ama)
6. **License**: MIT (isteğe bağlı)
7. **Create repository** tuşuna tıkla

## 2️⃣ Lokal Git Kurulum

Bu klasörde (zaten Git initialize edilmiş):

```bash
# Repository URL'ini ekle (SENIN-USERNAME'i değiştir)
git remote add origin https://github.com/SENIN-USERNAME/fafi-27.git

# Branch'ı master'dan main'e değiştir (opsiyonel ama tavsiye edilir)
git branch -M main

# Push et
git push -u origin main
```

## 3️⃣ Render.com'a Yükleme

1. **render.com** 'e git → Sign up/Login
2. **Dashboard** → **New +** → **Web Service**
3. **Connect a repository** → GitHub hesabını bağla
4. **Repository seç**: fafi-27
5. **Build Command**: `npm ci`
6. **Start Command**: `npm start`
7. **Environment Variables**:
   - `NODE_ENV`: production
   - `PORT`: 3000 (opsiyonel)
8. **Create Web Service** tuşuna tıkla

**Tahtada Açmak İçin**: Render'dan verilen URL'yi al → Tahtada aç

## 🔄 Sonraki Güncellemeler

Dosyaları düzenledikten sonra:

```bash
git add .
git commit -m "Açıklamalı mesaj yazılır"
git push
```

Render otomatik olarak redeploy eder.

## 📋 Commit İsimleri İyi Pratikleri

```bash
# Mekanik iyileştirmesi
git commit -m "feat: improve dribbling sensitivity"

# Bug fix
git commit -m "fix: joystick deadzone issue"

# Dokümantasyon
git commit -m "docs: update QUICKSTART guide"

# Performance
git commit -m "perf: optimize player physics calculations"
```

## 🆘 Sorun Çözüm

### "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/SENIN-USERNAME/fafi-27.git
```

### "Permission denied (publickey)"
SSH key ekle veya HTTPS kullan:
```bash
git remote set-url origin https://github.com/SENIN-USERNAME/fafi-27.git
```

### GitHub'da Push yapamıyorum
```bash
# Git kimliğini kontrol et
git config user.email
git config user.name

# Değiştir (lazımsa)
git config --global user.email "senin-email@example.com"
git config --global user.name "Senin Adın"
```

## 📝 Notlar

- `.gitignore` dosyası `node_modules/` ve `.env` dosyalarını Git'ten dışlar
- `package-lock.json` versionlama için repo'da kalmalı
- `public/assets/` klasöründe büyük dosyalar var ama Git yönetebilir

---

**Başlattığında haber ver! 🎮**
