# AppointBolt - iOS Development Guide

## Executive Summary

AppointBolt is a focused, no-nonsense appointment reminder app designed for small business owners who lose money to no-shows. Unlike bloated scheduling platforms that charge $20+/month and overwhelm users with features they don't need, AppointBolt does one thing exceptionally well: it makes sure clients show up.

**Product Vision**: Be the simplest, fastest way for solo entrepreneurs and small teams to eliminate no-shows through automated SMS and push reminders.

**Target Audience**: Beauty salons, barbershops, clinics, fitness trainers, consultants, photographers, and any small business that relies on appointments.

**Key Differentiators**:
- Free tier with unlimited appointments (competitors limit free plans to 5/month)
- SMS-first approach (competitors hide SMS behind expensive plans)
- Pure native SwiftUI experience (competitors use web wrappers)
- No hidden transaction fees (competitors charge 3%+ on payments)
- One no-show saved pays for the entire year of Pro

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| **Goldie (Appointfix)** | 4.8 rating, 10K+ reviews, online booking, deposits | Pro $19.99/mo, Pro Plus $39.99/mo, complex feature set, web-based core | 50% cheaper Pro, simpler UX, native Swift, free unlimited appointments |
| **Appointible** | Multi-location, staff management, offline mode | New app with few reviews, complex onboarding, web-based | Simpler setup, native iOS feel, focused on reminders not full scheduling |
| **Acuity Scheduling** | Mature platform, extensive integrations | $16-20/mo + 3% transaction fee, data export crashes, web-only | No transaction fees, native app, reliable data export, simpler pricing |
| **GoReminders** | Simple SMS reminders, 4.8 rating | Limited customization, subscription-only, no free tier | Free tier available, custom templates, analytics dashboard |
| **Calendly** | Popular, free basic plan | Free plan has no SMS, team features expensive, web-first | SMS on all paid plans, native mobile, no-show tracking built-in |

## Apple Design Guidelines Compliance

- **Clarity**: Clean typography with SF Pro, high contrast text, clear visual hierarchy. Each screen focuses on one primary action.
- **Deference**: Content-first design. Appointment list is the hero. UI chrome is minimal.
- **Depth**: Navigation stack with natural push/pop transitions. Cards with subtle shadows create layered depth.
- **Consistency**: Standard SwiftUI components (List, NavigationStack, Sheet). System colors for light/dark mode.
- **Accessibility**: Dynamic Type support, VoiceOver labels on all interactive elements, minimum 44pt touch targets.
- **Haptics**: Subtle haptic feedback on confirm/cancel actions.

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (EventKit integration)
- **Data**: SwiftData (local persistence) + CloudKit (optional sync)
- **Networking**: URLSession with async/await (no third-party libraries)
- **Notifications**: UNUserNotificationCenter (local push) + Twilio API (SMS via backend proxy)
- **Calendar**: EventKit framework for Apple/Google Calendar sync
- **IAP**: StoreKit 2 for subscription management
- **Architecture**: MVVM with @Observable macro

## Module Structure

```
AppointBolt/
├── AppointBoltApp.swift
├── Models/
│   ├── Appointment.swift
│   ├── Client.swift
│   ├── Reminder.swift
│   ├── BusinessProfile.swift
│   └── SubscriptionTier.swift
├── ViewModels/
│   ├── AppointmentListVM.swift
│   ├── AddAppointmentVM.swift
│   ├── ClientListVM.swift
│   ├── ReminderEngine.swift
│   ├── AnalyticsVM.swift
│   └── PurchaseManager.swift
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   └── BusinessSetupView.swift
│   ├── MainTabView.swift
│   ├── Appointments/
│   │   ├── AppointmentListView.swift
│   │   ├── AppointmentRowView.swift
│   │   ├── AddAppointmentView.swift
│   │   └── AppointmentDetailView.swift
│   ├── Clients/
│   │   ├── ClientListView.swift
│   │   ├── AddClientView.swift
│   │   └── ClientDetailView.swift
│   ├── Analytics/
│   │   └── AnalyticsView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── BusinessProfileView.swift
│   │   ├── ReminderSettingsView.swift
│   │   ├── SubscriptionView.swift
│   │   └── ContactSupportView.swift
│   └── Components/
│       ├── StatusBadge.swift
│       ├── DurationPicker.swift
│       └── EmptyStateView.swift
├── Services/
│   ├── NotificationService.swift
│   ├── SMSService.swift
│   ├── CalendarSyncService.swift
│   ├── AnalyticsService.swift
│   └── FeedbackService.swift
├── Extensions/
│   ├── Color+Theme.swift
│   ├── Date+Formatting.swift
│   └── String+URL.swift
└── Resources/
    └── Assets.xcassets/
```

## Implementation Flow

1. Create SwiftData models (Appointment, Client, Reminder, BusinessProfile)
2. Build Onboarding flow (welcome + business profile setup + notification permission)
3. Implement MainTabView with 4 tabs (Today, Appointments, Clients, Settings)
4. Build Appointment list with filtering (today, upcoming, past, no-show)
5. Create Add Appointment flow with client search/creation
6. Implement Client management (list, add, detail, no-show tracking)
7. Build ReminderEngine with UNUserNotificationCenter integration
8. Implement SMS service via Twilio backend proxy
9. Add Calendar sync with EventKit
10. Build Analytics dashboard (no-show rate, revenue impact, trends)
11. Implement StoreKit 2 subscription management
12. Add Settings with policy links, contact support, subscription management
13. Polish UI with animations, haptics, dark mode support
14. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: Electric Blue (#2563EB)
  - Success: Green (#10B981) for confirmed/completed
  - Warning: Amber (#F59E0B) for upcoming reminders
  - Danger: Red (#EF4444) for no-show/cancelled
  - Background: System adaptive (light/dark)
- **Typography**: SF Pro system font
  - Large Title: 34pt Bold
  - Title: 28pt Bold
  - Headline: 17pt Semibold
  - Body: 17pt Regular
  - Caption: 12pt Regular
- **Layout**:
  - Standard spacing: 16pt
  - Compact spacing: 8pt
  - Card corner radius: 12pt
  - Button corner radius: 8pt
  - Input field corner radius: 10pt
  - Max content width on iPad: 720pt
- **Animations**: 0.25s ease-in-out transitions, system navigation transitions
- **Icons**: SF Symbols 5, consistent 20pt sizing
- **Adaptive**: iPhone SE through iPhone 16 Pro Max, iPad with sidebar support

## Code Generation Rules

- MVVM with @Observable macro for ViewModels
- SwiftUI only, minimum iOS 17.0
- SwiftData for persistence, CloudKit optional
- async/await for all asynchronous operations
- No third-party dependencies (Apple native frameworks only)
- Twilio SMS via backend proxy (never expose API keys in client)
- UNUserNotificationCenter for local push notifications
- EventKit for calendar sync
- StoreKit 2 for IAP subscriptions
- English naming: camelCase variables, PascalCase types
- No comments in code unless explicitly requested
- All SwiftData model attributes must be optional or have default values
- All relationships must have inverse relationships
- iPad layout: max content width 720pt with .frame(maxWidth: .infinity)
- Never use .tabViewStyle(.sidebarAdaptable)

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.AppointBolt
2. Verify Deployment Target: iOS 17.0
3. Configure App Icon (1024x1024)
4. Enable capabilities: Push Notifications, iCloud (CloudKit), Calendar (EventKit)
5. Configure StoreKit subscription products
6. Build and test on iPhone XS Max simulator
7. Build and test on iPad Pro 13-inch (M4) simulator
8. Push to GitHub repository
9. Deploy policy pages to GitHub Pages
10. Prepare App Store Connect metadata
