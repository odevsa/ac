# AC - Arch Cosmic

A simple intallation of Cosmic Desktop Environment with my Dotfiles into Arch Linux and automated by shell script.

My Dotfiles are here: https://github.com/odevsa/dotfiles

## Disclaimer

This is for my personal use and it's working in progress, so files can be deleted, things can break, etc. If you want to try it, it`s for your own risk.

## Important

It's in progress, so please EXECUTE ONLY ONCE.

It's needing of some check before to do changes in files of the system yet, so if you execute more then one time, the changes will be duplicated in files.

## Screenshots

...

## What does this do?

- [x] Update
- [x] :checkered_flag: - AUR Support (yay)
- [x] Copy dotfiles (custom dotfiles see: [common/vars/main.yml](common/vars/main.yml))
- [x] Codecs (audio, image and video)
- [x] Main file compressors (zip, unrar, p7zip...)
- [x] Multimedia core (mesa, vulkan, network, bluetooth, pipewire...)
- [x] Popular development packages (git, rust, python, nodejs...)
- [x] Zsh (set as default, oh-my-posh, oh-my-zsh, sintax-highlight, autosuggestion)
- [x] :checkered_flag: - Amdgpu
- [x] :checkered_flag: - Nvidia
- [x] Fonts (font-awesome, firacode-nerd)
- [x] Terminal Applications (fastfetch, neovim, btop...)
- [x] :checkered_flag: - Utilities Applications (nautilus, file-roller, snapshot, totem...)
- [x] :checkered_flag: - Development Applications (spacevim, dbeaver, docker...)
- [x] :checkered_flag: - Graphical Applications (gimp, inkscape)
- [x] :checkered_flag: - Multimedia Applications (audacity, obs-studio, kdenlive)
- [x] :checkered_flag: - 3D Applications (blender, freecad)
- [x] :checkered_flag: - Browser (firefox | chromium | vivaldi | google-chrome)
- [x] Cosmic Desktop Environment

:checkered_flag: = Optional installation, see: [common/vars/main.yml](common/vars/main.yml)

## Shortcuts

- [SUPER] Launcher
- [SUPER]+[A] Applications
- [SUPER]+[T] Terminal
- [SUPER]+[F] File manager
- [SUPER]+[B] Browser
- [SUPER]+[Q] Close active window
- [SUPER]+[G] Toggle floating
- [SUPER]+[M] Toggle fullscreen
- [SUPER]+[O] Change Orientation
- [SUPER]+[W] View Workspaces
- [SUPER]+[1|2|3|4|5|6|7|8|9|0] Navigate workspace
- [SUPER]+[ESC] Lock screen
- [SUPER]+[ARROW] Change focus window
- [SUPER]+[SHIFT]+[ARROW] Move window

## What you will need

- Any distribution based on Arch Linux, preferably a clean installation of Arch Linux with systemd-boot (grub not tested yet).
- Internet connection:
  - Ethernet
  - Wifi with `iwctl`

    ```
    $ iwctl

    [iwctl]# station <DEVICE> connect "<SSID>"
    ```

  - Wifi with `NetworkManager`
    ```
    $ nmcli device wifi connect "<SSID>" --ask
    ```

## Automatic Install

Just run this code and see the magic

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/odevsa/ac/main/install.sh)"
```

You may want to use flags to customize installation

| Flag                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| `--debug`           | Run with local files for debugging                                                                |
| `--skip-aur-helper` | Skip YAY and AUR packages installation.                                                           |
| `--skip-amdgpu`     | Skip AMD GPU (amdgpu) installation.                                                               |
| `--skip-nvidia`     | Skip NVIDIA GPU (nvidia) installation.                                                            |
| `--skip-gpu`        | Skip both AMD and NVIDIA GPUs installation.                                                       |
| `--skip-apps`       | Skip all application-related installations.                                                       |
| `--skip-neovim`     | Skip Neovim and NvChad installations.                                                             |
| `--skip-docker`     | Skip Docker installations.                                                                        |
| `--only-core`       | Installs only core system components, disabling other features like applications and GPU drivers. |

For example: If you don't want Nvidia driver and default applications, you can try:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/odevsa/ac/main/install.sh)" -- --skip-nvidia --skip-apps
```

## Manual Install

- Install necessary dependencies

  ```
  sudo pacman -S git
  ```

- Clone the repo

  ```
  git clone https://github.com/odevsa/ac.git
  ```

- Enter in folder

  ```
  cd ac
  ```

- Customize the file [common/vars/main.yml](common/vars/main.yml) as you need

- Run
  ```
  chmod +x install.sh
  ./install.sh
  ```
- Input sudo password when it ask for
