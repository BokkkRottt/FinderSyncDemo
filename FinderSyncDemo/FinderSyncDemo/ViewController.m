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
    [self.view addToolTipRect:NSMakeRect(0,0,30,30) owner:self userData:NULL];
}

- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)data
{
    
    // use the tags to determine which rectangle is under the mouse
    if (tag == 1) {
        return NSLocalizedString(@"The Blue rectangle", @"");
    }
    if (tag == 2) {
        return NSLocalizedString(@"The Blue rectangle", @"");
    }
    // we should never get to here!
    return NSLocalizedString(@"Unknown tooltip area", @"");
}

@end
