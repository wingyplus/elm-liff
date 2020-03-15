import { Elm } from "./Demo.elm"
import * as Liff from "./Liff"

function main() {
  initializeDebugger()
  Liff.init(Elm.Demo, {
    flags: {
      liffId: process.env.LIFF_ID,
    },
    node: document.querySelector('main')
  }).catch(err => alert(err))
}

function initializeDebugger() {
  if (process.env.DEBUG === "1") {
    const _ = new VConsole()
  }
}

main()
