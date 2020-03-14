declare module liff {
  /**
   * Sends messages on behalf of the user to the chat screen where the LIFF
   * app is opened. If the LIFF app is opened on a screen other than the
   * chat screen, messages cannot be sent.
   * @param messages
   */
  function sendMessages(messages: Array<Object>): Promise<any>;

  /**
   * Checks whether the user is logged in.
   */
  function isLoggedIn(): boolean;

  /**
   * Closes the LIFF app.
   */
  function closeWindow(): void;
}
