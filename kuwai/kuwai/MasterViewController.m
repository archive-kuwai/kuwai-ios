//
//  MasterViewController.m
//  kuwai
//
//  Created by Naohiro OHTA on 2/7/13.
//  Copyright (c) 2013 amaoto. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@property(strong,nonatomic) NSMutableData* receivedOne;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self getData];
}

- (void)getData
{
    NSString* s = [@"http://kuwai.herokuapp.com/api/0/{\"method\":[\"list\",\"Good Company\",\"2013-01\"],\"who\":[\"test@t.com\",\"7b18ae007dab03abd77b397bf5058aa795a7352def052831629d2087c3bb8cba\",\"browser1\"]}" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:s];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:6000];
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPShouldHandleCookies:YES];
    
    NSURLConnection* cnct = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (cnct) {
        NSLog(@"Start loading");
        self.receivedOne = [NSMutableData data];
    }    
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
    NSString* s = @"yeah";
    s = [error description];
    NSLog(@"%@",s);
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"-didReceiveResponse");
    [self.receivedOne setLength:0];
    NSLog(@"%@",response.MIMEType);
    NSLog(@"%@",response.textEncodingName);
    NSLog(@"%@",response.URL.resourceSpecifier);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    NSLog(@"-didReceivedData");
    [self.receivedOne appendData:data];
    NSLog(@"receivedOne's length is %dbytes",[self.receivedOne length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"-connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedOne length]);
    int len = [self.receivedOne length];
    NSLog(@"length is, %d",len);
    unsigned char aBuffer[len];
    [self.receivedOne getBytes:aBuffer length:len];
    NSString* resultString = [[NSString alloc]initWithBytesNoCopy:aBuffer length:len encoding:NSUTF8StringEncoding freeWhenDone:NO];
    NSLog(@"-----------------------");
    NSLog(@"%@",resultString);
    NSLog(@"-----------------------");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
