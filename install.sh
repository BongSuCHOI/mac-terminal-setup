#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# dotfiles installer
# Ghostty + fonts + zsh-autosuggestions + atuin
# Usage: curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
# ============================================================

BREW_PREFIX="$(brew --prefix)"
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
GHOSTTY_CONFIG="$GHOSTTY_CONFIG_DIR/config"
ATUIN_CONFIG_DIR="$HOME/.config/atuin"
ATUIN_CONFIG="$ATUIN_CONFIG_DIR/config.toml"
ZSHRC="$HOME/.zshrc"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
skip()  { echo -e "${YELLOW}[SKIP]${NC} $*"; }

# ------------------------------------------------------------
# 0. Homebrew check
# ------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "Homebrew가 설치되어 있지 않습니다. https://brew.sh 에서 먼저 설치하세요."
  exit 1
fi

# ------------------------------------------------------------
# 1. Ghostty
# ------------------------------------------------------------
info "Ghostty 확인 중..."
if brew list --cask ghostty &>/dev/null; then
  skip "Ghostty 이미 설치됨"
else
  info "Ghostty 설치 중..."
  brew install --cask ghostty
  ok "Ghostty 설치 완료"
fi

# ------------------------------------------------------------
# 2. Ghostty 설정
# ------------------------------------------------------------
info "Ghostty 설정 적용 중..."
mkdir -p "$GHOSTTY_CONFIG_DIR"

if [[ -f "$GHOSTTY_CONFIG" ]]; then
  cp "$GHOSTTY_CONFIG" "$GHOSTTY_CONFIG.bak.$(date +%Y%m%d%H%M%S)"
  info "기존 설정 백업: $GHOSTTY_CONFIG.bak.*"
fi

cat > "$GHOSTTY_CONFIG" <<'EOF'
theme = Dracula

font-family = "JetBrainsMono Nerd Font Mono"
font-family = "Noto Sans Mono CJK KR"
font-size = 12
adjust-cell-height = 1

# 레티나 보정
# font-thicken = false

# macOS 전용 최적화
macos-titlebar-style = transparent
macos-option-as-alt = left
macos-non-native-fullscreen = true

# Global Quick Open
keybind = global:cmd+grave_accent=toggle_quick_terminal

# 드래그시 바로 복사
copy-on-select = clipboard
EOF

ok "Ghostty 설정 완료"

# ------------------------------------------------------------
# 3. 폰트
# ------------------------------------------------------------
info "폰트 확인 중..."

if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
  skip "JetBrainsMono Nerd Font 이미 설치됨"
else
  info "JetBrainsMono Nerd Font 설치 중..."
  brew install --cask font-jetbrains-mono-nerd-font
  ok "JetBrainsMono Nerd Font 설치 완료"
fi

if brew list --cask font-noto-sans-mono-cjk-kr &>/dev/null; then
  skip "Noto Sans Mono CJK KR 이미 설치됨"
else
  info "Noto Sans Mono CJK KR 설치 중..."
  brew install --cask font-noto-sans-mono-cjk-kr
  ok "Noto Sans Mono CJK KR 설치 완료"
fi

# ------------------------------------------------------------
# 4. zsh-autosuggestions
# ------------------------------------------------------------
info "zsh-autosuggestions 확인 중..."

if brew list zsh-autosuggestions &>/dev/null; then
  skip "zsh-autosuggestions 이미 설치됨"
else
  info "zsh-autosuggestions 설치 중..."
  brew install zsh-autosuggestions
  ok "zsh-autosuggestions 설치 완료"
fi

# .zshrc 적용
AUTOSUGGESTIONS_LINE="source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if grep -qF "zsh-autosuggestions.zsh" "$ZSHRC" 2>/dev/null; then
  skip ".zshrc에 zsh-autosuggestions 이미 설정됨"
else
  {
    echo ""
    echo "# zsh-autosuggestions (회색 히스토리 제안)"
    echo "$AUTOSUGGESTIONS_LINE"
  } >> "$ZSHRC"
  ok ".zshrc에 zsh-autosuggestions 추가"
fi

# ------------------------------------------------------------
# 5. atuin
# ------------------------------------------------------------
info "atuin 확인 중..."

if command -v atuin &>/dev/null; then
  skip "atuin 이미 설치됨"
else
  info "atuin 설치 중..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
  ok "atuin 설치 완료"
fi

# atuin 설정
info "atuin 설정 적용 중..."
mkdir -p "$ATUIN_CONFIG_DIR"

if [[ -f "$ATUIN_CONFIG" ]]; then
  cp "$ATUIN_CONFIG" "$ATUIN_CONFIG.bak.$(date +%Y%m%d%H%M%S)"
  info "기존 atuin 설정 백업: $ATUIN_CONFIG.bak.*"
fi

cat > "$ATUIN_CONFIG" <<'EOF'
# 동기화 비활성 (비로그인, 로컬 전용)
auto_sync = false

# Enter로 즉시 실행
enter_accept = true

# 검색 모드: daemon-fuzzy
search_mode = "daemon-fuzzy"

[daemon]
enabled = true
autostart = true
EOF

ok "atuin 설정 완료 (비로그인, 동기화 끔, 데몬 활성, daemon-fuzzy)"

# .zshrc에 atuin init 확인
if grep -qF "atuin init zsh" "$ZSHRC" 2>/dev/null; then
  skip ".zshrc에 atuin 이미 설정됨"
else
  {
    echo ""
    echo '. "$HOME/.atuin/bin/env"'
    echo 'eval "$(atuin init zsh)"'
  } >> "$ZSHRC"
  ok ".zshrc에 atuin 추가"
fi

# ------------------------------------------------------------
# 완료
# ------------------------------------------------------------
echo ""
ok "모든 설정 완료!"
echo ""
echo "적용하려면:"
echo "  1. Ghostty 재시작 (폰트 반영)"
echo "  2. source ~/.zshrc (셸 설정 반영)"
echo ""
