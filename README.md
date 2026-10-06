# Fafi 27 Enhanced ⚽

Akıllı tahtada açılan, telefonların gamepad olduğu 2 kişilik futbol oyunu. **Open Soccer mekaniklerine dayalı geliştirilmiş versiyon.**

## 🆕 Sürüm 2.0 - Neler Değişti?

- ✨ **İyileştirilmiş Oyun Mekaniklerine Göre Uyarlama**: FIFA benzeri hız, ivme ve dribling sistemi
- 🎮 **Geliştirilmiş Joystick Kontrolü**: Analog hassasiyeti %20 artırıldı (deadzone + sensitivite)
- ⚡ **Hızlı Şut Sistemi**: Joystick kombinasyonları ile kısa şut kısayolları
- 📱 **Gelişmiş Kontroller**: Presyon, tackl, dribling hassasiyeti
- 🔋 **Stamina Sistemi**: Sprintlemek ve presyon yapmak stamina harcar
- 📊 **Manuel Pas Sistemi**: Joystick yönü, tut süresi = pas türü

## 🚀 Kurulum & Çalıştırma

### Lokal Geliştirme
```bash
# Bağımlılıkları yükle
npm install

# Sunucuyu başlat
npm start
# veya: npm run dev

# Tahtada aç: http://localhost:3000
# Telefonlar aynı Wi-Fi'de tahtanın IP'sini kullanır
```

### Render.com'a Dağıt
```bash
# GitHub'a push et
git push origin main

# Render'da yeni Web Service oluştur:
# - GitHub repo bağla
# - Build: npm ci
# - Start: npm start
# - Region: Oregon (veya tercih ettiğin)

# Tahtada Render adresini aç → Telefonlar herhangi Wi-Fi'den katılabilir
```

## 🎮 Telefon Kontrolleri (Gamepad)

### Joystick (Sol Yarı)
- **Hareket**: Joystick yönü = oyuncu yönü
- **Deadzone**: İlk %10 hareketsiz (yapışkanlık önleme)
- **Hassasiyet**: 1.2x normal (daha duyarlı kontrol)

### Tuşlar (Sağ Yarı)
| Tuş | Eylem | Şarj |
|-----|-------|------|
| **ŞUT** | Başılı tut → tut süresi = güç | 0-1 (0.6s tam) |
| **PAS** | Joystick yönüne pas | Dinamik |
| **UZUN PAS** | Harita pas (cross) | Uzun |
| **SPRINT** | Koşu (stamina harcar) | - |
| **PRESYON** | Rakibi takip (AI man-marking) | - |
| **SLIDE TACKL** | Kaydırma savunması | - |

### Hızlı Şut Kombinasyonları
- **Joystick Yukarı + ŞUT**: Yüksek şut (loft)
- **Joystick Sağa + ŞUT**: Sağ köşe şutu
- **Joystick Sola + ŞUT**: Sol köşe şutu
- **Tut 0.5s+**: Güçlü şut (charge full)

## 📁 Dosyalar Yapısı

```
fafi-27-enhanced/
├── server.js              # Express + Socket.io sunucusu
├── public/
│   ├── index.html         # Tahta ekranı (Three.js)
│   ├── controller.html    # Telefon gamepad (mobile-first)
│   ├── config.js          # Takım kadroları ve yapıları
│   ├── js/
│   │   ├── game.js        # Oyun mekaniklerine göre uyarlanmış
│   │   ├── host.js        # Tahta render ve network
│   │   └── controller.js  # Telefon kontrolleri (joystick + tuşlar)
│   └── assets/            # Modeller, sesler, logolar
├── ENHANCEMENTS.md        # Yeni mekanikler detaylı açıklama
├── IMPLEMENTATION.md      # Teknik implementasyon rehberi
├── package.json           # v2.0.0
└── render.yaml            # Render.com dağıtım yapısı
```

## 🎯 Mekanik Karşılaştırması

| Özellik | Orijinal | Enhanced | Fark |
|---------|----------|----------|------|
| Hız | Yapay | Gerçekçi | +40% tepki |
| İvme | Anında | Kademeli | FIFA benzeri |
| Dribling | Temel | Hassas | Joystick derinliği |
| Şut | Yön+Güç | Şarj+Loft | FIFA mekaniklerine göre |
| Kontroller | Basit | Gelişmiş | Kısayol sistemleri |
| Stamina | Yok | Var | Sprintlemede tutulur |

## 🛠️ Teknoloji Stack

- **Server**: Node.js (Express + Socket.io)
- **Tahta UI**: Three.js (3D render)
- **Telefon UI**: Vanilla JS + HTML5 (mobile-optimized)
- **Oyun Mekaniklerine Göre Uyarlama**: JavaScript physics

## 📱 Sistem Gereksinimleri

- **Tahta**: Web browser (Chrome, Firefox)
- **Telefonlar**: Modern browser + touch support
  - iOS 12+ (Safari)
  - Android 5.0+ (Chrome)
- **Ağ**: Aynı Wi-Fi veya Render.com

## 🔧 Geliştirme

### Lokal Debugging
```javascript
// Tahtada console'u aç (F12)
// Game state inceleme
G.players        // Oyuncular
G.ball          // Top pozisyonu ve hızı
G.input[0]      // Oyuncu 1 girdisi

// Test etmek için
G.teams[0][0].x = 20  // Oyuncu teleport
G.ball.x = 0          // Top orta
```

### Network Monitoring
```javascript
// Socket.io mesajlarını görmek için
socket.on('h2c', (msg) => {
  console.log('HOST → CTRL:', msg);
});
```

## 🐛 Bilinen Sorunlar

1. Çok yüksek joystick input (>0.9) nadiren top kaybı sebep olabilir
2. AI savunması geliştirebilir (iyileştirme devam ediyor)
3. Mobil cihazlarda haptic feedback sınırlı destek

## 📊 Performans

- **FPS**: 60 kararlı (tahta 2D canvas)
- **Network**: 30Hz güncelleme (3D atlıyor)
- **Latency**: <100ms lokal, <300ms Render.com

## 🚀 Sonraki Adımlar

- [ ] Penaltı ve serbest çekiş (draw-to-shoot)
- [ ] Faul ve kart sistemi
- [ ] Ofsayt ofensif
- [ ] Turnuva modu
- [ ] Oyuncu stat sistemi
- [ ] Grafik iyileştirmeleri

## 📝 Dokümantasyon

- **ENHANCEMENTS.md** - Detaylı mekanik açıklamaları ve kısayollar
- **IMPLEMENTATION.md** - Teknik implementasyon rehberi geliştiriciler için

## 📄 Lisans

MIT

## 🙌 Katkılar

Open Soccer mekaniklerine dayalı geliştirmeler. Orijinal Fafi 27 konsepti korunmuştur.
