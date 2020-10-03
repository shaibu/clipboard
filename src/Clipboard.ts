import NativeClipboard from './NativeClipboard';

/**
 * `Clipboard` gives you an interface for setting and getting content from Clipboard on both iOS and Android
 */
export const Clipboard = {
  /**
   * Get type of image data in clipboard, this method returns a `Promise`.
   * ```
   */
  hasImage(): Promise<string> {
    return NativeClipboard.hasImage();
  },
  /**
   * Get content of string type, this method returns a `Promise`, so you can use following code to get clipboard content
   * ```javascript
   * async _getContent() {
   *   var content = await Clipboard.getString();
   * }
   * ```
   */
  getString(): Promise<string> {
    return NativeClipboard.getString();
  },
  /**
   * Set content of string type. You can use following code to set clipboard content
   * ```javascript
   * _setContent() {
   *   Clipboard.setString('hello world');
   * }
   * ```
   * @param the content to be stored in the clipboard.
   */
  setString(content: string) {
    NativeClipboard.setString(content);
  },
};
