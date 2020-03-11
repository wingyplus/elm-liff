import { Elm } from "./Demo.elm"
import * as LiffExt from "./LiffExtension"

function main(liff) {
  initializeDebugger()
  liff
    .init({
      liffId: `${process.env.LIFF_ID}`
    })
    .then(
      () => {
        console.log("logged in: " + liff.isLoggedIn())
        console.log("is in client: " + liff.isInClient())
        console.log("Initializing Elm application...")
        initializeApp(liff)
      },
    )
    .catch((err) => console.log(`liff.init: have some problems while initialize: ${JSON.stringify(err)}`))
}

function initializeDebugger() {
  const _ = new VConsole()
}

function initializeApp(liff) {
  const app = Elm.Demo.init({
    node: document.querySelector('main')
  })
  LiffExt.initialize(app, liff);
}

main(liff)
