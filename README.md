# elm-liff - Elm ports for LIFF application

Provides a LIFF SDK 2.+ ports for Elm application.

## How to use

1. Add LIFF SDK to your html tag.
2. Download `src/Liff.elm` and `src/Liff.js` to your src directory.
3. Add `Liff.init(elmApp, {flags: {liffId: "your liff id"}})` to your code.
4. Done.

If it won't work or you have a problem, you can see an example
in `src/demo.js` or open an issue.

## Limitation

- This library doesn't support a javascript that didn't
  use bundler tool such as webpack or parcel yet and I didn't
  have any plan to make it support.
- This library didn't call `liff.init()` for you. You needs
  to do it manually.

## Support

Here is the list that this library already supported:

- [ ] liff.init()
- [ ] liff.ready
- [ ] liff.getOS()
- [x] liff.getLanguage()
- [x] liff.getVersion()
- [ ] liff.isInClient()
- [x] liff.isLoggedIn()
- [ ] liff.login()
- [ ] liff.logout()
- [x] liff.getAccessToken()
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

- Most of documentation comments are copied from [LIFF documentation](https://developers.line.biz/en/reference/liff/).
- Ellie app for inspire me about ports design.
- ["The importance of ports"](https://www.youtube.com/channel/UCOpGiN9AkczVjlpGDaBwQrQ). This video might
  look too old but it's a great about ports design.

## Feedback are welcome.

As you know that ports module is couple with application module. That's means
I cannot publish it to elm package registry yet. So I love to see that
how do we manage this kind of library. If you have any feedback, I love to
hear from you. :)
