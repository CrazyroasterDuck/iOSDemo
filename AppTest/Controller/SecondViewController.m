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


@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,
    UITextFieldDelegate,DealPersonInfoDelegate>
{
    UITableView *tableView;
    NSMutableArray *myData;
    EditPersonView *editView;
    UITapGestureRecognizer *tap;
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
    
}

- (void)initEditView{
    editView = [[EditPersonView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 100) withDelegate:self];
    [self.view addSubview:editView];
}
- (void)initTableView{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
    tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:tableView];
    tableView.delegate =  self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)initData{
//    NSArray *array1 = [[NSArray alloc] initWithObjects:@"0001",@"Jack",@"离岸",@"2019", nil];
//    NSArray *array2 = [[NSArray alloc] initWithObjects:@"0002",@"Rose",@"支付",@"2020", nil];
//    NSArray *array3 = [[NSArray alloc] initWithObjects:@"0003",@"Jack",@"离岸2",@"2021", nil];
//    NSArray *array4 = [[NSArray alloc] initWithObjects:@"0004",@"Rose",@"支付2",@"2022", nil];
//    NSArray *array5 = [[NSArray alloc] initWithObjects:@"0005",@"Jack",@"离岸3",@"2023", nil];
//    NSArray *array6 = [[NSArray alloc] initWithObjects:@"0006",@"Rose",@"支付3",@"2024", nil];
//    myData = [[NSMutableArray alloc] initWithObjects:array1,array2,array3,array4,array5,array6, nil];
//    for(NSArray *arr in myData){
//        BOOL isSuccess = [[DBManager getSharedInstance] saveData:arr[0] name:arr[1] department:arr[2] year:arr[3]];
//        NSLog(@"存储数据%@",isSuccess);
//    }
    myData = [[DBManager getSharedInstance] findAll];
}

- (void)addNavigationBar{
//    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(navButtonClicked)];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
//    [self.navigationItem setLeftBarButtonItem:navButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 20)];
    titleLabel.text = @"次页";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:26];
    self.navigationItem.titleView = titleLabel;
}

//点击空白处，收起键盘
- (void)viewTapped:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - dealPersonInfoDelegate methods
- (void)savePersonInfo:(NSArray *)arr{
    [[DBManager getSharedInstance]saveData:arr[0] name:arr[1] department:arr[2] year:arr[3]];
    [self initData];
    [tableView reloadData];
}
- (void)delPersonInfo:(NSArray *)arr{
    [[DBManager getSharedInstance]deleteInfo:arr];
    [self initData];
    [tableView reloadData];
}

//- (void)navButtonClicked{
//    SecondViewController *secondVC = [[SecondViewController alloc] init];
//    [self.navigationController pushViewController:secondVC animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PersonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[PersonDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    }
//    NSString *stringForCell;
//    if (indexPath.section == 0) {
//        stringForCell= [myData objectAtIndex:indexPath.row];
//
//    }else if (indexPath.section == 1){
//        stringForCell= [myData objectAtIndex:indexPath.row+ [myData count]/2];
//
//    }
//    [cell.textLabel setText:stringForCell];
    NSArray *array;
//    if (indexPath.section == 0) {
//        array= [myData objectAtIndex:indexPath.row];
//
//    }else if (indexPath.section == 1){
//        array= [myData objectAtIndex:indexPath.row + [myData count]/2];
//
//    }
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"Section:%ld Row:%ld selected and its data is %@",
//          (long)indexPath.section,(long)indexPath.row,cell.textLabel.text);
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

@end
