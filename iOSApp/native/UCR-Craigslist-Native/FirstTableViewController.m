//
//  FirstTableViewController.m
//  UCR-Craigslist-Native
//
//  Created by Michael Chen on 5/26/16.
//  Copyright © 2016 UCR. All rights reserved.
//

#import "FirstTableViewController.h"
#import "dbArrays.h"
#import "posts.h"
#import "loginPage.h"
#import "PostsTableViewController.h"

@interface FirstTableViewController ()

@end

@implementation FirstTableViewController
@synthesize categories, num_categories_label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginPage * loginPageObj = [[loginPage alloc] init];
    [loginPageObj retrievePosts];
    
    [self setupData];
    [self setupUI];
   
}

- (void)refreshAll{
    loginPage * loginPageObj = [[loginPage alloc] init];
    [loginPageObj retrievePosts];
    [loginPageObj retrieveImages];
    [self setupData];
    [self setupUI];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData{
    NSLog(@"SETTING UP DATA!!!!!!!!!!!!!!!");
    [self getUserInfo];
    categories = @[@"All", @"Books", @"Clothing", @"Electronics", @"Furniture", @"Household", @"Leases", @"Music", @"Pets", @"Services", @"Tickets", @"Vehicles", @"Other"];
    
    for(int i = 0; i < categories.count; i++){ //find all relevant posts for each category
        [self getRelevantPosts:[categories objectAtIndex:i]];
    }
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
    num_categories_label.userInteractionEnabled = false;
    num_categories_label.textColor = [UIColor whiteColor];
    num_categories_label.backgroundColor = [UIColor blackColor];
    num_categories_label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    num_categories_label.textAlignment = NSTextAlignmentCenter;
    num_categories_label.text = [NSString stringWithFormat:@"       %lu categories", categories.count];
    
    //remove tab bar text and adjust images down http://stackoverflow.com/a/30771197
    for(UITabBarItem * tabBarItem in self.tabBarController.tabBar.items){
        NSLog(@"tabBarItem.title: %@", tabBarItem.title);
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (void)getUserInfo{
    users * userObj;
    for(int i  = 0; i < [dbArrays sharedInstance].usersArray.count; i++){
        userObj = [[dbArrays sharedInstance].usersArray objectAtIndex:i];
        //NSLog(@"userObj.loggedIn: %@", userObj.loggedIn);
        if(userObj.loggedIn){
            [dbArrays sharedInstance].user.username = userObj.username;
        }
    }
    
    for(int i  = 0; i < [dbArrays sharedInstance].usersArray.count; i++){
        userObj = [[dbArrays sharedInstance].usersArray objectAtIndex:i];
        //NSLog(@"userObj.loggedIn: %@", userObj.loggedIn);
        if(userObj.loggedIn){
            //[dbArrays sharedInstance].user = userObj;
            [dbArrays sharedInstance].user = [[users alloc] init];
            [dbArrays sharedInstance].user.username = userObj.username;
            [dbArrays sharedInstance].user.userID = userObj.userID;
            [dbArrays sharedInstance].user.email = userObj.email;
            [dbArrays sharedInstance].user.password = userObj.password;
            [dbArrays sharedInstance].user.num_reviews = userObj.num_reviews;
            [dbArrays sharedInstance].user.total_rating = userObj.total_rating;
            
            NSLog(@"userObj.num_reviews: %@", userObj.num_reviews);
            //currentLoggedInUserRatingFloat = [userObj.total_rating floatValue] / [userObj.num_reviews floatValue];
            //currentLoggedInUserRating = [NSString stringWithFormat:@"%.1f", currentLoggedInUserRatingFloat];
            //currentLoggedInUserNumOfRatings = userObj.num_reviews;
        }
    }
}

//retrieve relevant posts for each respective category
- (void)getRelevantPosts: (NSString *)_category{
    //NSLog(@"postsArray.count: %lu", [dbArrays sharedInstance].postsArray.count);
    //NSLog(@"Category being allocated: %@", _category);
    NSMutableArray * relevantPostsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [dbArrays sharedInstance].postsArray.count; i++){
        posts * post = [[dbArrays sharedInstance].postsArray objectAtIndex:i];
        if([post.post_category isEqualToString:_category]){
            [relevantPostsArray addObject:post];
            //NSLog(@"post.post_title: %@", post.post_title);
        }
    }
    
    if([_category isEqualToString:@"Books"]){
        [dbArrays sharedInstance].relevantBooksArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Clothing"]){
       [dbArrays sharedInstance].relevantClothingArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Electronics"]){
       [dbArrays sharedInstance].relevantElectronicsArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Furniture"]){
        [dbArrays sharedInstance].relevantFurnitureArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Household"]){
       [dbArrays sharedInstance].relevantHouseholdArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Leases"]){
       [dbArrays sharedInstance].relevantLeasesArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Music"]){
        [dbArrays sharedInstance].relevantMusicArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Pets"]){
       [dbArrays sharedInstance].relevantPetsArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Services"]){
       [dbArrays sharedInstance].relevantServicesArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Tickets"]){
       [dbArrays sharedInstance].relevantTicketsArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Vehicles"]){
        [dbArrays sharedInstance].relevantVehiclesArray = relevantPostsArray;
    }
    else if([_category isEqualToString:@"Other"]){
       [dbArrays sharedInstance].relevantOtherArray = relevantPostsArray;
    }
    NSLog(@"relevant%@Array.count: %lu", _category, relevantPostsArray.count);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
   
    cell.textLabel.text = categories[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"postCellSegue"]){
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        //NSLog(@"category: %@", categories[indexPath.row]);
        [[segue destinationViewController] getCategory:categories[indexPath.row]];
    }
}

- (void)presentPopup:(NSString *)titleText message: (NSString *)message{ //courtesy popup
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:titleText
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //button creation and function (handler)
    UIAlertAction * cancel = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction *action) {}];
    
    UIAlertAction* actionOk = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self refreshAll];
                               }];
    
    [alert addAction:cancel];
    [alert addAction:actionOk];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dismissPostsAndShowComposer{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * CreatePostViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreatePostViewController"];
    [self presentViewController:CreatePostViewController animated:YES completion:nil];
}

- (IBAction)newButton:(id)sender {
    [self dismissPostsAndShowComposer];
}

- (IBAction)refreshButton:(id)sender {
    [self presentPopup:@"Press Ok to load images!" message:@"This may take a while..."];
}

@end
