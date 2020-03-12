/**
 * Install LIFF ports extension into to the application.
 * @param {*} app 
 * @param {*} liff 
 */
export function start(app, liff) {
  app.ports.liffOutbound.subscribe(([method, data]) => {
    switch (method) {
      case 'sendMessages':
        liff
          .sendMessages(data)
          .catch((err) => console.log(`liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`))

      case 'isLoggedIn':
        app.ports.liffInbound.send(['isLoggedIn', liff.isLoggedIn()])
    }
  })
}
