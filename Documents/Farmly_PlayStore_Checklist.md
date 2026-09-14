# Farmly — Google Play Store Submission Checklist

## 1. Developer Account
- [ ] Create a Google Play Console developer account (one-time $25 fee)
- [ ] Complete identity verification (may take a few days — start this early)

## 2. App Build & Signing
- [ ] Generate a release keystore (`keytool -genkey -v -keystore farmly.keystore ...`) — back this up safely, it cannot be recovered if lost
- [ ] Configure `key.properties` in the Flutter project for release signing
- [ ] Build the release App Bundle: `flutter build appbundle --release`
- [ ] Test the release build on a real device before uploading

## 3. Store Listing Assets
- [ ] App icon — 512x512 px, PNG, no transparency
- [ ] Feature graphic — 1024x500 px
- [ ] Phone screenshots — at least 2, ideally 4-8 (use your Figma/Stitch exports, run through a device frame if possible)
- [ ] Short description — under 80 characters
- [ ] Full description — up to 4000 characters, explain the problem Farmly solves and its key features
- [ ] App category — likely "Business" or "Lifestyle" (check which fits agriculture apps best in current Play Console categories)

## 4. Privacy & Compliance
- [ ] Write and host a Privacy Policy (required — can be a simple static page, e.g. hosted on GitHub Pages or Vercel alongside your admin dashboard)
- [ ] Complete the Play Console **Data Safety** section — declare what data you collect (phone number, location, photos) and why
- [ ] Complete the **Content Rating** questionnaire
- [ ] Declare permissions used (camera, location, phone) and justify each in the listing if asked

## 5. Testing Tracks (use before full public release)
- [ ] Upload to **Internal Testing** track first — instant availability to testers you add by email, no review wait
- [ ] Share the opt-in link with your supervisor/examiners for demo purposes
- [ ] Optionally promote to **Closed Testing** or **Open Testing** if you want broader feedback before going live

## 6. Final Submission
- [ ] Move build to **Production** track when ready for public release
- [ ] Submit for review (standard review can take a few hours to a few days)
- [ ] Monitor the Play Console for any policy rejections and address promptly

## Notes
- For your final year project demo, the **Internal Testing** track is usually sufficient — you don't need to go to full production/public release unless you want the app publicly listed.
- Keep your keystore file and passwords backed up outside the project repo (never commit them to GitHub).
