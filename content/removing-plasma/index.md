---
title : Removing Default Plasma Over Niri and Noctalia
date : 2026-07-07
slug : "out-with-plasma"
updated : 2026-07-07
---

## Problem statement

I am a KDE and plasma enjoyer. It's what I used when I used Kubuntu as my daily driver for a short period of time. It's what is bundled with steamOS. It's what is default on CachyOS.

It gets the job done. Having switched recently to Niri + Noctalia, plasma and KDE applications were just sitting there consuming resources. So I decided to remove them altogether.

## Solution

### Removing KDE

Since I went with the CachyOS default install of KDE and then installed Niri+Noctalia meta package on top of it, the most cleanest option here would be to do a fresh install, but `aint-nobody-got-time-for-that`

So off I went ripping everything out.

> **Warning**
> - If you are using this as a guide, run `sudo pacman -D --asexplicit sddm` first before executing the following command.

```bash
sudo pacman -Rns plasma kde-applications
```
> **Information**
> - R is for remove
> - n is for --nosave, no config files will be left around, because in this case we dont need it anymore. 
> - s is for recursive, it removes all direct dependencies. Side note : won't `r` be a better fit ? 

### Accidental SDDM Removal

In the huge list of dependencies listed, I did not notice SDDM being there, pacman removed SDDM along with plasma and kde-applications. 

The next boot landed me in TTY1 with no login manager.

What I should have done is marked sddm as explicitly needed and then removed the rest.

```sh
sudo pacman -D --asexplicit sddm
```

### Default SDDM Theme - Sucks

After installing SDDM, the next reboot did give me a login screen but it was so bland. Also, it listed every NixOS build user before getting to my user.

So I had two objectives here: 

1. Find a better SDDM theme
2. Hide all non interactive users from account selection

### Sugar Candy - You Had One Job

Google search suggested `sddm-sugar-candy-git` as one of the best SDDM themes out there. So I went ahead and installed it. 

```bash
shelly install sddm-sugar-candy-git
```

After installing it, created a config override.

```bash
sudo nano /etc/sddm.conf.d/10-custom.conf
```

Added maximum allowed UIDs to ensure no NixOS users showed up on the login screen and removed non interactive and system users. I dont have any in the last two categories but they are nice defaults to have.

```toml
[Theme]
Current=sugar-candy
CursorTheme=capitaine-cursors

[Users]
# Hide non interactive users
HideShells=/usr/bin/nologin,/sbin/nologin,/bin/false

# Hide standard system users
MinimumUid=1000

# Hide NixOS users
MaximumUid=29999
```

Rebooted system, SDDM now loaded and sugar candy looked clean and everything looked good, UNTIL, I keyed in my password. 

Every password character I entered showed what it was in plain text without changing to *. The character I was typing showed as plaintext, but the moment I entered a new character, the older one changed to *. All one has to do is, just stand behind me and they will know what my password is, unless I type super fast.

So I removed sugar-candy, stopped trusting google and went to github to see what other SDDM themes are out there. 

```bash
shelly remove sddm-sugar-candy-git
```
> **Note**
> - If I had read the documentation, I would have known that there is a QML setting `PasswordEchoOnEdit` that disables this.
> - `Anyway-I-Started-Blasting`


### Silent SDDM

Enter [Silent SDDM](https://github.com/uiriansan/SilentSDDM)

I installed it using shelly, this time choosing a stable variation than the one that tracks git commits.

```bash
shelly install sddm-silent-theme
```

Edited the override file as the installation steps suggested.

```bash
sudo nano /etc/sddm.conf.d/10-custom.conf
```

```toml
[Theme]
Current=silent

[Users]
# Hide non interactive users
HideShells=/usr/bin/nologin,/sbin/nologin,/bin/false

# Hide standard system users
MinimumUid=1000

# Hide NixOS users
MaximumUid=29999
```

Silent SDDM is good enough to get the job done and I am happy with it (for now).