# TahoeOS Security Documentation

## Security Architecture

```
┌─────────────────────────────────────────┐
│         Secure Boot (UEFI)              │
│  Signed shim → Signed kernel            │
├─────────────────────────────────────────┤
│         Disk Encryption                 │
│  LUKS2 + TPM auto-unlock                │
├─────────────────────────────────────────┤
│         Kernel Security                 │
│  Liquorix hardening + AppArmor          │
├─────────────────────────────────────────┤
│         Application Sandboxing          │
│  AppArmor profiles per app              │
├─────────────────────────────────────────┤
│         Network Security                │
│  UFW firewall (block incoming)          │
├─────────────────────────────────────────┤
│         Authentication                  │
│  PAM + fprintd + polkit                 │
├─────────────────────────────────────────┤
│         Updates                         │
│  Auto security updates (unattended)     │
└─────────────────────────────────────────┘
```

## Components

### AppArmor
```
Profiles installed:
  - /usr/bin/tahoe-control-center
  - /usr/bin/tahoe-app-store
  - /usr/bin/tahoe-installer
  - /usr/bin/firefox
  - /usr/bin/gnome-terminal
  - /usr/bin/nautilus
```

### UFW (Firewall)
```
Default policy:
  Incoming: DENY
  Outgoing: ALLOW

Rules:
  - Allow all outgoing connections
  - Block all incoming connections
  - User can open ports via Settings
```

### LUKS2 Encryption
```
Algorithm: AES-XTS-PLAIN64
Key size: 512 bits
Key derivation: Argon2id
TPM: Auto-unlock after first boot
Recovery: 24-word recovery key
```

### Secure Boot
```
Shim: Signed by Microsoft
GRUB: Signed by TahoeOS key
Kernel: Signed by TahoeOS key
MOK: Machine Owner Key enrollment
```

### Auto Security Updates
```
Package: unattended-upgrades
Config: /etc/apt/apt.conf.d/50tahoeos-upgrades.conf
Sources: Ubuntu security + TahoeOS security
Schedule: Daily check, auto-install
Notification: Via Control Center
```

### Telemetry
```
Zero telemetry.
Zero phone-home.
Zero analytics.
Opt-in crash reporting only (via GitHub Issues).
```

### Fingerprint (fprintd)
```
Supported: Most laptop fingerprint readers
Uses: Login screen, sudo, polkit
Enrollment: Settings → Privacy → Fingerprint
```

## User Privacy

| Feature | Status |
|---------|--------|
| Location services | Off by default |
| Crash reports | Opt-in only |
| Usage analytics | None |
| Network tracking | None |
| App telemetry | None |
| System telemetry | None |
| Backdoor | None |

## Firewall Rules (Default)

```bash
# /etc/ufw/user.rules
*filter
:ufw-user-input - [0:0]
:ufw-user-output - [0:0]
:ufw-user-forward - [0:0]

# Allow all outgoing
-A ufw-user-output -j ACCEPT

# Block all incoming (except established)
-A ufw-user-input -m state --state ESTABLISHED -j ACCEPT

# Allow loopback
-A ufw-user-input -i lo -j ACCEPT

COMMIT
```
