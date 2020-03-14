declare module liff {
  type UserProfile = {
    userId: string
    displayName: string
    pictureUrl: string
    statusMessage?: string
  }

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

  /**
   * Gets the current user's profile.
   */
  function getProfile(): Promise<UserProfile>

  /**
   * Opens the specified URL in the in-app browser of LINE or external browser.
   * @param param0
   */
  function openWindow({ url: string, external: boolean }): void
}
