/**
 * Install LIFF ports extension into to the application.
 * @param {*} app 
 * @param {*} liff 
 */
export function initialize(app, liff) {
  app.ports.sendEvent.subscribe((evt) => {
    console.log(JSON.stringify(evt))

    switch (evt.method) {
      case 'sendMessages':
        liff
          .sendMessages(evt.params)
          .catch((err) => console.log(`liff.sendMessages: have problems while sending messages: ${JSON.stringify(err)}`))
    }
  })
}
