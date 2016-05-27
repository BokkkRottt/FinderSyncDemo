//
//  ViewController.m
//  FinderSyncDemo
//
//  Created by Yang on 12/2/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)myAction:(id)sender
{
    [[NSWorkspace sharedWorkspace] openFile:NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject];
}


@end
