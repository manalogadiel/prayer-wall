# Prayer Wall: v1 Plan

_Last updated: 2026-10-24_

> Anyone can add to a prayer wall, and anyone can pray for it.

This plan takes Prayer Wall from today's local-only demo to a real, shared app on
**Android, iOS, and Web (PWA)**. Everything it uses runs on **free tiers**.

---

## 1. Decisions

| Topic | Decision | Why |
|---|---|---|
| Backend | **Supabase (free tier)** | Free with no card. Postgres, Auth (including anonymous/guest sign-in), Realtime, Storage, and Edge Functions. DB triggers keep counts correct on the server for free. |
| Accounts | **Guests can browse and pray. Posting and commenting need an account.** | Keeps "anyone can pray" with no friction. A real account behind each post makes moderation workable. |
| Audience | **Public app with many circles** | Anyone can join. A global **Everyone** wall, plus topic or church circles found through Discover. |
| Platforms | **Android, iOS, Web (PWA)** | One Flutter codebase. The repo already has `web/`. |
| State management | **Riverpod** | Testable, no `BuildContext` plumbing, works well with streams. |
| Routing | **go_router** | Deep links (`/c/:circle/p/:post`) for sharing on web and mobile. |
| Push | **FCM (free)** sent from a Supabase Edge Function | FCM is free on every platform, including web push. |
| Web hosting | **GitHub Pages** (or Cloudflare Pages) | Free, deployed from CI. |

### Free-tier notes (check current limits before launch)

- **Supabase free:** about 500 MB database, 1 GB storage, 50k monthly active users, 2 projects.
  **Free projects pause after about 7 days with no activity.** A GitHub Actions cron pings the API daily to prevent this.
- **FCM:** free with no message limits that matter at our size.
- **Not free:** store publishing. Google Play costs **$25 once**. Apple Developer costs **$99 per year** (needed for TestFlight and the App Store).
  Web and APK sideloading cost nothing, so launch there first.

---

## 2. Where the code stands

The repo (`lib/main.dart`, about 700 lines) is a polished UI demo:

- ✅ Welcome screen with sign-in and sign-up (no real auth: any button goes in)
- ✅ Wall feed with prayer and thanksgiving cards, topic chips, "I prayed" toggle, composer sheet with an anonymous toggle
- ✅ Bottom nav: Wall · Discover · Journal · Me
- ❌ All data is hard-coded and lost on restart
- ❌ Topic filter chips don't filter. The "Amen", notifications, "…" and "Forgot password" buttons do nothing.
- ❌ Discover, Journal, and Profile are static mock screens
- ❌ Everything lives in one file. No tests, no CI.
- ⚠️ `.appdata/` (Dart analyzer cache and telemetry `CLIENT_ID`) is committed and should be removed and ignored
- ⚠️ No `android/` or `ios/` folders yet (`flutter create --platforms=android,ios .`)

Keep the visual language (violet `#6956C9`, lavender, soft rounded cards, warm copy). It's good.

---

## 3. Architecture

```
Flutter app (Android / iOS / Web)
 ├─ presentation   screens + widgets (feature folders)
 ├─ application    Riverpod providers / notifiers
 ├─ data           repositories → supabase_flutter
 └─ domain         plain Dart models (freezed + json_serializable)
          │
          ▼
Supabase
 ├─ Auth           anonymous (guest), email + password, Google
 ├─ Postgres       tables + RLS + triggers + views
 ├─ Realtime       live feed inserts and prayer counts
 ├─ Edge Functions push fan-out (FCM), account deletion
 └─ Storage        avatars, circle covers
```

### Folder layout

```
lib/
  main.dart
  app/            router.dart, theme.dart, env.dart
  core/           widgets/ (BrandMark, Avatar, Pill…), utils/, errors.dart
  features/
    auth/         data/ application/ presentation/
    wall/         feed, PrayerCard, Composer
    circles/      Discover, circle detail, create circle
    comments/
    journal/
    profile/
    moderation/   report sheet, moderator queue
    notifications/
supabase/
  migrations/     versioned SQL (schema, RLS, triggers)
  functions/      edge functions (TypeScript/Deno)
  seed.sql
test/             unit + widget tests
docs/             this plan, guidelines, privacy policy
```

Keys go in through `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`), never committed.

---

## 4. Data model (Postgres)

```
profiles        id (= auth.users.id), display_name, avatar_url, bio, created_at
circles         id, slug, name, description, cover_url, visibility (public|private),
                created_by, member_count, created_at
circle_members  circle_id, user_id, role (member|moderator|owner), joined_at   PK(circle_id,user_id)
posts           id, circle_id, author_id, kind (prayer|thanksgiving), body (≤ 1000 chars),
                topic, is_anonymous, status (active|answered|hidden|removed),
                prayed_count, comment_count, answered_note, created_at, answered_at
prayers         post_id, user_id, created_at                                  PK(post_id,user_id)
comments        id, post_id, author_id, body (≤ 500), status, created_at
saved_posts     user_id, post_id, created_at                                  PK(user_id,post_id)
journal_entries id, user_id, body, linked_post_id?, answered, created_at       (private)
reports         id, target_type (post|comment|user), target_id, reporter_id, reason, note,
                status (open|actioned|dismissed), handled_by, created_at
blocks          user_id, blocked_user_id                                      PK(user_id,blocked_user_id)
device_tokens   user_id, token, platform, updated_at
```

**Everyone circle:** a seeded circle (`slug = 'everyone'`) that every user can read and post to. It's the default wall.

### Server-side rules (triggers)

- `prayers` insert/delete → `posts.prayed_count ± 1`
- `comments` insert/delete → `posts.comment_count ± 1`
- `circle_members` insert/delete → `circles.member_count ± 1`
- `reports` insert → if a target has **≥ 3 open reports**, set `status = 'hidden'` until a moderator reviews it
- `posts` insert → rate limit (e.g. at most 5 posts per user per hour) and a basic blocked-word check

### Anonymous posts

`author_id` is **always stored** so moderators can act on abuse. Clients never read `posts`
directly. They read the **`feed_posts` view**, which returns `author_id`, name, and avatar
as `NULL` when `is_anonymous` is set and the viewer isn't the author.
Tell users plainly: _"Hidden from the community, visible to moderators."_

---

## 5. Security (Row Level Security)

A guest is a Supabase anonymous user. Their JWT has `is_anonymous = true`.

| Table | Read | Write |
|---|---|---|
| `feed_posts` (view) | Anyone signed in (including guests): `active`/`answered` posts in public circles or circles they belong to; excludes blocked users | n/a |
| `posts` | No direct select | Insert: **non-guest** members of the circle. Update/delete: author (body, answered, delete) or circle moderator (status) |
| `prayers` | Own rows | Insert/delete own row. **Guests allowed.** |
| `comments` | Same visibility as the parent post | Insert: non-guest. Delete: author or moderator |
| `journal_entries` | **Owner only** | Owner only |
| `saved_posts`, `blocks`, `device_tokens` | Owner only | Owner only |
| `circles` | Public circles: anyone. Private circles: members | Create: non-guest. Update: owner/moderator |
| `circle_members` | Members of the circle | Join public circles yourself. Moderators manage roles |
| `reports` | Circle moderators (for their circle), app admins | Insert: anyone signed in, including guests |

Turning a guest into a real user uses **identity linking** (`linkIdentity` / `updateUser`),
so their prayers, saves, and journal carry over.

RLS gets tested in CI with the Supabase CLI (`supabase test db`, pgTAP).

---

## 6. Milestones

Each milestone ships something usable. Estimates assume part-time solo work.

### M0: Foundation (about 3 days)
- [ ] Remove `.appdata/` from git and add it to `.gitignore`
- [ ] `flutter create --platforms=android,ios .`, set app id (e.g. `com.manalogadiel.prayerwall`), name, and icons
- [ ] Split `main.dart` into the feature folders above. Move theme and shared widgets into `app/` and `core/`.
- [ ] Add Riverpod, go_router, freezed, json_serializable, and stricter `flutter_lints` rules
- [ ] GitHub Actions: `flutter analyze`, `flutter test`, `flutter build web` → deploy to GitHub Pages

### M1: Backend and auth (about 4 days)
- [ ] Create the Supabase project. Add `supabase/` with the CLI and the first migration (all tables, RLS, triggers, `feed_posts` view, seed Everyone circle).
- [ ] App launches into a **guest session automatically** (anonymous sign-in). The feed is visible right away.
- [ ] Sign up and sign in with email + password and **Google**. Forgot password via email link.
- [ ] "Upgrade" prompt when a guest taps **Share** or **comment**: link an identity, keep their data
- [ ] Profile setup on first real sign-in (display name, optional avatar)
- [ ] Accept the community guidelines on sign-up
- [ ] Daily keep-alive cron (GitHub Actions) so the free project doesn't pause

### M2: The wall, for real (about 5 days)
- [ ] Feed from `feed_posts` with cursor pagination (20 per page) and pull-to-refresh
- [ ] Realtime: new posts show a "N new prayers" pill. Prayer counts update live.
- [ ] Composer writes to Supabase (kind, topic, anonymous, circle picker that defaults to the current circle)
- [ ] **I prayed**: optimistic toggle backed by the `prayers` table. Works for guests.
- [ ] Topic chips filter for real. **Following** = posts from joined circles.
- [ ] Post "…" menu: copy link, save, report, and for authors edit, delete, **mark as answered** (with an optional praise note, shown with a ✦ Answered badge)
- [ ] Relative timestamps, empty and error states, skeleton loading

### M3: Circles and Discover (about 4 days)
- [ ] Discover: search, featured circles, topic circles (Healing & Hope, Families, Anxiety & Peace, Gratitude…)
- [ ] Circle page: cover, description, member count, join/leave, its own wall
- [ ] Create a circle (public or private). Private circles join with an invite link or code.
- [ ] Circle roles: owner and moderators
- [ ] Share links: `/c/:slug` and `/c/:slug/p/:id` open the app on mobile or the page on web

### M4: Community and safety (about 4 days). **Required before a public launch.**
- [ ] Comments ("Amen" / encouragement) on a post detail page. Account required.
- [ ] Report a post, comment, or user (reasons: spam, harmful, inappropriate, other)
- [ ] Block a user (hides their content everywhere for you)
- [ ] Moderator queue per circle: hide, remove, dismiss. App-admin queue for Everyone.
- [ ] Auto-hide at 3 reports. Blocked-word list. Posting rate limit.
- [ ] **Delete account** (needed by both stores) through an Edge Function that removes auth user and data
- [ ] Community guidelines and privacy policy pages (`docs/` plus in-app)

### M5: Journal and profile (about 3 days)
- [ ] Private journal: write entries, link one to a wall post, mark answered
- [ ] **Answered prayers** timeline: a gentle record of what God has done
- [ ] Profile: real stats (shared, prayed, saved), my posts, saved posts, edit profile
- [ ] Daily verse from a bundled list of **public-domain (KJV)** verses, so there are no licensing issues
- [ ] Settings: notifications, theme (add a **dark mode** using the same palette), sign out, delete account

### M6: Notifications (about 3 days)
- [ ] Store FCM tokens in `device_tokens` (Android, iOS via APNs key, web push)
- [ ] A database webhook calls an Edge Function that sends FCM. Batched, e.g. _"5 people prayed for your request"_ at most once an hour per post.
- [ ] New comment on your post. Activity in circles you moderate (reports).
- [ ] Optional **daily prayer reminder** with local notifications (no server needed)
- [ ] Notifications bell screen (in-app activity list)

### M7: Release (about 3 days)
- [ ] PWA polish: manifest, icons, offline shell, install prompt, `og:` tags for shared links
- [ ] Accessibility pass: font scaling, semantics labels, contrast, tap targets
- [ ] Android: signed release, **APK on GitHub Releases** (free), then Play Store internal testing ($25)
- [ ] iOS: TestFlight once there's an Apple Developer account ($99/yr)
- [ ] Seed 5–8 starter circles. Invite the first users (e.g. a church group) as beta testers.

**Total: about 4–6 weeks part-time.**

---

## 7. Testing

- **Unit:** repositories (mock Supabase client), notifiers, time formatting, validation
- **Widget:** PrayerCard (prayed toggle, anonymous rendering, answered badge), Composer (disabled when empty, anonymous switch), guest-upgrade prompt
- **Database:** pgTAP tests for RLS. Guests can't post. Anonymous author stays hidden. Journal is private. Triggers keep counts right.
- **Integration (later):** `integration_test` happy path: guest prays → signs up → posts → marks answered
- CI must pass before merging to `main`.

---

## 8. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Sensitive prayer content (health, family) | Anonymous posting, private circles, clear "visible to moderators" copy, account deletion, minimal data collected |
| Spam and abuse on a public app | Guests can't post. Rate limits, word filter, report auto-hide, blocks, moderator queues. |
| Free Supabase project pausing | Daily keep-alive cron. Upgrade path is $25/mo Pro if usage grows. |
| Free-tier limits | Paginate everything. Small images (compress avatars and covers on upload). Watch the usage dashboard. |
| Store review (user-generated content) | Apple and Google require report, block, and delete-account, all in M4 |
| Crisis content (self-harm) | Report reason "someone may be at risk". Show a resources card with hotline info when certain keywords appear. |

---

## 9. Open questions

1. Final app name and package id. Keep "Prayer Wall"?
2. Who are the first app admins and moderators for the Everyone wall?
3. Should circles have a church/organization type (verified badge) later?
4. Languages: English only for v1, or also Filipino/Tagalog?
5. Do we want a "prayer chain" (sign up to pray at a time slot) after v1?

---

## 10. After v1 (ideas)

- Prayer chains and scheduled group prayer times
- Weekly "answered prayers" digest for a circle
- Home-screen widget with today's verse and a prayer to pray for
- Audio prayers / voice notes
- Church admin dashboard (web)
