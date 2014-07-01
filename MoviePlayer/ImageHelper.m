

#import "ImageHelper.h"
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@implementation ImageHelper{
	
}

- (id)init{
	self = [super init];
	if (self){
		
	}
	
	return self;
}

- (UIImage *)createImageFromPath:(NSString *)path{
	
	NSURL *url = [NSURL fileURLWithPath:path];
	AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
	AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
	gen.appliesPreferredTrackTransform = YES;
	
	Float64 durationSeconds = CMTimeGetSeconds(asset.duration);
	CMTime time = CMTimeMakeWithSeconds(durationSeconds/2, 600);
	//CMTime time = CMTimeMakeWithSeconds(0.0, 600);
	NSError *error = nil;
	CMTime actualTime;
	
	CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
	UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
	
	return thumb;
}

@end
