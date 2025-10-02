set -e # exit on error

# Color Constants
RESET_COLOR="\033[0m"
BLUE="\033[0;34m"
RED="\033[0;31m"

# run as root
# https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
if [ "$EUID" -ne 0 ]; then
  printf "${RED}Must be root to run this script!${RESET_COLOR}"
  exit
fi

# install dialog for fun interaction
printf "Installing Dialog for user selection"
pacman -S dialog

# make sure that the system is up todate
pacman -Syu --noconfirm 2>&1 | dialog --progressbox 30 100

# install git so we can install things from github
printf "\n${BLUE}Installing Git:${RESET_COLOR}\n"
pacman -S git --noconfirm 2>&1 | dialog --progressbox 30 100

# install paru for package managment
pacman -S --needed base-devel --noconfirm 2>&1 | dialog --progressbox 30 100
git clone https://aur.archlinux.org/paru.git 2>&1 | dialog --progressbox 30 100
cd paru
makepkg -si 2>&1 | dialog --progressbox 20 100

if ! command -v paru >/dev/null 2>&1; then
  # dialog half the size
  dialog --title "Error" --msgbox "Unable to install paru!" 15 50
  exit 1
fi
#
# Define the non-root user to run paru as:
NONROOT_USER=${SUDO_USER:-$(logname)}

cd ..
# paru should know about itself
sudo -u "$NONROOT_USER" paru -S paru --noconfirm 2>&1 | dialog --progressbox 30 100
# scary
rm -rf paru/

# install hyprland
sudo -u "$NONROOT_USER" paru -S hyprland hypridle hyprpaper hyprpicker hyprlock xdg-desktop-portal-hyprland hyprsunset hyprpolkitagent hyprsysteminfo hyprland-qt-support hyprqt6engine hyprcursor hyprutils hyprlang hyprwayland-scanner aquamarine hyprgraphics hyprland-qtutils --noconfirm 2>&1 | dialog --progressbox 30 100

# install audio
sudo -u "$NONROOT_USER" paru -S pipewire --noconfirm 2>&1 | dialog --progressbox 30 100
systemctl enable pipewire --now 2>&1 | dialog --progressbox 30 100

# install notification daemon
sudo -u "$NONROOT_USER" paru -S dunst ttf-fira-code quickshell --noconfirm 2>&1 | dialog --progressbox 30 100
