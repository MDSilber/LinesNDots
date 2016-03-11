//
//  AppDelegate.m
//  LinesNDots
//
//  Created by Max Segan on 3/7/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PlayerRoster.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self _hydratePlayerRoster];

  ViewController *vc = [ViewController new];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = vc;

  [self.window makeKeyAndVisible];

  return YES;
}

- (void)_hydratePlayerRoster
{
  NSString *team0PlayersPath = [[NSBundle mainBundle] pathForResource:@"team0" ofType:@"json"];
  NSString *team1PlayersPath = [[NSBundle mainBundle] pathForResource:@"team1" ofType:@"json"];
  if (team0PlayersPath && team1PlayersPath) {
    NSError *team0Error = nil;
    NSError *team1Error = nil;

    NSData *team0PlayersData = [[NSData alloc] initWithContentsOfFile:team0PlayersPath];
    NSDictionary *team0PlayersArray = [NSJSONSerialization JSONObjectWithData:team0PlayersData options:0 error:&team0Error];

    NSData *team1PlayersData = [[NSData alloc] initWithContentsOfFile:team1PlayersPath];
    NSDictionary *team1PlayersArray = [NSJSONSerialization JSONObjectWithData:team1PlayersData options:0 error:&team1Error];

    if (!team0Error && !team1Error) {
      [[PlayerRoster sharedRoster] hydrateWithTeam0JSON:team0PlayersArray team1JSON:team1PlayersArray];
    }
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
