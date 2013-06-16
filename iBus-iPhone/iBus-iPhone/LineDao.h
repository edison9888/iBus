//
//  LineDao.h
//  iBus-iPhone
//
//  Created by yanghua on 5/26/13.
//  Copyright (c) 2013 yanghua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SELECT_LINEINFO_SQL \
@"SELECT * FROM lineInfo WHERE lineId = ? "

#define SELECT_ALL_LINEINFO_SQL \
@"SELECT * FROM lineInfo "

#define DELETE_LINEINFO_SQL \
@"DELETE FROM lineInfo WHERE lineId = ? "

#define DELETE_ALL_LINEINFO_SQL \
@"DELETE FROM lineInfo "

#define INSERT_LINEINFO_SQL \
@"INSERT INTO lineInfo(lineId,lineName,firstTime,lastTime,edgeStation_1,edgeStation_2,identifier,identifier_1_favorite,identifier_2_favorite) VALUES(:lineId,:lineName,:firstTime,:lastTime,:edgeStation_1,:edgeStation_2,:identifier,:identifier_1_favorite,:identifier_2_favorite)"

#define UPDATE_LINEINFO_SQL \
@"UPDATE lineInfo SET lineName = ? WHERE lineId = ?"

#define CHECK_EXISTS_LINEINFO_SQL \
@"SELECT COUNT(1) FROM lineInfo "

//favorite
#define UPDATE_LINE_FAVORITE_WITH_LINEID_IDENTIFIER_1 \
@"UPDATE lineInfo SET identifier_1_favorite = ? WHERE lineId = ?"

#define UPDATE_LINE_FAVORITE_WITH_LINEID_IDENTIFIER_2 \
@"UPDATE lineInfo SET identifier_2_favorite = ? WHERE lineId = ?"

#define CHECK_LINE_WITH_LINEID_ISFAVORITE_IDENTIFIER_1 \
@"SELECT identifier_1_favorite FROM lineInfo WHERE lineId = ? "

#define CHECK_LINE_WITH_LINEID_ISFAVORITE_IDENTIFIER_2 \
@"SELECT identifier_2_favorite FROM lineInfo WHERE lineId = ? "


@interface LineDao : NSObject

+ (BOOL)checkIsInited;

+ (void)add:(NSMutableArray*)lineArray;

+ (void)remove:(NSMutableArray*)lineIdArray;

+ (void)removeAll;

+ (NSDictionary*)getLineInfoWithId:(NSString*)lineId;

+ (NSMutableArray*)getLineList;

+ (void)favoriteWithLineId:(NSString*)lineId
             andIdentifier:(NSString*)identifier;

+ (void)unfavoriteWithLineId:(NSString*)lineId
               andIdentifier:(NSString*)identifier;

+ (BOOL)isFavoriteWithLineId:(NSString*)lineId
               andIdentifier:(NSString*)identifier;

@end
