//
//  FinderSync.m
//  DemoFinderSync
//
//  Created by Yang on 12/2/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import "FinderSync.h"
#import "FinderSyncController.h"

typedef void (^URLActionBlock)(NSURL * obj, NSUInteger idx, BOOL *stop);

@interface FinderSync ()

@property NSURL *myFolderURL;

@end

@implementation FinderSync
{
    FinderSyncController * finderSyncController; //You can create menu from IB.
}

- (instancetype)init {
    self = [super init];

    self.myFolderURL = [NSURL fileURLWithPath:@"/Users/yang/Desktop/1.localized"];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:self.myFolderURL];

    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameColorPanel] label:@"Status One" forBadgeIdentifier:@"Color"];
    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameCaution] label:@"Status Two" forBadgeIdentifier:@"Caution"];
    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameUser] label:@"Status Two" forBadgeIdentifier:@"User"];
    
    return self;
}

#pragma mark - Primary Finder Sync protocol methods
- (void)beginObservingDirectoryAtURL:(NSURL *)url {

}


- (void)endObservingDirectoryAtURL:(NSURL *)url {

}

- (void)requestBadgeIdentifierForURL:(NSURL *)url {
    NSInteger whichBadge = [url.path length] % 3;
    NSString* badgeIdentifier = @[@"User", @"Color", @"Caution"][whichBadge];
    [[FIFinderSyncController defaultController] setBadgeIdentifier:badgeIdentifier forURL:url];
}

#pragma mark - Menu and toolbar item support
- (NSString *)toolbarItemName {
    return @"AnyShare";
}

- (NSString *)toolbarItemToolTip {
    return @"AnyShare: 使用AnyShare相关的功能";
}

- (NSImage *)toolbarItemImage {
    NSImage * toolBarIcon = [NSImage imageNamed:@"Menu"];
    toolBarIcon.template = YES;
    return toolBarIcon;
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    NSMenu *menu = nil;
    
    switch (whichMenu) {
        case FIMenuKindToolbarItemMenu:
            menu = [self toolbarMenu];
            break;
        case FIMenuKindContextualMenuForContainer:
            menu = [self directoryMenu];
            break;
        case FIMenuKindContextualMenuForItems:
            menu = [self fileMenu];
            break;
        default:
            break;
    }

    return menu;
}


#pragma mark - Actions
- (IBAction)makeCaution:(id)sender {
    [self actionToSelectedURLs:^(NSURL * obj, NSUInteger idx, BOOL *stop) {
        [[FIFinderSyncController defaultController] setBadgeIdentifier:@"Caution" forURL:obj];
    }];
}

- (IBAction)makeColor:(id)sender {
    [self actionToSelectedURLs:^(NSURL * obj, NSUInteger idx, BOOL *stop) {
        [[FIFinderSyncController defaultController] setBadgeIdentifier:@"Color" forURL:obj];
    }];
}

- (IBAction)makeUser:(id)sender {
    [self actionToSelectedURLs:^(NSURL * obj, NSUInteger idx, BOOL *stop) {
        [[FIFinderSyncController defaultController] setBadgeIdentifier:@"User" forURL:obj];
    }];
}

- (IBAction)gotoMyFolder:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:self.myFolderURL];
}

- (void)actionToSelectedURLs:(URLActionBlock)action
{
    NSArray* items = [FIFinderSyncController defaultController].selectedItemURLs;
    if (items.count) {
        [items enumerateObjectsUsingBlock:^(NSURL * obj, NSUInteger idx, BOOL * stop) {
            if (![self fileUrlIsInvisible:obj]) {
                action(obj, idx, stop);
            }
        }];
    }
    else {
        action([FIFinderSyncController defaultController].targetedURL, 0, nil);
    }
    
}

#pragma mark - Menus
- (NSMenu *)toolbarMenu
{
    NSMenu *menu = nil;
    if ([self toolBarMenuRequestFromMyFolder]) {
        menu = [[NSMenu alloc] initWithTitle:@""];
        NSMenuItem * makeCautionItem = [[NSMenuItem alloc] initWithTitle:@"Make Caution" action:@selector(makeCaution:) keyEquivalent:@""];
        makeCautionItem.image = [NSImage imageNamed: NSImageNameCaution];
        NSMenuItem * makeColorItem = [[NSMenuItem alloc] initWithTitle:@"Make Corlor" action:@selector(makeColor:) keyEquivalent:@""];
        makeColorItem.image = [NSImage imageNamed:NSImageNameColorPanel];
        NSMenuItem * makeUserItem = [[NSMenuItem alloc] initWithTitle:@"Make User" action:@selector(makeUser:) keyEquivalent:@""];
        makeUserItem.image = [NSImage imageNamed:NSImageNameUser];
        
        [menu addItem:makeCautionItem];
        [menu addItem:makeColorItem];
        [menu addItem:makeUserItem];
    }
    else {
        menu = [[NSMenu alloc] initWithTitle:@""];
        NSMenuItem * gotoItem = [[NSMenuItem alloc] initWithTitle:@"Goto AnyShare Folder" action:@selector(gotoMyFolder:) keyEquivalent:@""];
        [menu addItem:gotoItem];
    }
    
    return menu;
}

- (NSMenu *)fileMenu
{
    if (![self validateFileMenu]) {
        return nil;
    }
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:@"AnyShare" action:nil keyEquivalent:@""];
    menuItem.image = [NSImage imageNamed:@"Menu"];
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem * makeCautionItem = [[NSMenuItem alloc] initWithTitle:@"Make Caution" action:@selector(makeCaution:) keyEquivalent:@""];
    makeCautionItem.image = [NSImage imageNamed: NSImageNameCaution];
    NSMenuItem * makeColorItem = [[NSMenuItem alloc] initWithTitle:@"Make Corlor" action:@selector(makeColor:) keyEquivalent:@""];
    makeColorItem.image = [NSImage imageNamed:NSImageNameColorPanel];
    NSMenuItem * makeUserItem = [[NSMenuItem alloc] initWithTitle:@"Make User" action:@selector(makeUser:) keyEquivalent:@""];
    makeUserItem.image = [NSImage imageNamed:NSImageNameUser];
    
    [subMenu addItem:makeCautionItem];
    [subMenu addItem:makeColorItem];
    [subMenu addItem:makeUserItem];
    
    menuItem.submenu = subMenu;
    [menu addItem:menuItem];
    
    return menu;
}

- (NSMenu *)directoryMenu
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:@"AnyShare" action:nil keyEquivalent:@""];
    menuItem.image = [NSImage imageNamed:@"Menu"];
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem * makeCautionItem = [[NSMenuItem alloc] initWithTitle:@"Make folder Caution" action:@selector(makeCaution:) keyEquivalent:@""];
    makeCautionItem.image = [NSImage imageNamed: NSImageNameCaution];
    NSMenuItem * makeColorItem = [[NSMenuItem alloc] initWithTitle:@"Make folder Corlor" action:@selector(makeColor:) keyEquivalent:@""];
    makeColorItem.image = [NSImage imageNamed:NSImageNameColorPanel];
    NSMenuItem * makeUserItem = [[NSMenuItem alloc] initWithTitle:@"Make folder User" action:@selector(makeUser:) keyEquivalent:@""];
    makeUserItem.image = [NSImage imageNamed:NSImageNameUser];
    
    [subMenu addItem:makeCautionItem];
    [subMenu addItem:makeColorItem];
    [subMenu addItem:makeUserItem];
    
    menuItem.submenu = subMenu;
    [menu addItem:menuItem];
    
    return menu;
}

#pragma validate menu
- (BOOL)validateToolbarMenu
{
    BOOL bResult = NO;
    NSUInteger itemCounts = [FIFinderSyncController defaultController].selectedItemURLs.count;
    bResult = itemCounts == 1 ? YES : NO;
    
    return bResult;
}
- (BOOL)validateFileMenu
{
    BOOL bResult = NO;
    NSUInteger itemCounts = [FIFinderSyncController defaultController].selectedItemURLs.count;
    bResult = itemCounts == 1 ? YES : NO;
    
    return bResult;
}
- (BOOL)validateDirectoryMenu
{
    return YES;
}

- (BOOL)toolBarMenuRequestFromMyFolder
{
    BOOL bResult = NO;
    NSURL * target = [FIFinderSyncController defaultController].targetedURL;
    bResult = [self path:target.path isSubPathOfPath:self.myFolderURL.path];
    
    return bResult;
}

#pragma mark path utils
- (BOOL)path:(NSString *)aPath isSubPathOfPath:(NSString *)anotherPath
{
    BOOL bResult = NO;
    
    bResult = [aPath hasPrefix:anotherPath];
    
    return bResult;
}

- (BOOL)fileUrlIsInvisible:(NSURL *)fileUrl
{
    BOOL bResult = NO;
    NSNumber * numIsHidden = nil;
    
    [fileUrl getResourceValue:&numIsHidden forKey:NSURLIsHiddenKey error:NULL];
    bResult = numIsHidden.boolValue;
    
    return bResult;
}

@end

