---
name:  Bug Report
about: Report a bug to help us improve the LED App
title: "[Bug] "
labels: bug
assignees: ''

---

## Bug Description

_A clear and concise description of what the bug is._

> Example:  
> Tapping the color circle on the LightWidget does not open the modify popup as expected. Only the gear icon works.

---

##  Environment

- **App Version:** `v1.0.0`
- **Platform:** (e.g., Android, iOS, Web)
- **Device:** (e.g., Pixel 5, iPhone 12, etc.)
- **OS Version:** (e.g., Android 13, iOS 17)

---

##  Steps to Reproduce

_How to reproduce the issue:_

1. Launch the app
2. Navigate to the **Rooms** screen
3. Tap on the color circle of any light
4. Observe that nothing happens

---

##  Expected Behavior

_What did you expect to happen?_

> Tapping the color circle should trigger the same modify popup as the gear icon or the "Modify" text.

---

##  Screenshots or Videos

_If applicable, add screenshots or a screen recording here._

---

##  Logs

_Please copy and paste any relevant log output or error messages._

---

##  Suggested Fix (Optional)

_If you have a potential solution or hint, include it here._

> Wrap the color circle in a `GestureDetector` that triggers the same `onModify` callback.

---

## 🗒️ Additional Context

_Add any other context about the problem here._
