#!/usr/bin/env bash
set -eu
VER="${TERRAFORM_VERSION:-1.14.7}"
INSTALL_DIR="${HOME}/.local/bin"
TMP="${TMPDIR:-/tmp}/terraform-install-$$"

mkdir -p "$TMP" "$INSTALL_DIR"
ZIP="$TMP/terraform_${VER}_linux_amd64.zip"
curl -fsSL -o "$ZIP" "https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip"

if command -v unzip >/dev/null 2>&1; then
  unzip -o "$ZIP" -d "$TMP"
else
  python3 -c "import zipfile; zipfile.ZipFile('$ZIP').extractall('$TMP')"
fi

mv -f "$TMP/terraform" "$INSTALL_DIR/terraform"
chmod +x "$INSTALL_DIR/terraform"
rm -rf "$TMP"

if ! grep -q '\.local/bin' "${HOME}/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "${HOME}/.bashrc"
fi

export PATH="$INSTALL_DIR:$PATH"
echo "Installed: $(command -v terraform)"
terraform version
