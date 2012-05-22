//
//  RecorderShape.m
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "RecorderShape.h"
@interface RecorderShape ()
-(void)begin;
-(void)startRecording;
-(void)stopRecording;
-(void)prepareForPlayback:(NSNotification *)notification;
-(void)play;
-(void)displayAudioSampleMeters;
-(void)fadeOut;
-(void)stopPlaying;
//-(void)removeFile;
//-(void)removeRecorder;
-(void)startMeters;
-(void)prepareForRemoval;
-(void)moveToRandomPosition;

@property (readwrite) CGFloat lifeSpan;
@property (readwrite) NSInteger objectID;
@property (readwrite, strong) AudioFileRecorder *fileRecorder;
@property (readwrite, strong) MeteringSample *audioSample;
@property (readwrite, strong) C4Shape *backgroundShape;
@property (readwrite, strong) UIColor *color;
@property (readwrite, strong) NSTimer *meterTimer, *movementTimer;
@property (readwrite) BOOL shouldRecord;
@end

@implementation RecorderShape
@synthesize objectID, fileRecorder, audioSample, backgroundShape, color, meterTimer, movementTimer, shouldRecord, lifeSpan, readyToBeRemoved;
-(id)init {
    self = [super init];
    if(self != nil) {
        self.fileRecorder = [AudioFileRecorder new];
        self.color = C4GREY;
        self.objectID = [C4DateTime millis];
        self.fillColor = [UIColor clearColor];
        self.animationDuration = 0.0f;

        [self ellipse:CGRectMake([C4Math randomInt:768], [C4Math randomInt:1024], 80, 80)];
        self.backgroundShape = [C4Shape ellipse:CGRectMake(0, 0, 80, 80)];
        self.backgroundShape.animationDuration = 0.0f;
        self.backgroundShape.fillColor = self.fillColor;
        [self addSubview:self.backgroundShape];
        
        self.movementTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(moveToRandomPosition) userInfo:nil repeats:YES];
        self.shouldRecord = YES;
        [self performSelector:@selector(begin) withObject:self afterDelay:1.0f];
        self.readyToBeRemoved = NO;
    }
    return self;
}

-(void)begin {
    [[NSRunLoop mainRunLoop] addTimer:self.movementTimer forMode:NSDefaultRunLoopMode];
    [self startRecording];
}

-(void)prepareForPlayback {
    if(self.fileRecorder.isFinishedRecording) {
        self.audioSample = [MeteringSample sampleURL:self.fileRecorder.fileURL];
        [self.audioSample prepareToPlay];
        [self play];
    } else {
        [self performSelector:@selector(prepareForPlayback) withObject:nil afterDelay:0.25];
    }
}

-(void)play {
    if(self.audioSample.isPlaying == NO) {
        [self.audioSample play];
        [self startMeters];
        self.lifeSpan = [C4Math randomInt:5]+5.0f;
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:self.lifeSpan];
    }
}

-(void)stopPlaying {
    [self.audioSample stop];
    [self stopMoving];
}

-(void)fadeOut {
    if (self.audioSample.volume > 0.0f) {
        self.audioSample.volume -= 0.01f;
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f/30.0f];
    } else {
        [self performSelector:@selector(stopPlaying) withObject:nil afterDelay:[movementTimer timeInterval] + 0.1];
        [meterTimer invalidate];
        [movementTimer invalidate];
    }
}

-(void)startRecording {
    if(self.shouldRecord == YES) {
        [self.fileRecorder recordAudioFileWithId:self.objectID];
        [self performSelector:@selector(stopRecording) withObject:nil afterDelay:1.0];
        self.shouldRecord = NO;
    }
}

-(void)startMeters {
    [self.audioSample startUpdatingMeters];
    self.meterTimer = [NSTimer timerWithTimeInterval:1/15.0f 
                                              target:self 
                                            selector:@selector(displayAudioSampleMeters) 
                                            userInfo:nil 
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.meterTimer forMode:NSDefaultRunLoopMode];
}

-(void)displayAudioSampleMeters {
        CGFloat a = [C4Math pow:10 raisedTo:0.05 * [self.audioSample.player averagePowerForChannel:0]]*5;
        self.backgroundShape.animationDuration = 0.0f;
        @try {
            self.backgroundShape.fillColor = [self.color colorWithAlphaComponent:a];
        }
        @catch (NSException *exception) {
            C4Log(@"%@",exception);
        }
    }

-(void)stopRecording {
    [self.fileRecorder stopRecording];
    [self prepareForPlayback];
}

-(void)stopMoving {
    [self performSelector:@selector(prepareForRemoval) withObject:nil afterDelay:[self.movementTimer timeInterval]];
    [self.movementTimer invalidate];
    [self prepareForRemoval];
}

-(void)prepareForRemoval {
    [self.meterTimer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.readyToBeRemoved = YES;
}

-(void)moveToRandomPosition {
    self.animationDuration = 1.0f;
    self.center = CGPointMake([C4Math randomInt:768],[C4Math randomInt:1024]);
}

@end
