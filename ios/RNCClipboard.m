#import "RNCClipboard.h"


#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation RNCClipboard

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(setString:(NSString *)content)
{
  UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
  clipboard.string = (content ? : @"");
}

RCT_EXPORT_METHOD(hasImage:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    NSString* clipData = clipboard.string ? : nil;
    if(clipData) {
        if([clipData hasPrefix:@"data:image/"]) {
            resolve(@"image-encoded");
            return;
        }
        NSURL *url = [NSURL URLWithString:clipData];
        if (url && url.scheme && url.host && url.path) {
            resolve(@"web-url");
            return;
        }
    } else {
        if([clipboard image]) {
            resolve(@"image");
            return;
        }
    }
    resolve(nil);
    return;
}

RCT_EXPORT_METHOD(getString:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
  UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
  NSString* clipData = clipboard.string ? : nil;
  if(!clipData) {
      NSString* typeStr = @"data:image/jpeg;base64,";
      NSData* pasteData = [clipboard dataForPasteboardType:(NSString*)kUTTypeJPEG];
      if(!pasteData) {
          typeStr = @"data:image/png;base64,";
          pasteData = [clipboard dataForPasteboardType:(NSString*)kUTTypePNG];
      }
      if(!pasteData) {
          typeStr = @"data:image/gif;base64,";
          pasteData = [clipboard dataForPasteboardType:(NSString*)kUTTypeGIF];
      }
    if(pasteData) {
        clipData = [pasteData base64EncodedStringWithOptions:0];
        clipData = [typeStr stringByAppendingString:clipData];
    }
  }
  resolve(clipData);
}

@end
