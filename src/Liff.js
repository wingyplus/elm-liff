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
        handleSendMessages(liff, data)
        break;
      case 'isLoggedIn':
        handleIsLoggedIn(app)
        break;
      case 'closeWindow':
        handleCloseWindow(liff)
        break;
    }
  })
}

/**
 * sendMessages handler.
 * @param {liff} liff
 * @param {*} messages
 */
function handleSendMessages(liff, messages) {
  liff
    .sendMessages(messages)
    .catch(err => `liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`)
}

/**
 * isLoggedIn handler.
 * @param {*} app
 */
function handleIsLoggedIn(app) {
  app.ports.liffInbound.send(['isLoggedIn', liff.isLoggedIn()])
}

/**
 * closeWindow handler.
 * @param {liff} liff
 */
function handleCloseWindow(liff) {
  liff.closeWindow()
}