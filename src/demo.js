import {Elm} from './Demo.elm';
import * as Liff from './Liff';

// eslint-disable-next-line require-jsdoc
function main() {
  initializeDebugger();
  Liff.init(Elm.Demo, {
    flags: {
      liffId: process.env.LIFF_ID,
    },
    node: document.querySelector('main'),
  }).catch((err) => alert(err));
}

// eslint-disable-next-line require-jsdoc
function initializeDebugger() {
  if (process.env.DEBUG === '1') {
    new VConsole();
  }
}

main();
