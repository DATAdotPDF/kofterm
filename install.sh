#!/usr/bin/env bash
# KofTerm — instalador (bootstrap).
#
# Este é o único arquivo em Bash do projeto: ele só garante que o KOF existe, compila o KofTerm
# e chama `kofterm install`, que faz o resto em KOF (copia o programa, o índice e o corpus para
# ~/.local/share/kofterm e cria o comando ~/.local/bin/kofterm).
#
# Uso:  ./install.sh          (pergunta antes de baixar o KOF, se ele faltar)
#       ./install.sh --yes    (não pergunta)
set -euo pipefail

KOF_VERSION="0.6.6"
# SHA-256 da release oficial kof-0.6.6-linux-x86_64.tar.gz (github.com/KofLang/Kof4j),
# fixado aqui para não depender só do arquivo de somas baixado do mesmo lugar.
KOF_SHA256="96dd0d804c02e1e0f066dc0b53a4b1c385595d32820d97aeb77bb5dc772296f6"
KOF_URL="https://github.com/KofLang/Kof4j/releases/download/kof-${KOF_VERSION}-linux-x86_64/kof-${KOF_VERSION}-linux-x86_64.tar.gz"

cd "$(dirname "$0")"

if [ "$(uname -s)-$(uname -m)" != "Linux-x86_64" ]; then
  echo "O KofTerm precisa de Linux x86_64 (este sistema: $(uname -s) $(uname -m))." >&2
  exit 1
fi

KOF="$(command -v kof || true)"
if [ -z "$KOF" ] && [ -x "$HOME/.local/share/kof/bin/kof" ]; then
  KOF="$HOME/.local/share/kof/bin/kof"
fi

if [ -z "$KOF" ]; then
  echo "O KOF ${KOF_VERSION} não foi encontrado."
  echo "Vou baixar a release oficial (cerca de 370 MB, inclui o próprio Java) de:"
  echo "  ${KOF_URL}"
  echo "e conferir o SHA-256 antes de instalar em ~/.local/share/kof."
  if [ "${1:-}" != "--yes" ]; then
    read -r -p "Continuar? [s/N] " answer
    case "$answer" in s|S|sim|y|Y) ;; *) echo "Cancelado."; exit 1 ;; esac
  fi
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fL --progress-bar -o "$tmp/kof.tar.gz" "$KOF_URL"
  echo "${KOF_SHA256}  $tmp/kof.tar.gz" | sha256sum -c -
  mkdir -p "$HOME/.local/share" "$HOME/.local/bin"
  tar -xzf "$tmp/kof.tar.gz" -C "$HOME/.local/share"
  rm -rf "$HOME/.local/share/kof"
  mv "$HOME/.local/share/kof-${KOF_VERSION}-linux-x86_64" "$HOME/.local/share/kof"
  ln -sf "$HOME/.local/share/kof/bin/kof" "$HOME/.local/bin/kof"
  KOF="$HOME/.local/share/kof/bin/kof"
fi

echo "Compilando o KofTerm com $("$KOF" info 2>/dev/null | head -1 || echo kof)..."
"$KOF" build src --target native --output build/kofterm > build.log 2>&1 || { cat build.log >&2; exit 1; }
rm -f build.log
./build/kofterm/Default/Main install
