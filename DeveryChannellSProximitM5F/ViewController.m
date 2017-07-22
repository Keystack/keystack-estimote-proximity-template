//
// Please report any problems with this app template to contact@estimote.com
//

#import "ViewController.h"

#import "BeaconDetails.h"
#import "BeaconDetailsCloudFactory.h"
#import "CachingContentFactory.h"
#import "ProximityContentManager.h"

@interface ViewController () <ProximityContentManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) ProximityContentManager *proximityContentManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.activityIndicator startAnimating];

    self.proximityContentManager = [[ProximityContentManager alloc]
        initWithBeaconIDs:@[
            [[BeaconID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:18102 minor:58463],
            [[BeaconID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:826 minor:57444],
            [[BeaconID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:51829 minor:30016]
        ]
        beaconContentFactory:[[CachingContentFactory alloc] initWithBeaconContentFactory:[BeaconDetailsCloudFactory new]]];
    self.proximityContentManager.delegate = self;

    [self.proximityContentManager startContentUpdates];
}

- (void)proximityContentManager:(ProximityContentManager *)proximityContentManager didUpdateContent:(id)content {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];

    BeaconDetails *beaconDetails = content;
    if (beaconDetails) {
        self.view.backgroundColor = beaconDetails.backgroundColor;
        self.label.text = [NSString stringWithFormat:@"You're in %@'s range!", beaconDetails.beaconName];
        self.image.hidden = NO;
    } else {
        self.view.backgroundColor = BeaconDetails.neutralColor;
        self.label.text = @"No beacons in range.";
        self.image.hidden = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
