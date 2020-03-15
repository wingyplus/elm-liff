declare module liff {
  type UserProfile = {
    userId: string
    displayName: string
    pictureUrl: string
    statusMessage?: string
  }

  type UrlParams = {
    url: string,
    external: boolean
  }

  /**
   * Closes the LIFF app.
   */
  function closeWindow(): void;

  /**
   * Gets the current user's access token.
   */
  function getAccessToken(): string

  /**
   * Gets the language settings of the environment in which the LIFF app
   * is running.
   */
  function getLanguage(): string

  /**
   * Gets the current user's profile.
   */
  function getProfile(): Promise<UserProfile>


  /**
   * Gets the version of the LIFF SDK.
   */
  function getVersion(): string

  /**
   * Checks whether the user is logged in.
   */
  function isLoggedIn(): boolean;


  /**
   * Initializes a LIFF app.
   * @param config LIFF app ID.
   * @param successCallback Callback to return a data object upon successful initialization of the LIFF app.
   * @param errorCallback Callback to return an error object upon failure to initialize the LIFF app.
   */
  function init(config: { liffId: string }, successCallback?: Function, errorCallback?: Function): Promise<any>;

  /**
   * Opens the specified URL in the in-app browser of LINE or external browser.
   * @param params parameters for opening url.
   */
  function openWindow(params: UrlParams): void

  /**
   * Sends messages on behalf of the user to the chat screen where the LIFF
   * app is opened. If the LIFF app is opened on a screen other than the
   * chat screen, messages cannot be sent.
   * @param messages
   */
  function sendMessages(messages: Array<Object>): Promise<any>;
}
