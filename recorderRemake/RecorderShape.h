//
//  RecorderShape.h
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"
#import "AudioFileRecorder.h"
#import "MeteringSample.h"
#import "C4DateTime.h"

@interface RecorderShape : C4Shape
@property (readwrite, getter = isReadyToBeRemoved) BOOL readyToBeRemoved;
@end
