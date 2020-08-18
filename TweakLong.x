#import "Masonry/Masonry/Masonry.h"

@interface BBPgcPhoneBangumiReviewDetailUserRate : NSObject
@property (nonatomic, assign, readwrite) float score; //max:10
@end

@interface BBPgcPhoneBangumiReviewDetailLongReviewItem : NSObject
@property (nonatomic, strong, readwrite) BBPgcPhoneBangumiReviewDetailUserRate *user_rating;
@end

@interface BBPgcPhoneBangumiLongReviewItemCell : UITableViewCell
@property (nonatomic, strong, readwrite) BBPgcPhoneBangumiReviewDetailLongReviewItem *model;
- (void)updateUIWithModel:(BBPgcPhoneBangumiReviewDetailLongReviewItem *)model;
@end

@interface BFCMultiThemePerModel : NSObject
@property (nonatomic, assign, readwrite) BOOL isLight;
@property (nonatomic, strong, readwrite) UIColor *themeColor;
@end

@interface BFCMultiTheme : NSObject
@property (nonatomic, strong, readwrite) BFCMultiThemePerModel *themeModel;
@property (nonatomic, assign, readwrite) NSInteger currentThemeId;
@property (nonatomic, assign, readonly) NSInteger lightThemeId;
+ (BFCMultiTheme *)sharedTheme;
@end

static BOOL isLightTheme(){
	BFCMultiTheme *sharedTheme=[%c(BFCMultiTheme) sharedTheme];
	if(sharedTheme.currentThemeId==sharedTheme.lightThemeId)return YES;
	return NO;
}

%hook BBPgcPhoneBangumiLongReviewItemCell

- (void)updateUIWithModel:(BBPgcPhoneBangumiReviewDetailLongReviewItem *)model {
	%orig;
	if(model&&model.user_rating.score<10){
		UIControl *coverView=[[UIControl alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
		coverView.backgroundColor=[UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1];
		UIFont *titleFont=[UIFont boldSystemFontOfSize:17];
		UILabel *warningTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,self.frame.size.width-20,titleFont.lineHeight)];
		warningTitleLabel.text=@"不良观看体验警告";
		warningTitleLabel.textAlignment=NSTextAlignmentCenter;
		warningTitleLabel.font=titleFont;
		[coverView addSubview:warningTitleLabel];
		UILabel *warningLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10+titleFont.lineHeight+5,self.frame.size.width-20,self.frame.size.height-(titleFont.lineHeight+20+20))];
		warningLabel.font=[UIFont systemFontOfSize:13];
		if(model.user_rating.score>=8){
			warningLabel.text=[NSString stringWithFormat:@"该评价的评分为 %f 星，对较差评价的阅览可能会影响您的观看体验，是否仍要阅读？",model.user_rating.score/2,nil];
		}else{
			warningLabel.text=@"该评价评分较低，对较差评价的阅览可能会影响您的观看体验，是否仍要阅读？";
		}
		warningLabel.numberOfLines=0;
		UIButton *continueReadingBtn=[UIButton buttonWithType:UIButtonTypeSystem];
		[continueReadingBtn setTitle:@"继续" forState:UIControlStateNormal];
		[continueReadingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[continueReadingBtn addTarget:coverView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
		[coverView addSubview:continueReadingBtn];
		[coverView addSubview:warningTitleLabel];
		[coverView addSubview:warningLabel];
		[warningTitleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
			maker.top.equalTo(coverView.mas_top).offset(10);
			maker.left.equalTo(coverView.mas_left).offset(10);
			maker.right.equalTo(coverView.mas_right).offset(-10);
		}];
		[warningLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
			maker.top.equalTo(warningTitleLabel.mas_bottom).offset(5);
			maker.left.equalTo(coverView.mas_left).offset(10);
			maker.right.equalTo(coverView.mas_right).offset(-10);
		}];
		[continueReadingBtn mas_makeConstraints:^(MASConstraintMaker *maker) {
			//maker.top.equalTo(warningTitleLabel.mas_bottom).offset(5);
			//maker.left.equalTo(coverView.mas_left).offset(10);
			//maker.right.equalTo(coverView.mas_right).offset(-10);
			maker.bottom.equalTo(coverView.mas_bottom).offset(-10);
			maker.centerX.equalTo(coverView);
		}];
		//UIButton *continueReadingBtn=[UIButton buttonWithType:UIButtonTypeSystem];
		//continueReadingBtn.frame=CGRectMake()
		[self addSubview:coverView];
		[coverView mas_makeConstraints:^(MASConstraintMaker *maker) {
			maker.edges.equalTo(self);
		}];
		if(!isLightTheme()){
			coverView.backgroundColor=[UIColor colorWithRed:0.173 green:0.173 blue:0.18 alpha:1];
			warningTitleLabel.textColor=warningLabel.textColor=[UIColor whiteColor];
		}
	}
}
%end


