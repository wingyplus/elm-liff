/**
 * Install LIFF ports extension into to the application.
 * @param {*} app 
 * @param {*} liff 
 */
export function start(app, liff) {
  app.ports.liffOutbound.subscribe((evt) => {
    console.log(JSON.stringify(evt))

    switch (evt.method) {
      case 'sendMessages':
        liff
          .sendMessages(evt.data)
          .catch((err) => console.log(`liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`))

      case 'isLoggedIn':
        app.ports.liffInbound.send({
          method: 'isLoggedIn',
          data: liff.isLoggedIn(),
        })
    }
  })
}
