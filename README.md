# elm-liff - Elm ports for LIFF application

This library provides Elm ports for who want to uses
Elm on LIFF application.

## How to use

I didn't have a fully documentation yet. But
you can see in `src/demo.js` and `src/Demo.elm` about
how to use it.

## Limitation

This library doesn't support a javascript that didn't 
bundler tool such as webpack or parcel yet and I didn't 
have any plan to make it support.

## Support

Here is the list that this library already supported:

- [ ] liff.init()
- [ ] liff.ready
- [ ] liff.getOS()
- [ ] liff.getLanguage()
- [ ] liff.getVersion()
- [ ] liff.isInClient()
- [x] liff.isLoggedIn()
- [ ] liff.login()
- [ ] liff.logout()
- [ ] liff.getAccessToken()
- [ ] liff.getContext()
- [ ] liff.getDecodedIDToken()
- [x] liff.getProfile()
- [ ] liff.getFriendship()
- [x] liff.sendMessages()
- [x] liff.openWindow()
- [ ] liff.shareTargetPicker()
- [ ] liff.scanCode()
- [x] liff.closeWindow()
- [ ] liff.initPlugins()
- [ ] liff.bluetooth.getAvailability()
- [ ] liff.bluetooth.requestDevice()
- [ ] liff.bluetooth.referringDevice


## Credit

- Most of doc comments are copied from [LIFF documentation](https://developers.line.biz/en/reference/liff/).
- Ellie app for inspire me about ports design. 
- ["The importance of ports"](https://www.youtube.com/channel/UCOpGiN9AkczVjlpGDaBwQrQ). This video might 
  look too old but it's a great about ports design.

