# Publishing and Maintaining `tost-bin` on the Arch User Repository (AUR)

This directory contains the AUR package definition for `tost-bin` (the official precompiled binary release for Arch Linux).

---

## 1. Prerequisites for AUR Maintainers

1. Register an account on [https://aur.archlinux.org](https://aur.archlinux.org).
2. Add your public SSH key (`~/.ssh/id_ed25519.pub` or `~/.ssh/id_rsa.pub`) to your AUR profile settings: **My Account -> SSH Public Key**.

---

## 2. First-time Setup: Submitting `tost-bin` to AUR

Clone the empty AUR repository for `tost-bin`:

```bash
git clone ssh://aur@aur.archlinux.org/tost-bin.git /tmp/aur-tost-bin
```

Copy the package definition files:

```bash
cp packaging/aur/tost-bin/PKGBUILD /tmp/aur-tost-bin/
cp packaging/aur/tost-bin/.SRCINFO /tmp/aur-tost-bin/
```

Test build locally with `makepkg`:

```bash
cd /tmp/aur-tost-bin
makepkg -si
```

Commit and push to publish:

```bash
cd /tmp/aur-tost-bin
git add PKGBUILD .SRCINFO
git commit -m "feat: initial release of tost-bin v2.0.3"
git push origin master
```

Once pushed, the package will immediately be live and installable by all Arch users via AUR helpers:
```bash
paru -S tost-bin
# or
yay -S tost-bin
```

---

## 3. Updating `tost-bin` for New Releases

When a new version of TOST (e.g. `v2.0.4`) is released on GitHub:

1. Update `pkgver` and `pkgrel=1` in `PKGBUILD`.
2. Compute the sha256 checksum of the new `TOST-2.0.4-linux-x64.tar.gz` release asset:
   ```bash
   sha256sum TOST-2.0.4-linux-x64.tar.gz
   ```
   and update `sha256sums` in `PKGBUILD`.
3. Regenerate `.SRCINFO`:
   ```bash
   makepkg --printsrcinfo > .SRCINFO
   ```
4. Test and push the update to AUR:
   ```bash
   git add PKGBUILD .SRCINFO
   git commit -m "chore: update to v2.0.4"
   git push origin master
   ```
