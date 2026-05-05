# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "通知" / "提醒" / "alert" → Push Notifications required
- "同步" / "iCloud" / "CloudKit" → iCloud capability required
- "日历" / "Calendar" / "EventKit" → Calendar access required
- "订阅" / "会员" / "premium" → In-App Purchase required
- "后台" / "background" → Background Modes (notifications) required

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project setting |
| Background Modes (Remote Notifications) | ✅ Configured | Xcode project setting |
| In-App Purchase | ✅ Configured | StoreKit 2 integration |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud (CloudKit) | ⏳ Pending | 1. Open Xcode → Signing & Capabilities → + Capability → iCloud 2. Check CloudKit checkbox 3. Create CloudKit container: iCloud.com.zzoutuo.AppointBolt 4. Deploy to Production in CloudKit Dashboard before App Store submission |
| Calendar (EventKit) | ⏳ Pending | 1. Add NSCalendarsUsageDescription to Info.plist: "AppointBolt needs calendar access to sync your appointments with Apple Calendar" 2. Request access at runtime using eventStore.requestFullAccessToEvents() |

## No Configuration Needed
- HealthKit (not a health app)
- Camera/Photo Library (no photo features)
- Location Services (no location features)
- Apple Watch (Phase 2 feature)
- Siri (not needed for MVP)
- Sign in with Apple (using simple auth)

## Verification
- Build succeeded after configuration: ⏳ Pending (after code generation)
- All entitlements correct: ⏳ Pending
