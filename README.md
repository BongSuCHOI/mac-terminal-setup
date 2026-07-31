# mac-terminal-setup

macOS 터미널 환경을 한 번에 설정하는 설치 스크립트입니다.

## 포함 내용

| 항목 | 설명 |
|---|---|
| [Ghostty](https://ghostty.org) | GPU 가속 터미널 에뮬레이터 |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com) | 영문·숫자·아이콘 코딩 폰트 |
| [Noto Sans Mono CJK KR](https://fonts.google.com/noto) | 한글 고정폭 폰트 (fallback) |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | 회색 히스토리 자동 제안 |
| [atuin](https://atuin.sh) | 히스토리 검색 (비로그인, 로컬 전용) |
| [herdr](https://herdr.dev) | AI 에이전트 멀티플렉서 (tmux 대체) |

## 설치

```bash
curl -fsSL https://raw.githubusercontent.com/BongSuCHOI/mac-terminal-setup/main/install.sh | bash
```

또는 직접 실행:

```bash
git clone https://github.com/BongSuCHOI/mac-terminal-setup.git
cd mac-terminal-setup
./install.sh
```

## Ghostty 설정

```
theme = Dracula

font-family = "JetBrainsMono Nerd Font Mono"
font-family = "Noto Sans Mono CJK KR"
font-size = 12
adjust-cell-height = 1

macos-titlebar-style = transparent
macos-option-as-alt = left
macos-non-native-fullscreen = true

keybind = global:cmd+grave_accent=toggle_quick_terminal
copy-on-select = clipboard
```

- 영문·숫자·아이콘: JetBrainsMono Nerd Font Mono
- 한글: Noto Sans Mono CJK KR (fallback)
- `Cmd+`` 로 퀵 터미널 토글
- 드래그 선택 시 자동 클립보드 복사

## atuin 설정

- 비로그인, 동기화 비활성 (로컬 전용)
- 데몬 활성화
- 검색 모드: daemon-fuzzy

## herdr 설정

- 테마: terminal (호스트 터미널 색상 상속)
- 프리픽스: `Ctrl+;`
- 에이전트 세션 복원 활성화
- Kitty graphics, pane history, CJK IME 프리픽스 전환 (experimental)

## 요구 사항

- macOS
- [Homebrew](https://brew.sh)

## 참고

- 모든 단계는 멱등(idempotent)합니다. 이미 설치된 항목은 건너뜁니다.
- 기존 Ghostty/atuin/herdr 설정은 실행 전 자동 백업됩니다.
