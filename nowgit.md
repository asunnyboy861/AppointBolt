# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | AppointBolt |
| **Git URL** | git@github.com:asunnyboy861/AppointBolt.git |
| **Repo URL** | https://github.com/asunnyboy861/AppointBolt |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/AppointBolt/ | ⏳ Pending |
| Support | https://asunnyboy861.github.io/AppointBolt/support.html | ⏳ Pending |
| Privacy Policy | https://asunnyboy861.github.io/AppointBolt/privacy.html | ⏳ Pending |
| Terms of Use | https://asunnyboy861.github.io/AppointBolt/terms.html | ⏳ Pending |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

### Main App Repository
```
AppointBolt/
├── AppointBolt/                       # iOS App Source Code
│   ├── AppointBolt.xcodeproj/         # Xcode Project
│   ├── AppointBolt/                   # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Onboarding/
│   │   │   ├── Appointments/
│   │   │   ├── Clients/
│   │   │   ├── Analytics/
│   │   │   ├── Settings/
│   │   │   └── Components/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Services/
│   │   └── Extensions/
│   └── ...
├── docs/                              # Policy Pages for GitHub Pages
│   ├── index.html                     # Landing Page
│   ├── support.html                   # Support Page
│   ├── privacy.html                   # Privacy Policy
│   └── terms.html                     # Terms of Use
├── .github/workflows/                 # GitHub Actions
│   └── deploy.yml                     # GitHub Pages deployment
├── us.md                              # English Development Guide
├── keytext.md                         # App Store Metadata
├── capabilities.md                    # Capabilities Configuration
├── icon.md                            # App Icon Details
├── price.md                           # Pricing Configuration
└── nowgit.md                          # This File
```
