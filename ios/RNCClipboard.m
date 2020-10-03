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

RCT_EXPORT_METHOD(getString:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
  UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
  NSString* clipData = clipboard.string ? : nil;
  if(!clipData) {
    NSData* pasteData = [clipboard dataForPasteboardType:(NSString*)kUTTypeJPEG];
    if(pasteData) {
        clipData = [pasteData base64EncodedStringWithOptions:0];
        clipData = [@"data:image/jpeg;base64," stringByAppendingString:clipData];
    }
  }
  resolve(clipData);
}

@end
