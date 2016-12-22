//
//  CONST.h
//  BHGUIDemo
//
//  Created by wanghw on 12-3-21.
//  Copyright 2011 . All rights reserved.

#define SCHOOL_NAME @"驾校"
#define SCHOOL_ID @"1024"
#define CRM_CHANNEL_ID @"1024"

#define APPSTORE_ID @"1024"//AppStore ID

#define UMENG_KEY @"1024"

#define BAIDU_MAP_KEY @"1024"

#define kHttpRequestAppVersionNumberValue  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//驾校信息
#define SCHOOL_INFO_URL @"http://www.1024.com/mobileData/singleSchoolInfo"
//驾校设施
#define SCHOOL_FACILITY_URL @"http://www.1024.com/mobileData/querySchoolFacilityBySchoolId"
//驾校费用
#define SCHOOL_PRICE_URL @"http://www.1024.com/mobileData/getSchoolCourseListBySchoolId"
//驾校报名
#define SCHOOL_ORDER_URL @"http://www.1024.com/mobileData/saveMessage"
//驾校班车线路
#define SCHOOL_BUS_LINE_URL @"http://www.1024.com/mobileData/busLine"
//驾校图片
#define SCHOOL_PHOTOS_URL @"http://www.1024.com/mobileData/findSchoolPhotoList"
//意见反馈
#define ADVICE_URL @"http://www.1024.com/advice/save"
//应用推荐
#define APP_RECOMMENT_URL @"http://www.1024.com/apprecommend/list?type=1&appId=547156989"
//AppStore评价
#define APPSTORE_COMMENT_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"

#define APP_SHARE_CONTENT @"%@官方iPhone应用,实时价格,快速报名,班车路线信息随时查,为您解决所有疑问!下载地址 http://itunes.apple.com/cn/app/id%@?mt=8"
