//
//  SecondViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/27.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "PersonDetailCell.h"
#import "EditPersonView.h"
#import "DBManager.h"
#import "Person.h"
#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height

static NSString *notifiationName = @"nt";

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,
    UITextFieldDelegate,DealPersonInfoDelegate>
{
    UITableView *tableView;
    NSMutableArray *myData;
    EditPersonView *editView;
    UITapGestureRecognizer *tap;
    Person *person;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    [self initData];
    [self initTableView];
    [self initEditView];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tap];
    tap.enabled = NO;
    //注册监听器,由DBManager的对象来监听person对象的消息--使用notification方式进行通行
    [[NSNotificationCenter defaultCenter] addObserver:[DBManager getSharedInstance] selector:@selector(savePersonInfo:) name:notifiationName object:person];
    //注册监听对象———使用KVO形式进行
//    [[DBManager getSharedInstance] addObserver:self forKeyPath:@"isSavedSucess" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)initEditView{
    editView = [[EditPersonView alloc] initWithFrame:CGRectMake(0, MainHeight - 200, MainWidth, 100) withDelegate:self];
    [self.view addSubview:editView];
}
- (void)initTableView{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - 200)];
    tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:tableView];
    tableView.delegate =  self;
    //data source方式示例
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)initData{
    myData = [[DBManager getSharedInstance] findAll];
    person = [[Person alloc]init];
}

- (void)addNavigationBar{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 20)];
    titleLabel.text = @"次页";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:26];
    self.navigationItem.titleView = titleLabel;
}

// 使用KVO方式必须实现该方法
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if([keyPath isEqualToString:@"isSavedSucess"]){
//        DBManager *db = object;
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAVE RESULT" message:[NSString stringWithFormat:@"Save person info is %@ !!",db.isSavedSucess ? @"succed" : @"failed" ] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        alertView.alertViewStyle = UIAlertViewStyleDefault;
//        alertView.frame = CGRectMake(MainWidth / 2, MainHeight /2, 200, 200);
//        [self.view addSubview:alertView];
//        [alertView show];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [alertView setHidden:YES];
//        });
//    }
//}

//点击空白处，收起键盘
- (void)viewTapped:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - dealPersonInfoDelegate methods
- (void)savePersonInfo:(NSArray *)arr{
//    [[DBManager getSharedInstance]saveData:arr[0] name:arr[1] department:arr[2] year:arr[3]];
    
    //使用notification方法来传递消息
    person.registerNumber = arr[0];
    person.name = arr[1];
    person.department = arr[2];
    person.year = arr[3];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifiationName object:person];
    [self initData];
    [tableView reloadData];
}
- (void)delPersonInfo:(NSArray *)arr{
    [[DBManager getSharedInstance]deleteInfo:arr];
    [self initData];
    [tableView reloadData];
}

#pragma mark - Table View Data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    PersonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[PersonDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    }
    NSArray *array;
    array= [myData objectAtIndex:indexPath.row];
    [cell setPersonDetailInfo:array[0] name:array[1] department:array[2] year:array[3]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myData ? [myData count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
  (NSInteger)section{
    NSString *headerTitle;
    if (section==0) {
        headerTitle = @"Section 1 Header";
    }
    else{
        headerTitle = @"Section 2 Header";

    }
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
  (NSInteger)section{
    NSString *footerTitle;
    if (section==0) {
        footerTitle = @"Section 1 Footer";
    }
    else{
        footerTitle = @"Section 2 Footer";
        
    }
    return footerTitle;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
 (NSIndexPath *)indexPath{
    NSArray *arr = myData[indexPath.row];
    [editView setPersonInfo:arr];
}

// pragma mark is used for easy access of code in Xcode
#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   NSLog(@"Text field did begin editing");
    //进入编辑状态的时候，手势开始生效，有可能导致手势冲突
    tap.enabled = YES;
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
   NSLog(@"Text field ended editing");
    tap.enabled = NO;
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//
//- (void)dealloc{
//    [[DBManager getSharedInstance] removeObserver:self forKeyPath:@"isSavedSucess"];
//}
@end
