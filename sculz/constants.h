//
//  constants.h
//  sculz
//
//  Created by veddislabs on 19/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef sculz_constants_h
#define sculz_constants_h


UIUserInterfaceIdiom idiom = UI_USER_INTERFACE_IDIOM();
#define DEVICE_HEIGHT 0
if(idiom == UIUserInterfaceIdiomPhone){
    DEVICE_HEIGHT = ([[UIScreen mainScreen] bounds]).size.height;
}




#endif
