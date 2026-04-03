# Phase 7: Security & Backup Integration

**Duration**: Week 5-6
**Goal**: Complete security stack and backup system

---

## Tasks

### 7.1 Security Profiles
- [ ] SELinux: tahoe-control-center policy
- [ ] SELinux: tahoe-app-store policy
- [ ] SELinux: tahoe-installer policy
- [ ] SELinux: Firefox policy
- [ ] firewalld: default zone config
- [ ] Polkit: GPU driver install policy
- [ ] Polkit: Backup restore policy

### 7.2 Encryption
- [ ] LUKS2 setup in installer
- [ ] TPM auto-unlock configuration
- [ ] Recovery key generation
- [ ] Secure Boot shim signing

### 7.3 Backup Integration
- [ ] Backup GUI in Settings
- [ ] Snapshot timeline browser
- [ ] One-click restore
- [ ] GRUB snapshot entries
- [ ] External drive auto-detect
- [ ] Network drive configuration (SMB/NFS)

### 7.4 Fingerprint
- [ ] fprintd enrollment UI in Settings
- [ ] Login integration
- [ ] sudo integration

### 7.5 Firewall
- [ ] firewalld GUI in Settings panel
- [ ] Enable/disable toggle
- [ ] Port open/close
- [ ] Application rules

---

## Deliverables
- tahoe-security package (complete)
- tahoe-backup package (complete)
- Full encryption support
- Fingerprint support
