///<references path="../types/liff.d.ts"/>

/**
 * A wrapper function for Elm.<ElmApp>.init(). This will initialize
 * LIFF application automatically.
 *
 * @example
 *
 * import * as Elm from "./Main.elm";
 * import * as Liff from "./Liff";
 *
 * Liff.init(Elm.Main, {
 *   flags: {
 *     liffId: "<your liff id>",
 *   },
 *   node: document.querySelector("main")
 * })
 * .then(app => Liff.start(app, liff))
 *
 * @param {*} ElmApp is an Elm application. For example: `Elm.Main`.
 * @param {*} config is a configuration for Elm application. This required `liffId` to be appear in config.flags.
 *
 * @returns {Promise} Return Promise of Elm application.
 */
export function init(ElmApp, config) {
  return liff
    .init({ liffId: config.flags.liffId })
    .then(() => ElmApp.init(config))
    .then(app => start(app))
    .catch(err => alert(`ERROR: liff.init(): initialize failed: ${JSON.stringify(err)}`))
}

/**
 * Install LIFF ports extension into to an application.
 * @param {*} app
 */
function start(app) {
  app.ports.liffOutbound.subscribe(([method, data]) => {
    switch (method) {
      case 'closeWindow':
        handleCloseWindow(app, data)
        break;
      case 'getAccessToken':
        handleGetAccessToken(app, data)
        break;
      case 'getProfile':
        handleGetProfile(app, data)
        break;
      case 'getLanguage':
        handleGetLanguage(app, data)
        break;
      case 'getVersion':
        handleGetVersion(app, data)
        break;
      case 'isLoggedIn':
        handleIsLoggedIn(app, data)
        break;
      case 'openWindow':
        handleOpenWindow(app, data)
        break;
      case 'sendMessages':
        handleSendMessages(app, data)
        break;
    }
  })
}

/**
 * closeWindow handler.
 * @param {liff} liff
 */
function handleCloseWindow(app, _) {
  liff.closeWindow()
}

/**
 * getAccessToken handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetAccessToken(app, _) {
  app.ports.liffInbound.send(['getAccessToken', liff.getAccessToken()])
}

/**
 * getLanguage handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetLanguage(app, _) {
  app.ports.liffInbound.send(['getLanguage', liff.getLanguage()])
}

/**
 * getUserProfile handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetProfile(app, _) {
  liff
    .getProfile()
    .then(profile => app.ports.liffInbound.send(['getProfile', profile]))
    .catch(err => `liff.getProfile: have problems while getting a user profile: ${JSON.stringify(err)}`)
}

/**
 * getVersion handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetVersion(app, _) {
  app.ports.liffInbound.send(['getVersion', liff.getVersion()])
}

/**
 * isLoggedIn handler.
 * @param {*} app
 */
function handleIsLoggedIn(app, _) {
  app.ports.liffInbound.send(['isLoggedIn', liff.isLoggedIn()])
}

/**
 * openWindow handler.
 * @param {liff} liff
 * @param {*} param
 */
function handleOpenWindow(app, param) {
  liff.openWindow(param)
}

/**
 * sendMessages handler.
 * @param {liff} liff
 * @param {*} messages
 */
function handleSendMessages(app, messages) {
  liff
    .sendMessages(messages)
    .catch(err => `liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`)
}
