# AutoLayoutAnimationDemo

AutoLayoutAnimationDemo is a small iOS app that shows how changing of auto-layout constraints can be animated using CoreAnimation. The app was developed to exercise myself.

## Multiple examples

In AppDelegate.m you can select between two demos:

    self.window.rootViewController = [[DemoViewController alloc] initWithNibName:nil bundle:nil];
    
or

    self.window.rootViewController = [[Demo2ViewController alloc] initWithNibName:nil bundle:nil];

The first demo (DemoViewController.m) shows how one view becomes visible or hidden by toggling a switch.

The second demo (Demo2ViewController.m) shows how more views are added dynamically with animation.