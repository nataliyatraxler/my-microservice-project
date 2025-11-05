#!/usr/bin/env bash
set -euo pipefail

log()  { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*" >&2; }
err()  { printf "[ERR]  %s\n" "$*" >&2; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }
need_sudo() { [ "$(id -u)" -ne 0 ] && echo sudo || echo ""; }

ver_ge() { [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)" = "$1" ]; }

OS="$(uname -s)"
DISTRO="unknown"; PKG_MGR=""
if [ "$OS" = "Darwin" ]; then
  DISTRO="macos"
elif [ -f /etc/os-release ]; then
  . /etc/os-release
  case "${ID_LIKE:-$ID}" in
    *debian*|*ubuntu*) DISTRO="debian"; PKG_MGR="apt" ;;
    *rhel*|*fedora*|*centos*) DISTRO="rhel"; PKG_MGR="$(have_cmd dnf && echo dnf || echo yum)" ;;
    *arch*) DISTRO="arch"; PKG_MGR="pacman" ;;
    *suse*) DISTRO="suse"; PKG_MGR="zypper" ;;
  esac
fi

SUDO="$(need_sudo)"

install_docker() {
  if ! have_cmd docker; then
    case "$DISTRO" in
      debian) $SUDO apt-get update -y && $SUDO apt-get install -y docker.io docker-compose-plugin ;;
      rhel)   $SUDO "$PKG_MGR" -y install docker docker-compose-plugin || $SUDO "$PKG_MGR" -y install moby-engine moby-compose ;;
      arch)   $SUDO pacman -Sy --noconfirm docker docker-compose ;;
      suse)   $SUDO zypper install -y docker docker-compose ;;
      macos)
        have_cmd brew || { err "Install Homebrew first: https://brew.sh"; exit 1; }
        brew list --cask docker >/dev/null 2>&1 || brew install --cask docker
        ;;
      *) err "Unsupported system"; exit 1 ;;
    esac
  fi
  if [ "$OS" != "Darwin" ] && have_cmd systemctl; then
    $SUDO systemctl enable docker || true
    $SUDO systemctl start docker || true
  fi
}

install_python() {
  local py_ver=""
  if have_cmd python3; then py_ver="$(python3 -V | awk '{print $2}')"; fi
  if [ -z "$py_ver" ] || ! ver_ge "$py_ver" "3.9"; then
    case "$DISTRO" in
      debian) $SUDO apt-get install -y python3 python3-pip python3-venv ;;
      rhel)   $SUDO "$PKG_MGR" -y install python3 python3-pip ;;
      arch)   $SUDO pacman -Sy --noconfirm python python-pip ;;
      suse)   $SUDO zypper install -y python3 python3-pip ;;
      macos)  brew install python@3.11 ;;
      *) err "Cannot install Python automatically"; exit 1 ;;
    esac
  fi
  # pip апдейт: на Linux ок, на macOS пропускаем (PEP 668)
  if [ "$DISTRO" != "macos" ]; then
    python3 -m pip install --user --upgrade pip || true
  fi
}

install_django() {
  if [ "$DISTRO" = "macos" ]; then
    # из-за PEP 668 ставим Django в venv
    VENV="${HOME}/.venvs/devtools"
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install "Django>=4.2"
    echo "$VENV" > "${HOME}/.venvs/.last_devtools_venv"
    DJANGO_PY="$VENV/bin/python"
    "$DJANGO_PY" -m django --version >/dev/null
    log "Django installed in venv: $VENV"
  else
    python3 -m pip install --user "Django>=4.2"
  fi
}

log "System detected: $DISTRO"
install_docker
install_python
install_django

log "Versions:"
docker --version || warn "docker not found"
(docker compose version || docker-compose --version) 2>/dev/null || warn "compose not found"
python3 -V

if [ "$DISTRO" = "macos" ] && [ -f "${HOME}/.venvs/.last_devtools_venv" ]; then
  VENV="$(cat "${HOME}/.venvs/.last_devtools_venv")"
  "$VENV/bin/python" -m django --version
  log "Activate with: source \"$VENV/bin/activate\""
else
  python3 -m django --version || warn "django not found in system python"
fi

log "Done."

