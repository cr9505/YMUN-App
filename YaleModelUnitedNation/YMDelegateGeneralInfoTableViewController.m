//
//  YMDelegateGeneralInfoTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/8/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMDelegateGeneralInfoTableViewController.h"
#import "YMAPIInterfaceCenter.h"
#import "YMAnnotation.h"
#import "YMAppDelegate.h"
#import "YMForumTableViewController.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import <MapKit/MapKit.h>

@interface YMDelegateGeneralInfoTableViewController () <RNFrostedSidebarDelegate>

@end

@implementation YMDelegateGeneralInfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Information";
    self.sideBar = [(YMAppDelegate *)[UIApplication sharedApplication].delegate delegateSharedSideBar];
    self.sideBar.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // need to setup delegateSharedSideBar
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"delegateGeneralInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    cell.textLabel.textColor = [UIColor blackColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"School Name";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCHOOL_NAME];
            break;
        case 1:
        {
            UILabel *textLabel;
            UILabel *detailedTextLabel;
            MKMapView *mapView;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 3, 42, 15)];
                detailedTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, self.tableView.bounds.size.width - 15 - 15, 18)];
                mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 45, self.tableView.bounds.size.width - 15 - 15, 260 - 30 - 40 + 20)];
            } else {
                textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 42, 15)];
                detailedTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, self.tableView.bounds.size.width - 10 - 15, 18)];
                mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 45, self.tableView.bounds.size.width - 10 - 15, 260 - 30 - 40 + 20)];
            }
            
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
            textLabel.text = @"Hotel";
            detailedTextLabel.backgroundColor = [UIColor clearColor];
            detailedTextLabel.textColor = [UIColor grayColor];
            detailedTextLabel.font = [UIFont systemFontOfSize:14.0];
            detailedTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:HOTEL];
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:detailedTextLabel];
            // implement the geocoder
            NSString *address = [YMAPIInterfaceCenter addressForHotel:[[NSUserDefaults standardUserDefaults] objectForKey:HOTEL]];
            [cell addSubview:mapView];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:address
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             MKCoordinateRegion region;
                             MKCoordinateSpan span;
                             YMAnnotation *annotation;
                             span.longitudeDelta = 0.01;
                             span.latitudeDelta = 0.01;
                             region.span = span;
                             if ([placemarks count] > 0 && ![address isEqualToString:@"NA"]) {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 annotation = [[YMAnnotation alloc] initWithCoordinates:placemark.location.coordinate
                                                                                  title:[[NSUserDefaults standardUserDefaults] objectForKey:HOTEL]
                                                                               subtitle:address];
                                 region.center = placemark.location.coordinate;
                             } else {
                                 CLLocationCoordinate2D coord;
                                 coord.latitude = 41.3111;
                                 coord.longitude = -72.9267;
                                 annotation = [[YMAnnotation alloc] initWithCoordinates:coord
                                                                                  title:@"Yale University"
                                                                               subtitle:@"New Haven, CT"];
                                 region.center = coord;
                             }
                             [mapView addAnnotation:annotation];
                             [mapView setRegion:region animated:YES];
                             [mapView regionThatFits:region];

                         }];
            break;
        }
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    } else {
        return 268.0;
    }
}

- (void)dealloc
{
    self.sideBar.delegate = nil;
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        [self.sideBar dismiss];
    } else if (index == 1) {
        // write code to push forum pages
        YMForumTableViewController *forumVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forumVC"];
        [self.navigationController pushViewController:forumVC animated:YES];
        [self.sideBar dismiss];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
