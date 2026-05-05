# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: AppointBolt Premium
- **Group ID**: AppointBolt_Premium

## Subscription Tiers

### 1. Monthly Pro
- **Reference Name**: Monthly Pro
- **Product ID**: `com.zzoutuo.AppointBolt.pro.monthly`
- **Price**: $9.99 per month
- **Display Name**: Pro Monthly
- **Description**: SMS reminders, custom templates, analytics
- **Localization**: English (US)

### 2. Yearly Pro
- **Reference Name**: Yearly Pro
- **Product ID**: `com.zzoutuo.AppointBolt.pro.yearly`
- **Price**: $79.99 per year (33% savings vs monthly)
- **Display Name**: Pro Yearly
- **Description**: Best value - save 33% on Pro features
- **Localization**: English (US)

### 3. Monthly Pro Plus
- **Reference Name**: Monthly Pro Plus
- **Product ID**: `com.zzoutuo.AppointBolt.proplus.monthly`
- **Price**: $19.99 per month
- **Display Name**: Pro Plus Monthly
- **Description**: Unlimited SMS, team support, online booking
- **Localization**: English (US)

### 4. Yearly Pro Plus
- **Reference Name**: Yearly Pro Plus
- **Product ID**: `com.zzoutuo.AppointBolt.proplus.yearly`
- **Price**: $159.99 per year (33% savings vs monthly)
- **Display Name**: Pro Plus Yearly
- **Description**: Best value - save 33% on Pro Plus features
- **Localization**: English (US)

## Free Tier Features
- Unlimited appointments
- Unlimited clients
- Local push notifications
- Calendar sync (EventKit)
- No-show tracking
- Basic reports

## Pro Tier Features ($9.99/mo or $79.99/yr)
- All Free features
- SMS reminders (50/month)
- Email reminders
- Custom message templates
- Client confirm/cancel
- Waitlist
- Auto-reschedule links
- Advanced reports

## Pro Plus Tier Features ($19.99/mo or $159.99/yr)
- All Pro features
- Unlimited SMS reminders
- Team support (3 staff)
- Online booking page
- No-show follow-up automation
- Data export (CSV)
- Priority support

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to paid Pro Monthly)
- **Applies to**: Pro Monthly only

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented

## SMS Cost Analysis
| Tier | SMS/Month | Twilio Cost (~$0.075/msg) | Gross Margin |
|------|-----------|---------------------------|--------------|
| Pro | 50 | ~$3.75 | ~62% |
| Pro Plus | Unlimited (~100 avg) | ~$7.50 | ~62% |

## Value Anchoring
- 1 no-show saved = $80-$300 (industry average)
- Pro annual = $79.99 = less than 1 no-show
- Pro Plus annual = $159.99 = less than 2 no-shows
