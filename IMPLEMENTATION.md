# Fafi 27 Enhanced - İmplementasyon Rehberi

## 🚀 Başlangıç

### Kurulum
```bash
# Bağımlılıkları yükle
npm install

# Geliştirme sunucusunu başlat
npm run dev

# Üretim build'i
npm run build
```

### Render.com Dağıtım
```yaml
# render.yaml ayarları otomatiktir
# Komutlar npm run dev kullanır
# Port: 3000 (tüm arayüzlerde)
```

## 🎮 Oyun Mekaniklerine Göre Değişiklikler

### 1. Hareket Sistemi (game.js L14-19)

**Eski Sistem:**
```javascript
const paceFactor = 0.82 + (p.pace / 100) * 0.46;
const sp = 6.4 * paceFactor * (canSprint ? 1.42 : chasesBall ? 1.1 : 1) ...
```

**Yeni Sistem:**
```javascript
const WALK_SPEED = 6;           // Temel hız
const SPRINT_SPEED = 11;        // Koşu hızı  
const DRIBBLE_SPEED = 7;        // Top kontrol hızı
const ACCEL = 2.5;              // Standart ivme
const DRIBBLE_ACCEL = 1.8;      // Dribling ivmesi

// humanStep() fonksiyonunda
const isSprintable = inp.sprint && p.stamina > 0.08;
const isDribbling = B.owner === p;
const currentMaxSpeed = isDribbling ? DRIBBLE_SPEED : SPRINT_SPEED;
const accelRate = isDribbling ? DRIBBLE_ACCEL : ACCEL;

accel(p, dx, dz, dt, accelRate);
```

**Etkiler:**
- Dribling sırasında oyuncu daha yavaş hareket eder (kontrol vs hız)
- İvme kademeli, daha oyuncu dostu (FIFA benzeri)
- Koşu daha hızlı, şarj mekaniklerine uygun

### 2. Joystick Kontrol Sistemi (controller.js L10-20)

**Yeni Bileşenler:**

```javascript
// Joystick hassasiyeti
let joystickX = 0;
let joystickY = 0;
let joystickSensitivity = 1.2;  // 20% ekstra hassasiyet
let deadzone = 0.1;              // Yapışkanlık önleme

// Dokunma event işleyicisi (UI)
const touchListener = (e) => {
  const touch = e.touches[0];
  const rect = joystickBase.getBoundingClientRect();
  
  // Joystick merkezinden uzaklık
  const dx = touch.clientX - (rect.left + rect.width / 2);
  const dy = touch.clientY - (rect.top + rect.height / 2);
  const dist = Math.hypot(dx, dy);
  const maxDist = rect.width / 2;
  
  // Deadzone kontrol
  if (dist < maxDist * deadzone) {
    joystickX = joystickY = 0;
  } else {
    const normalized = Math.min(dist, maxDist) / maxDist;
    joystickX = (dx / dist) * normalized * joystickSensitivity;
    joystickY = (dy / dist) * normalized * joystickSensitivity;
  }
};
```

**Sunucuya Gönderilen Format:**
```javascript
socket.emit('c2h', {
  t: 'mv',
  x: joystickX,        // -1.2 ... 1.2 (hassasiyet ile)
  y: joystickY,
  charge: chargeTime   // Şut/pas şarjı (0-1)
});
```

### 3. Şut Sistemi (game.js L232-255)

**Hızlı Şut Kombinasyonları:**

```javascript
// Joystick + SHOOT tuşu kombinasyonları
const handleQuickShot = (joystickDir, chargeTime) => {
  // Joystick yukarı = Yüksek şut (loft)
  if (joystickDir.y > 0.6 && chargeTime > 0.2) {
    doShoot(p, chargeTime, false, true);  // loft=true
  }
  // Joystick sağa = Sağ köşe şutu
  else if (joystickDir.x > 0.6 && chargeTime > 0.25) {
    const targetZ = Math.min(2, GW - 1);
    aimAtGoal(p, joystickDir.x, targetZ, chargeTime);
  }
  // Joystick sola = Sol köşe şutu
  else if (joystickDir.x < -0.6 && chargeTime > 0.25) {
    const targetZ = Math.max(-2, -GW + 1);
    aimAtGoal(p, joystickDir.x, targetZ, chargeTime);
  }
  // Standart şut
  else {
    doShoot(p, chargeTime, false);
  }
};
```

**Şarj Mekaniklerine Göre Şut Gücü:**

```javascript
function doShoot(p, charge, ai, loft = false, acro = false) {
  // charge = 0-1 (0 = vuruş yok, 1 = tam şarj)
  const baseSpeed = air ? 21 + 14 * charge : 27 + 25 * charge;
  // 27 m/s (vuruş yok) → 52 m/s (tam şarj)
  
  // Aşırı şarj: top üzerine fırlatılır
  const over = Math.max(0, charge - 0.88) / 0.12;  // 88% sonrası aktif
  const lift = air ? 5.5 + charge * 4.5 : 0.7 + charge * 1.7 + over * 6;
}
```

### 4. Pas Mekaniklerine Göre Uyarlanmış Kontroller

**Manuel Pas Sistemi:**

```javascript
// Joystick yönü pas yönü belirler
function doPass(p, dx, dz, charge) {
  const distance = Math.hypot(dx, dz);
  
  // Pas kategorileri
  if (charge < 0.3) {
    // Kısa pas (2-8m)
    speed = clamp(distance * 0.8 + 6, 6, 10);
  } else if (charge < 0.6) {
    // Orta pas (8-15m)
    speed = clamp(distance * 0.5 + 10, 10, 16);
  } else {
    // Uzun pas (15m+)
    speed = clamp(distance * 0.3 + 16, 16, 25);
  }
  
  kick(p, dx, dz, speed, aimError, lift);
}
```

**Otomatik Pas Hedefleme:**
```javascript
// Joystick aşağı + PASS = Kanat oyuncuya pas (cross)
function doCross(p, chargeTime) {
  const targetZ = Math.sign(p.z || 1) * 12;  // Kanat tarafı
  const receiver = findNearestTeammate(p, 
    p.dir * (HL - 10),  // Ceza sahasına yakın
    targetZ
  );
  
  if (receiver) {
    const speed = 18 + chargeTime * 8;
    kick(p, receiver.x - p.x, receiver.z - p.z, speed, 0.01, 6);
    B.target = receiver;
  }
}
```

### 5. Dribling Hassasiyeti

**Joystick Modülasyonu:**

```javascript
function updateDribling(p, joystickDir, dt) {
  // Dribling hız kontrolü
  const joystickMagnitude = Math.hypot(joystickDir.x, joystickDir.y);
  
  if (B.owner === p && joystickMagnitude > deadzone) {
    // Tam joystick = Yüksek hız (7 m/s)
    // %50 joystick = Kontrollü hız (4 m/s)
    const dribbleSpeed = 3 + joystickMagnitude * 4;
    
    // İvme DRIBBLE_ACCEL ile sınırlandırılır
    accel(p, 
      joystickDir.x * dribbleSpeed,
      joystickDir.y * dribbleSpeed,
      dt,
      DRIBBLE_ACCEL  // Daha düşük ivme = kontrollü tepki
    );
  }
}
```

**Top Yakınlığı Kontrolü:**
```javascript
// Ball ownership distance
const BALL_CONTROL_DIST = 1.8;  // Meter
const BALL_LOSS_DIST = 2.5;

// Update'te kontrol
if (B.owner === p) {
  if (dist(p, B) > BALL_LOSS_DIST) {
    B.owner = null;  // Top kaybı
  }
}
```

### 6. Presyon Sistemi (Pressure)

```javascript
function handlePressure(p, inp) {
  if (inp.pressure && B.owner && B.owner.team !== p.team) {
    // Presyon tuşu basılı tutulurken
    // Rakip oyuncuya man-marking
    const target = B.owner;
    const dist = Math.hypot(p.x - target.x, p.z - target.z);
    
    // Presyonlu koşu hızı
    const pressSpeed = SPRINT_SPEED * 1.15;  // %15 daha hızlı
    
    // Stamina tüketimi
    p.stamina -= 0.15 * dt;  // Normale göre 1.5x daha hızlı
    
    // AI presyon grubu (2-3 oyuncu)
    if (G.pressers[p.team].length < 3) {
      G.pressers[p.team].push(getNearestTeammate(p));
    }
  }
}
```

### 7. Tackl Sistemi

**Ayakkabı Çıkıp Kaydırma:**

```javascript
function handleSlide(p, joystickDir, dt) {
  if (inputSlidePressed && p.slideCooldown <= 0) {
    // Kaydırma başlat
    p.slideT = 0;
    p.slideDuration = 0.6;  // 600ms
    p.slideCooldown = 1.2;  // 1.2s sonra tekrar yapılabilir
    
    // Kaydırma yönü joystick'ten gelir
    const slideDir = Math.atan2(joystickDir.y, joystickDir.x);
    p.slideX = Math.cos(slideDir) * 8;  // 8 m/s kaydırma hızı
    p.slideZ = Math.sin(slideDir) * 8;
    
    // Top yakınsa kaynama ihtimali
    if (dist(p, B) < 3 && B.owner) {
      const hitChance = Math.random();
      if (hitChance > 0.3) {  // %70 başarı
        B.owner = null;  // Topu alıyor
      }
    }
  }
}
```

## 📱 Telefon Kontrol Yapısı

### Socket Mesaj Formatı

```javascript
// Hareket mesajı (30Hz)
socket.emit('c2h', {
  t: 'mv',
  x: joystickX,         // -1.2 ... 1.2
  y: joystickY,
  charge: chargeTime,   // 0-1 (şut/pas şarjı)
});

// Şut/Pas tuşu (süreklı)
socket.emit('c2h', {
  t: 'shoot' | 'pass',  // Tuş
  dir: { x, y }         // Joystick yönü
});

// Özel hareket
socket.emit('c2h', {
  t: 'sprint',
  on: boolean           // Koşu açık/kapalı
});

socket.emit('c2h', {
  t: 'pressure',
  on: boolean           // Presyon açık/kapalı
});

socket.emit('c2h', {
  t: 'slide',           // Kaydırma başlat
  dir: { x, y }
});
```

### Host.js Uygulaması

```javascript
// controller.js'den gelen mesaj
socket.on('c2h', (msg) => {
  const p = G.ctrl[msg.team];  // Kontrol edilen oyuncu
  
  if (msg.t === 'mv') {
    // Oyuncu hareketi
    G.input[msg.team] = {
      x: msg.x,
      z: msg.y,
      charge: msg.charge,
      sprint: msg.sprint || false,
      pressure: msg.pressure || false
    };
  } else if (msg.t === 'shoot') {
    // Şut tuşu
    if (!tryVolley(p)) {  // Önce vole kontrol et
      // Düzenli şut
      doShoot(p, msg.charge || 0.5);
    }
  }
});
```

## 📊 Performans Optimizasyonları

### 1. Frame Budget (60 FPS)
- **Güncelleme**: 8.3ms/frame
- **Render**: 8.3ms/frame (3D atlıyor)
- **Network**: 30Hz (33ms)

### 2. Fizik Optimizasyonu
```javascript
// Sadece gerekli oyunculara güncelleme
function updatePlayers(dt) {
  // İnsan oyuncu (P1 + AI)
  for (const p of G.teams[0]) humanStep(p, dt);
  
  // CPU oyuncu (P2)
  for (const p of G.teams[1]) aiStep(p, dt);
  
  // Top fizik
  updateBall(dt);
}
```

### 3. Network Optimizasyonu
```javascript
// Durumu sıkıştırırız
const compressState = (G) => {
  const players = G.players.map(p => ({
    x: Math.round(p.x * 100),   // 0.01m duyarlılık
    z: Math.round(p.z * 100),
    v: Math.round(Math.hypot(p.vx, p.vz) * 10),  // Hız
  }));
  
  return { players, score: G.score, time: G.time };
};
```

## 🔧 Debugging

### Console Komutu (Tahtada)
```javascript
// Game state inceleme
window.G  // Tüm oyun durumu

// Oyuncu hız kontrol
G.players[0].vx, G.players[0].vz

// Top konumu
G.ball  // { x, y, z, vx, vy, vz }

// Giriş vektörü
G.input[0]  // { x, z, charge, sprint, pressure }
```

### Mesaj Loglama
```javascript
// Server side
const gameLogger = (event) => {
  if (event.type === 'goal') {
    console.log(`GÖL! Takım ${event.team}, Oyuncu #${event.player}`);
  }
};
```

## 🚨 Bilinen Limitasyonlar

1. **Dribling Hassasiyeti**: Çok yüksek joystick değeri (>0.9) top kaybına sebep olabilir
2. **Takl Mekaniklerine Göre Uyarlama**: Henüz tamamen implementasyon yok
3. **AI Geliştirilmesi**: CPU savunması iyileştirilebilir
4. **Haptic Feedback**: İOS'ta sınırlı destek

## 🎯 Sonraki Adımlar

1. ✅ Oyun mekaniklerine göre uyarlama
2. ⚙️ AI savunması geliştirilmesi
3. ⚙️ Grafik optimizasyonu
4. 🔮 Turnuva modu
5. 🔮 Oyuncu statsları sistemi

---

**Son Güncelleme:** 2026-10-06  
**Versiyon:** 2.0 Enhanced
