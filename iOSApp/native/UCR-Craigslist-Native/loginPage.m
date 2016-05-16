//
//  loginPage.m
//  UCR-Craigslist-Native
//
//  Created by Michael Chen on 5/14/16.
//  Copyright © 2016 UCR. All rights reserved.
//

#import "AppDelegate.h"
#import "dbArrays.h"
#import "loginPage.h"
#import "users.h"
#import "posts.h"
#import "reviews.h"
#import "images.h"
#import "chat.h"

#define getUsersURL @"http://practicemakesperfect.co.nf/getUsers.php"
#define getPostsURL @"http://practicemakesperfect.co.nf/getPosts.php"
#define getReviewsURL @"http://practicemakesperfect.co.nf/getReviews.php"
#define getImagesURL @"http://practicemakesperfect.co.nf/getImagesURL.php"
#define getChatURL @"http://practicemakesperfect.co.nf/getChat.php"

@interface loginPage ()

@end

@implementation loginPage
@synthesize  titleLabel, loginUIButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self retrieveUsers];
    [self retrievePosts];
    [self retrieveReviews];
    [self retrieveImages];
    [self retrieveChat];
    
    NSLog(@"users: %@", [dbArrays sharedInstance].usersArray);
    NSLog(@"posts: %@", [dbArrays sharedInstance].postsArray);
    NSLog(@"reviews: %@", [dbArrays sharedInstance].reviewsArray);
    NSLog(@"images: %@", [dbArrays sharedInstance].imagesArray);
    NSLog(@"chat: %@", [dbArrays sharedInstance].chatArray);
    
    //keyboard dismiss: http://stackoverflow.com/a/5711504
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    userTF.delegate = self;
    passwdTF.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userTF) {
        [textField resignFirstResponder];
        [passwdTF becomeFirstResponder];
    } else if (textField == passwdTF) {
        [textField resignFirstResponder];
        [loginUIButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

-(void)dismissKeyboard { //http://stackoverflow.com/a/5711504
    [userTF resignFirstResponder];
    [passwdTF resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Class Methods
    
- (void)retrieveUsers { //referenced from: http://youtu.be/nqnohLXQRW4 . database linking
    NSURL * url = [NSURL URLWithString:getUsersURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [dbArrays sharedInstance].jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [dbArrays sharedInstance].usersArray = [[NSMutableArray alloc] init];
    
    NSLog(@"retrieveUsers jsonArray.count: %lu", (unsigned long)[dbArrays sharedInstance].jsonArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].jsonArray.count; i++){
        NSString * userID = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"userID"];
        NSString * email = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"email"];
        NSString * username = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"username"];
        NSString * password = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"password"];
        NSString * num_reviews = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"num_reviews"];
        NSString * total_rating = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"total_rating"];
        
        [[dbArrays sharedInstance].usersArray addObject:[[users alloc]initWithUsers:userID email:email username:username password:password num_reviews:num_reviews total_rating:total_rating]];
    }
}

- (void) retrievePosts
{
    NSURL * url = [NSURL URLWithString:getPostsURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [dbArrays sharedInstance].jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [dbArrays sharedInstance].postsArray = [[NSMutableArray alloc] init];
    
    NSLog(@"retrievePosts jsonArray.count: %lu", (unsigned long)[dbArrays sharedInstance].jsonArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].jsonArray.count; i++){
        NSString * post_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_id"];
        NSString * post_title = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_title"];
        NSString * post_username = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_username"];
        NSString * post_price = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_price"];
        NSString * post_category = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_category"];
        NSString * post_description = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_description"];
        NSString * post_date = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_date"];
        NSString * post_time = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_time"];
        NSString * post_photos = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_photos"];
        NSString * post_photo_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"post_photo_id"];
        
        [[dbArrays sharedInstance].postsArray addObject:[[posts alloc]initWithPosts:post_id post_title:post_title post_username:post_username post_price:post_price post_category:post_category post_description:post_description post_date:post_date post_time:post_time post_photos:post_photos post_photo_id:post_photo_id]];
    }
}
- (void) retrieveReviews {
    NSURL * url = [NSURL URLWithString:getReviewsURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [dbArrays sharedInstance].jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [dbArrays sharedInstance].reviewsArray = [[NSMutableArray alloc] init];
    NSLog(@"retrieveReviews jsonArray.count: %lu", (unsigned long)[dbArrays sharedInstance].jsonArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].jsonArray.count; i++){
        NSString * review_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"review_id"];
        NSString * user_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"user_id"];
        NSString * review = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"review"];
        NSString * reviewer = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"reviewer"];
        NSString * rating = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"rating"];

        [[dbArrays sharedInstance].reviewsArray addObject:[[reviews alloc]initWithReviews:review_id user_id:user_id review:review reviewer:reviewer rating:rating]];
    }
}

- (void) retrieveImages // image_id, image_post_id, image_name, image_pic;
{
    NSURL * url = [NSURL URLWithString:getImagesURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [dbArrays sharedInstance].jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [dbArrays sharedInstance].imagesArray = [[NSMutableArray alloc] init];
    NSLog(@"retrieveImages jsonArray.count: %lu", (unsigned long)[dbArrays sharedInstance].jsonArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].jsonArray.count; i++){
        NSString * image_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"image_id"];
        NSString * image_post_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"image_post_id"];
        NSString * image_name = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"image_name"];
        NSString * image_pic = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"image_pic"];

        [[dbArrays sharedInstance].imagesArray addObject:[[images alloc]initWithImages:image_id image_post_id:image_post_id image_name:image_name image_pic:image_pic ]];
    }
}
- (void) retrieveChat // chat_id, user_id, message, sent_on
{
    NSURL * url = [NSURL URLWithString:getChatURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    [dbArrays sharedInstance].jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [dbArrays sharedInstance].chatArray = [[NSMutableArray alloc] init];
    NSLog(@"retrieveChat jsonArray.count: %lu", (unsigned long)[dbArrays sharedInstance].jsonArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].jsonArray.count; i++) {
        NSString * chat_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"chat_id"];
        NSString * user_id = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"user_id"];
        NSString * message = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"message"];
        NSString * sent_on = [[[dbArrays sharedInstance].jsonArray objectAtIndex:i] objectForKey:@"sent_on"];

        [[dbArrays sharedInstance].chatArray addObject:[[chat alloc]initWithChat:chat_id user_id:user_id message:message sent_on:sent_on ]];
    }
}

- (IBAction)loginButton:(id)sender {
    [[self view] endEditing:YES]; 
    //trying to match inputted text with database
    BOOL matched = 0;
    NSLog(@"usersArray.count: %lu", (unsigned long)[dbArrays sharedInstance].usersArray.count);
    for(int i = 0; i < [dbArrays sharedInstance].usersArray.count && !matched; i++){
        
        if([userTF.text isEqualToString:[[[dbArrays sharedInstance].usersArray objectAtIndex:i] username]] && [passwdTF.text isEqualToString:[[[dbArrays sharedInstance].usersArray objectAtIndex:i] password]]){
           
             UIAlertController *alert = [UIAlertController
                                              alertControllerWithTitle:@"Valid login!"
                                              message:@"Proceed to tab view."
                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            //button creation and function (handler)
            UIAlertAction* actionOk = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
            
            [alert addAction:actionOk];
            
            matched = 1;
        }
    }
    
    if(!matched){
        UIAlertController *alert = [UIAlertController
                                          alertControllerWithTitle:@"Invalid login!"
                                          message:@"Please enter a correct username/password combination."
                                          preferredStyle:UIAlertControllerStyleAlert];
        //button creation and function (handler)
        UIAlertAction* actionOk = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
        
        [alert addAction:actionOk];

        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(matched){
        //source code: http://stackoverflow.com/a/21877460
        AppDelegate *appDelg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelg.validLogin = 1;
        [self dismissLoginAndShowProfile];
        //end source code
    }
    
}

//source code: http://stackoverflow.com/a/21877460
#pragma mark - Dismissing Delegate Methods

-(void) loginActionFinished:(NSNotification*)notification {
    
    AppDelegate *appDelg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelg.validLogin = 1;
    
    [self dismissLoginAndShowProfile];
}

- (void)dismissLoginAndShowProfile {
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"tabView"];
        [self presentViewController:tabView animated:YES completion:nil];
    }];
}
//end source code
@end
