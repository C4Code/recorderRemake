//
//  AudioFileRecorder.h
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import "C4DateTime.h"

@interface AudioFileRecorder : C4Object <AVAudioRecorderDelegate>
-(void)recordAudioFile;
-(void)recordAudioFileWithId:(NSInteger)sampleId;
-(void)stopRecording;
-(void)deleteAudioFile;
-(void)prepareForRemoval;

@property (readwrite, strong) NSURL *fileURL;
@property (readwrite, getter = isFinishedRecording) BOOL finishedRecording;
@end
