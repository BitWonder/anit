set -e # exit on error

# Color Constants
RESET_COLOR="\033[0m"
BLUE="\033[0;34m"

# make sure that the system is up todate
printf "${BLUE}Updating System:${RESET_COLOR}\n"
sudo pacman -Syu

# install git so we can install things from github
printf "\n${BLUE}Installing Git:${RESET_COLOR}\n"
sudo pacman -S git

# install paru for package managment
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

if ! command -v paru >/dev/null 2>&1; then
  printf "The making of paru failed! Exiting!"
  exit 1
fi

cd ..
# scary
rm -rf paru/

# install hyprland
paru -S hyprland hypridle hyprpaper hyprpicker hyprlock xdg-desktop-portal-hyprland hyprsunset hyprpolkitagent hyprsysteminfo hyprland-qt-support hyprqt6engine hyprcursor hyprutils hyprlang hyprwayland-scanner aquamarine hyprgraphics hyprland-qtutils

# install audio
paru -S pipewire
sudo systemctl enable pipewire --now

# install notification daemon
paru -S dunst

# install a good font
paru -S ttf-fira-code

# Widgets and bar
paru -S quickshell
