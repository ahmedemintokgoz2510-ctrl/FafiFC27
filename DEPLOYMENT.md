# 🚀 Fafi 27 - Tam Deployment Rehberi

GitHub'dan Render.com'a yüklemek için adım adım talimatlar.

## 📋 Ön Koşullar

- GitHub hesabı (github.com)
- Render.com hesabı (render.com)
- Komut satırı erişimi (Terminal/PowerShell)

---

## 1️⃣ GitHub Repository Oluşturma

### Adım 1: GitHub'da Yeni Repo Oluştur
```
1. github.com → Sign in
2. Profile → Your repositories → New
3. Repository name: fafi-27
4. Description: "Fafi 27 Enhanced - Smart board football game"
5. Public (herkes görebilir)
6. Create repository ✓
```

### Adım 2: Lokal Repo'yu GitHub'a Push Et

Bilgisayarında Terminal/PowerShell aç ve şu komutu çalıştır:

```bash
# Bu klasöre git
cd /path/to/fafi-27-repo

# Git remote'u ekle (SENIN-USERNAME'i değiştir)
git remote add origin https://github.com/SENIN-USERNAME/fafi-27.git

# Branch'ı main'e değiştir
git branch -M main

# GitHub'a push et
git push -u origin main
```

**Hata alırsan:**
```bash
# Remote varsa sil
git remote remove origin

# Tekrar ekle
git remote add origin https://github.com/SENIN-USERNAME/fafi-27.git
git push -u origin main
```

---

## 2️⃣ Render.com Deployment

### Adım 1: Render Hesabına Git
```
1. render.com → Sign up (GitHub ile giriş yapabilirsin)
2. Email doğrula
3. Dashboard'a git
```

### Adım 2: GitHub'ı Bağla
```
1. Dashboard sağ üst → Account → GitHub connections
2. "Connect GitHub account"
3. Authorize render
4. fafi-27 repository'sini select et (authorize)
```

### Adım 3: Web Service Oluştur
```
1. Dashboard → + New → Web Service
2. GitHub seç
3. fafi-27 repository'sini seç
4. Sonraki sayfada:
   - Name: fafi-27 (veya istediğin ad)
   - Environment: Node
   - Region: Oregon (veya yakın bölge)
   - Build Command: npm ci
   - Start Command: npm start
   - Advanced → Environment Variables ekle:
     * KEY: NODE_ENV
     * VALUE: production
5. Create Web Service ✓
```

### Adım 4: Deploy Bekle
```
- Render otomatik build başlatacak
- Logs'da "live" yazısını göreceksin
- URL verilecek (örn: https://fafi-27.onrender.com)
```

---

## 3️⃣ Test Et

### Tahta
```
Tarayıcıda: https://fafi-27.onrender.com
```

### Telefon
```
Aynı bağlantıyı Android/iOS'da aç veya
QR kodu tara
```

---

## 🔄 Güncelleme Yapma

Lokal olarak değişiklik yaptıktan sonra:

```bash
# Değişiklikleri stage et
git add .

# Commit et (açıklayıcı mesaj yaz)
git commit -m "feat: improve shooting mechanics"

# Push et
git push
```

**Render otomatik olarak:**
1. GitHub'dan yeni kodu çeker
2. npm ci çalıştırır (bağımlılıkları yükler)
3. npm start çalıştırır (sunucu başlatır)
4. Deploy tamamlanır (~2-3 dakika)

---

## 📊 Status Kontrol

### Render Dashboard'da
- **Building**: Kod alınıyor ve derleniyor
- **Live**: Sunucu çalışıyor
- **Failed**: Hata oluştu (Logs'u kontrol et)

### Logs Bakma
```
1. Render Dashboard → fafi-27 service
2. Logs sekmesi
3. Son 100 satır gösterilir
4. Hata varsa kırmızı renkli
```

---

## 🛠️ Sorun Çözüm

### "Build Failed" Hatası

**Muhtemel Sebebi**: `package.json`'da hata

```bash
# Lokal test et
npm install
npm start

# Hata varsa düzelt ve push et
git add .
git commit -m "fix: package.json"
git push
```

### "Port Already in Use"

Render otomatik port kullanır (3000). Sorun değil.

### "Connection Timeout"

```bash
# Render health check'ini kontrol et
1. Settings → Health Check Path: /
2. Health Check Interval: 30
3. Timeout: 10
```

### Telefon Bağlantı Sorunu

```
1. Tahtada Render URL açmış mı?
2. Telefon aynı kodu taradı mı?
3. İnternet bağlantısı var mı?
4. Render logs'da hata yok mu?
```

---

## 💰 Fiyatlandırma (Render Free)

| Feature | Free | Ücretli |
|---------|------|---------|
| Apps | 2 | Unlimited |
| Traffic | 100 GB/ay | Unlimited |
| Sleep | Boş 15 dakika | - |
| Deployment | ✓ | ✓ |
| Custom Domain | ✗ | ✓ |

**Ücretsiz plan**: Boş 15 dakika tuttuğunda standby moduna girer. İstek gelince 50 saniyede uyanır.

---

## 🔐 Güvenlik

### Render Secret Ekle
```bash
# Token veya API key kullanacaksan
1. Render Dashboard → Settings → Environment
2. Add Variable
3. KEY: TOKEN_NAME
4. VALUE: secret-key-here
5. Deploy et
```

### GitHub Secret
```bash
# GitHub Actions kullanacaksan
1. GitHub → Settings → Secrets and variables
2. New repository secret
3. Deploy workflow oluştur
```

---

## 📝 Production Checklist

- [ ] `package.json` doğru version numarasında
- [ ] `node_modules` `.gitignore`'da
- [ ] `.env` dosyası örneği doc'unda
- [ ] README.md güncelleme
- [ ] Logs'ta hata yok
- [ ] Tahtada URL çalışıyor
- [ ] Telefondan QR tara ve test et
- [ ] Render domain'ini kaydet

---

## 🎯 Sonraki Adım

### Custom Domain (Opsiyonel)
```
1. Render Dashboard → fafi-27
2. Settings → Custom Domain
3. Kendi domain'ini ekle (ücretli)
4. DNS ayarlarını güncelle
```

---

## 📞 Yardım

**Render Support**: https://render.com/docs  
**GitHub Help**: https://docs.github.com  
**Fafi 27 Docs**: README.md → QUICKSTART.md

---

**Başarılar! 🎮⚽**
