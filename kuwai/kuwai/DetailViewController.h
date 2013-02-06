//
//  DetailViewController.h
//  kuwai
//
//  Created by Naohiro OHTA on 2/7/13.
//  Copyright (c) 2013 amaoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
