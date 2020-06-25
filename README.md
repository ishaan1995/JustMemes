# Just Memes
[![Netlify Status](https://api.netlify.com/api/v1/badges/cea2d4c8-9aff-487d-99e2-a7e78cc2a534/deploy-status)](https://app.netlify.com/sites/funnymemes/deploys)
[![Codemagic build status](https://api.codemagic.io/apps/5c817a6e767952001df7085c/5c817a6e767952001df7085b/status_badge.svg)](https://codemagic.io/apps/5c817a6e767952001df7085c/5c817a6e767952001df7085b/latest_build)

Best of insta memes.

![](art/just_memes_demo.gif "Demo")

TODO:
- Basic 1 small poc done.
- Read around instagram api - how to connect, get feed of channels (28 April, 2020)
- Get a name, logo some design help from saurav if required.
- Public an mvp on store - get feed of memes based on topics - small apk. experiment with the market (2-3 rd May 2020 launch).
- Connect to facebook, 9gag, other memes sites or scrap - later on based on outcome.

## Deploy for Web

```
flutter build web
```

## Deploy for Android

Create split apk for smallest size as per hardware.
```
flutter build apk --split-per-abi --release
```
