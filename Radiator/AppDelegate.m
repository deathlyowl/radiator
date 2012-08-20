//
//  AppDelegate.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import "AppDelegate.h"
#import "Favourites.h"

#import "ListViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    delegate = self;
    
    [self importStationsFromServer];
    
    stations = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stations" ofType:@"plist"]];
    
    NSLog(@"SC: %i", stations.count);
    
    [stations retain];
    
    [Favourites loadFavourites];
    
    currentStation = nil;

    _player = [[AVPlayer alloc] init];
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) remoteControlReceivedWithEvent:(UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (Player.isPlaying)   [Player pause];
                else                    [Player play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //[self previousTrack: nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //[self nextTrack: nil];
                break;
            default:
                break;
        }
    }
}

- (void) importStationsFromServer{
    NSLog(@"Import started");
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ksienie.com/radiator/stacje.csv"] encoding:NSUTF8StringEncoding error:nil];
    if (csvString) {
        NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
        NSMutableArray *stations = [[NSMutableArray alloc] init];
        NSMutableArray *database = [[NSMutableArray alloc] init];
        
        for (NSString *line in lines)
            if (![[line substringToIndex:1] isEqualToString:@"#"])
                [stations addObject:line];
        
        for (NSString *station in stations) {
            NSArray *componnents = [station componentsSeparatedByString:@";"];
            if (componnents.count == 5) {
                [database addObject:
                  [NSDictionary dictionaryWithObjectsAndKeys:
                    [componnents objectAtIndex:0], @"name",
                    [componnents objectAtIndex:1], @"URL",
                    [componnents objectAtIndex:2], @"description",
                    [componnents objectAtIndex:3], @"artworkName",
                    [componnents objectAtIndex:4], @"category", nil ]];
            }
        }
        if (database.count)
            [database writeToFile:[[NSBundle mainBundle] pathForResource:@"stations" ofType:@"plist"] atomically:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
