/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package com.reactnativecommunity.clipboard;

import android.content.ClipboardManager;
import android.content.ClipData;
import android.content.Context;
import android.webkit.MimeTypeMap;
import android.net.Uri;
import java.net.URL;

import com.facebook.react.bridge.ContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.module.annotations.ReactModule;

/**
 * A module that allows JS to get/set clipboard contents.
 */
@ReactModule(name = ClipboardModule.NAME)
public class ClipboardModule extends ContextBaseJavaModule {

  public ClipboardModule(Context context) {
    super(context);
  }

  public static final String NAME = "RNCClipboard";

  @Override
  public String getName() {
    return ClipboardModule.NAME;
  }

  private ClipboardManager getClipboardService() {
    return (ClipboardManager) getContext().getSystemService(getContext().CLIPBOARD_SERVICE);
  }


  @ReactMethod
  public void hasImage(Promise promise) {
    try {
      ClipboardManager clipboard = getClipboardService();
      ClipData clipData = clipboard.getPrimaryClip();
      if (clipData != null && clipData.getItemCount() >= 1) {
        ClipData.Item firstItem = clipboard.getPrimaryClip().getItemAt(0);
        String clipText = firstItem.getText().toString();
        if(clipText != null && clipText.length() > 0) {
          if(clipText.startsWith("data:image/")) {
            promise.resolve("image-encoded");
          } else {
            try {
                new URL(clipText);
            } catch (Exception e) {
              promise.resolve("");
              return;
            }
            if(clipText.endsWith(".html") || clipText.endsWith(".txt")) {
              promise.resolve("");
              return;
            }
            String ext = MimeTypeMap.getFileExtensionFromUrl(clipText).toLowerCase();
            if(ext == "jpg" || ext == "png" || ext == "gif" || ext == "tiff") {
              promise.resolve("image");
              return;
            }
            if(clipText.startsWith("http")) {
              promise.resolve("web-url");
            } else {
              promise.resolve("image");
            }
          }
        } else {
          Uri uri = firstItem.getUri();
          if(uri != null && uri.toString().length() > 0) {
            String ext = MimeTypeMap.getFileExtensionFromUrl(uri.toString()).toLowerCase();
            if(ext == "jpg" || ext == "png" || ext == "gif" || ext == "tiff") {
              promise.resolve("image");
              return;
            }
          }
          promise.resolve("");
        }
      } else {
        promise.resolve("");
      }
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ReactMethod
  public void getString(Promise promise) {
    try {
      ClipboardManager clipboard = getClipboardService();
      ClipData clipData = clipboard.getPrimaryClip();
      if (clipData != null && clipData.getItemCount() >= 1) {
        ClipData.Item firstItem = clipboard.getPrimaryClip().getItemAt(0);
        promise.resolve("" + firstItem.getText());
      } else {
        promise.resolve("");
      }
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ReactMethod
  public void setString(String text) {
    ClipData clipdata = ClipData.newPlainText(null, text);
    ClipboardManager clipboard = getClipboardService();
    clipboard.setPrimaryClip(clipdata);
  }
}
