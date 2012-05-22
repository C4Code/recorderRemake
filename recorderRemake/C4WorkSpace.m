//
//  C4WorkSpace.m
//  recorderRemake
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "RecorderShape.h"
@interface C4WorkSpace () 
-(void)addRecorderShape;
-(void)removeRecorders;
@end

@implementation C4WorkSpace

-(void)setup {
    [C4DateTime millis];
    for(int i = 0; i < 15; i++) {
        [self addRecorderShape];
    }
    NSTimer *t = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(addRecorderShape) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];

    NSTimer *u = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(removeRecorders) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:u forMode:NSDefaultRunLoopMode];
}

-(void)addRecorderShape {
    if([self.canvas.subviews count] < 15) {
        RecorderShape *rs = [RecorderShape new];
        [self.canvas addShape:rs];
    }
}

-(void)removeRecorders {
    for(RecorderShape *rs in self.canvas.subviews){
        if(rs.isReadyToBeRemoved == YES) {
            [rs removeFromSuperview];
        }
    }
}

@end
