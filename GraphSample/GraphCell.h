//
//  GraphCell.h
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphCell : UICollectionViewCell

- (void)setGraphCellType:(DateType)typeId colors:(NSArray *)colors heights:(NSArray *)heights;

- (void)setDictionary:(NSDictionary *)dic colors:(NSArray *)colors;

@end



@interface HeartCell : UICollectionViewCell

- (void)setHeartMinH:(CGFloat)minH maxH:(CGFloat)maxH;

@end
