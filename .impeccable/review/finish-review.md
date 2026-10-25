disposition: recapture

## recapture

- `.impeccable/review/` has no Android phone capture. `PRODUCT.md` declares Android, while `mobile.png`, `desktop.png`, `community-phone.png`, `community-desktop-dark.png`, `profile-phone.png`, `composer-top.png`, and `composer-preview.png` were captured in Flutter Chrome. These are valid browser UI captures, but the Android reference explicitly requires emulator or connected-device evidence. Capture the Android Wall at the document top with the actual status/navigation bars and safe insets visible, including dark theme and increased system font size; include any other device class actually shipped. This is necessary to verify the requested purple status-strip fix and that controls remain clear of native system insets and the keyboard.
