# Phase 1: Foundations

**Duration**: Week 1
**Goal**: Build environment, GitHub, COPR repo, logo, CI/CD

---

## Tasks

### 1.1 Linux VM Setup
- [ ] Create VirtualBox VM (4 CPUs, 8GB RAM, 64GB storage)
- [ ] Install Fedora 42 as base
- [ ] Install build tools: lorax, mock, rpm-build, createrepo_c, xorriso
- [ ] Configure SSH access from Windows host
- [ ] Set up shared folders for file transfer

### 1.2 GitHub Repository
- [ ] Create github.com/YOURNAME/TahoeOS
- [ ] Add README.md with project overview
- [ ] Add LICENSE (MIT)
- [ ] Add .gitignore
- [ ] Set up branch protection (main)
- [ ] Create issue templates (bug report, feature request)
- [ ] Set up GitHub Actions secrets (VPS SSH key, GPG key)

### 1.3 COPR Repository
- [ ] Create COPR account (fedoraproject.org)
- [ ] Create tahoeos/stable project
- [ ] Create tahoeos/beta project
- [ ] Configure build chroots (Fedora 42)
- [ ] Set up webhook for auto-builds
- [ ] Test package upload

### 1.4 Logo Design
- [ ] Design TahoeOS logo (mountain/lake, Liquid Glass style)
- [ ] Create SVG (vector)
- [ ] Export PNGs (512, 256, 128, 64, 32, 16)
- [ ] Create ASCII art version for neofetch
- [ ] Design wordmark "TahoeOS"
- [ ] Define brand colors (#007AFF, glass white, dark glass)

### 1.5 CI/CD
- [ ] Create .github/workflows/build-iso.yml
- [ ] Create .github/workflows/publish-packages.yml
- [ ] Create .github/workflows/test-packages.yml
- [ ] Create .github/workflows/release.yml
- [ ] Test all workflows

### 1.6 Project Structure
- [ ] Create complete directory tree
- [ ] Create placeholder files for all packages
- [ ] Set up build orchestration scripts

---

## Deliverables
- Working Linux VM with all build tools
- Live GitHub repository with CI/CD
- COPR repo ready to receive packages
- Logo and brand assets
- Complete project directory structure

## Dependencies
- COPR account (free)
- GitHub account
- Domain name (optional, can use IP initially)
