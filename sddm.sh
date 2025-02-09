#!/usr/bin/env bash

set -e  # Exit on error

# Install SDDM
if command -v pacman &>/dev/null; then
    echo "Installing SDDM..."
    sudo pacman -S --noconfirm sddm
elif command -v apt &>/dev/null; then
    echo "Installing SDDM..."
    sudo apt install -y sddm
elif command -v dnf &>/dev/null; then
    echo "Installing SDDM..."
    sudo dnf install -y sddm
elif command -v zypper &>/dev/null; then
    echo "Installing SDDM..."
    sudo zypper in -y sddm
elif command -v xbps-install &>/dev/null; then
    echo "Installing SDDM..."
    sudo xbps-install -Sy sddm
else
    echo "Unsupported package manager. Install SDDM manually."
    exit 1
fi

# Enable SDDM
sudo systemctl enable sddm

# Configure SDDM to use bspwm
mkdir -p ~/.xsession

cat <<EOF > ~/.xsession
#!/usr/bin/env bash
exec bspwm
EOF
chmod +x ~/.xsession

if [ ! -f /usr/share/xsessions/bspwm.desktop ]; then
    echo "Creating BSPWM session file..."
    sudo tee /usr/share/xsessions/bspwm.desktop > /dev/null <<EOL
[Desktop Entry]
Name=BSPWM
Comment=Lightweight Tiling Window Manager
Exec=bspwm
TryExec=bspwm
Type=Application
EOL
fi

echo "SDDM is installed and configured for BSPWM. Reboot to apply changes."
