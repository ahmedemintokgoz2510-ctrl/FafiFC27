#!/bin/bash
# Fafi 27 - GitHub'a Push Script
# Kullanım: bash PUSH_TO_GITHUB.sh

echo "🚀 Fafi 27 - GitHub'a Push"
echo "================================"

# Kullanıcıdan GitHub username iste
read -p "GitHub username'ini gir: " GITHUB_USER
read -p "Repository adını gir (varsayılan: fafi-27): " REPO_NAME
REPO_NAME=${REPO_NAME:-fafi-27}

# Git konfigürasyonu
git config --global user.email "seni-email@example.com"
git config --global user.name "Senin Ad"

# Remote URL oluştur
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "📝 Kurulum Bilgileri:"
echo "  - GitHub User: $GITHUB_USER"
echo "  - Repository: $REPO_NAME"
echo "  - URL: $REMOTE_URL"
echo ""

# Branch'ı main'e değiştir
echo "🔄 Branch'ı main'e değiştir..."
git branch -M main

# Remote ekle
echo "📌 Remote repository ekle..."
git remote add origin "$REMOTE_URL" 2>/dev/null || git remote set-url origin "$REMOTE_URL"

# Push et
echo "📤 GitHub'a push ediliyor..."
git push -u origin main

echo ""
echo "✅ TAMAMLANDI!"
echo ""
echo "Sonraki Adımlar:"
echo "1. GitHub'da fafi-27 repository'sini aç"
echo "2. render.com'a git"
echo "3. New Web Service oluştur"
echo "4. GitHub repository'sini bağla"
echo "5. Deploy et!"
echo ""
