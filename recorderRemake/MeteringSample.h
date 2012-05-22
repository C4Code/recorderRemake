//
//  MySample.h
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Sample.h"

@interface MeteringSample : C4Sample <AVAudioPlayerDelegate>
+(MeteringSample *)sampleURL:(NSURL *)sampleURL;
-(id)initWithURL:(NSURL *)sampleURL;
-(void)startUpdatingMeters;
@property (readwrite, strong) AVAudioPlayer* player;
@end