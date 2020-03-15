///<references path="../types/liff.d.ts"/>

/**
 * Install LIFF ports extension into to the application.
 * @param {*} app
 * @param {liff} liff
 */
export function start(app, liff) {
  app.ports.liffOutbound.subscribe(([method, data]) => {
    switch (method) {
      case 'sendMessages':
        handleSendMessages(app, liff, data)
        break;
      case 'isLoggedIn':
        handleIsLoggedIn(app, liff, data)
        break;
      case 'closeWindow':
        handleCloseWindow(app, liff, data)
        break;
      case 'getProfile':
        handleGetProfile(app, liff, data)
        break;
      case 'openWindow':
        handleOpenWindow(app, liff, data)
        break;
      case 'getAccessToken':
        handleGetAccessToken(app, liff, data)
        break;
    }
  })
}

/**
 * sendMessages handler.
 * @param {liff} liff
 * @param {*} messages
 */
function handleSendMessages(app, liff, messages) {
  liff
    .sendMessages(messages)
    .catch(err => `liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`)
}

/**
 * isLoggedIn handler.
 * @param {*} app
 */
function handleIsLoggedIn(app, liff, data) {
  app.ports.liffInbound.send(['isLoggedIn', liff.isLoggedIn()])
}

/**
 * closeWindow handler.
 * @param {liff} liff
 */
function handleCloseWindow(app, liff, data) {
  liff.closeWindow()
}

/**
 * getUserProfile handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetProfile(app, liff, data) {
  liff
    .getProfile()
    .then(profile => app.ports.liffInbound.send(['getProfile', profile]))
    .catch(err => `liff.getProfile: have problems while getting a user profile: ${JSON.stringify(err)}`)
}

/**
 * openWindow handler.
 * @param {liff} liff
 * @param {*} data
 */
function handleOpenWindow(app, liff, data) {
  liff.openWindow(data)
}

/**
 * getAccessToken handler.
 * @param {*} app
 * @param {liff} liff
 */
function handleGetAccessToken(app, liff, data) {
  app.ports.liffInbound.send(['getAccessToken', liff.getAccessToken()])
}
