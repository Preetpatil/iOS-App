//
//  LUDrawingViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUDrawingViewController.h"
#import "LUNotesDrawingView.h"
#import "DrawingDataManager.h"
#import "LUStudentAppDelegate.h"
#import "LUStudentProfileViewController.h"
@interface LUDrawingViewController ()

@property (weak) IBOutlet UIView *colorPreviewView;
@end

@implementation LUDrawingViewController
{
    UIButton *colorBtn;
    UIToolbar *toolbar;
    CGStretchView *stretchImageView;
    LURulerView *rulerImageView;
    NSArray *pickerArray;
    NSTimer *timer;
    UIImage *stampImage;
    CGFloat RED,GREEN,BLUE,CPAlpha;
    NSInteger openViewTag;
    UIImage *cropperCache;
    UIViewAnimationOptions animation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self createColorButton];
    [self createToolBar];
    [self fontSetting];
    
    openViewTag = -1;    /// default value for view animation
    _colorPreviewView.backgroundColor = self.DrawingView.lineColor;
    _StdColorPickerView.backgroundColor = self.DrawingView.lineColor;
    
    //    timer = [NSTimer scheduledTimerWithTimeInterval:10.0             //autosave timer
    //                                             target:self
    //                                           selector:@selector(autoSave)
    //                                           userInfo:nil
    //                                            repeats:YES];
    [self initialDrawingExistance];
    stretchImageView.isFillActive=YES;
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timelbl.text=dateString;
    
    NSDate *dateFromString = [[NSDate alloc] init];
    //    dateFromString = [dateFormatter dateFromString:curDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM yyyy"];
    NSString *theDate = [dateFormat stringFromDate:dateFromString];
    _datelbl.text = theDate;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    _profiledata= [[NSMutableDictionary alloc] init];
    _profiledata=[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    
    _stdntID=[_profiledata objectForKey:@"StudentId"];
    _ClassID =[_profiledata objectForKey:@"ClassId"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self autoSave];
    if (!_isAssignment)
    {
        
        
        NSArray *drawings = [[DrawingDataManager getSharedInstance]viewAllArt:_DBName];
        NSArray *artnameArr = [drawings objectAtIndex:0];
        NSArray *artimageArr = [drawings objectAtIndex:1];
        NSString *imageString;
        if ([artnameArr containsObject:_artName]) {
            [artnameArr indexOfObject:_artName];
            imageString = [[artimageArr objectAtIndex: [artnameArr indexOfObject:_artName]] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSLog(@"%@",imageString);
            
            NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
            [body setObject:_stdntID forKey:@"StudentId"];
            
            [body setObject:_ClassID forKey:@"ClassId"];
            
            [body setObject:_artCatagory forKey:@"DrawingCategoryName"];
            [body setObject:_artName forKey:@"DrawingName"];
            [body setObject:imageString forKey:@"ImageUrl"];
            
            
            
            LUOperation *sharedSingleton = [LUOperation getSharedInstance];
            sharedSingleton.LUDelegateCall=self;
            [sharedSingleton drawingSubmit: body];
        }
    }
}
#pragma mark - remove select
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)removeSelect:(id)sender
{
    [_imageCropper setCropRegionRect:CGRectZero];
}

#pragma mark - crop image
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)cropImage:(id)sender
{
    
    _lpRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.view addGestureRecognizer:_lpRecognizer];
    
    stretchImageView.isFillActive=nil;
    
    
    UIImage *image = [self captureView:_DrawingView.bounds];
    cropperCache=image;
    _imageCropper = [[NLImageCropperView alloc] initWithFrame:CGRectMake(0, 0, _DrawingView.layer.frame.size.width , _DrawingView.layer.frame.size.height)];
    [_imageCropper setImage:image];
    [_imageCropper setCropRegionRect:CGRectMake(50, 50, 100, 100)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_DrawingView addSubview:_imageCropper];
    });
}

#pragma Cut Copy Paste
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)cut:(id)sender
{
    CGRect imageRect = [_imageCropper getSelectedImageRect];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height)];
    imageView1.image = [UIImage imageNamed:@"gray.png"];
    [_DrawingView addSubview:imageView1];
    [self copy:sender];
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)copy:(id)sender
{
    UIImage *croppedImg = [_imageCropper getCroppedImage];
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteboardIdentifier create:NO];
    [pasteboard setImage:croppedImg];
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)paste:(id)sender
{
    //UIImage *image = cropperCache;
    //UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image];
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteboardIdentifier create:NO];
    stretchImageView = [[CGStretchView alloc] initWithFrame: [_imageCropper getSelectedImageRect]];
    stretchImageView.isFillActive=nil;
    if (pasteboard.image) stretchImageView.image = pasteboard.image;
    [_imageCropper removeFromSuperview];
    [_DrawingView loadImage:cropperCache];
    //[_DrawingView insertSubview:imageView1 atIndex:[[self.view subviews] count]];
    [_DrawingView insertSubview:stretchImageView atIndex:[[self.view subviews] count]];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"long press");
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (![menu isMenuVisible])
    {
        [self becomeFirstResponder];
        [menu setTargetRect:self.view.frame inView:self.view.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}
//#########

#pragma Font Setting

/**
 <#Description#>
 */
-(void)fontSetting
{
    pickerArray =  @[ @[@"AmericanTypewrite", @"Arial", @"Cochin", @"Courier", @"EuphemiaUCAS", @"HelveticaNeue", @"Noteworthy",@"Times New Roman",@"Verdana",@"Noteworthy"],
                      @[@"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"]];
    self.fontStyle.delegate = self;
    self.fontStyle.dataSource = self;
}


#pragma Create button

/**
 <#Description#>
 */
-(void)createColorButton
{
    colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 32, 32)];
    [colorBtn.layer setCornerRadius:16];
    [colorBtn addTarget:self action:@selector(colorbtn:) forControlEvents:UIControlEventTouchUpInside];
    colorBtn.tag  =  3;
    colorBtn.backgroundColor = _DrawingView.lineColor;
}

#pragma Check for Drawing existance
/**
 <#Description#>
 */
-(void)initialDrawingExistance
{
    CGRect drawView  =  [_DrawingView.layer bounds];
    UIGraphicsBeginImageContextWithOptions(drawView.size,YES,0.0f);
    BOOL status = [UIImage imageWithData:_artImage]!= nil;
    if (status == YES)
    {
        NSMutableString *DBName  = [[_DBName stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
        // [[DrawingDataManager getSharedInstance]createDrawingDB:DBName];
        
        [[UIImage imageWithData:_artImage] drawInRect:_DrawingView.bounds];
        UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_DrawingView loadImage:image];
        
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(1326,860));
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        UIView *base = [[UIView alloc]initWithFrame:CGRectMake(0,0,1326, 860)];
        base.backgroundColor = [UIColor whiteColor];
        [base.layer renderInContext:context];
        
        UIImage *img =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        BOOL success  =  NO;
        NSMutableString *DBName  = [[_DBName stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
        // [[DrawingDataManager getSharedInstance]createDrawingDB:DBName];
        success = [[DrawingDataManager getSharedInstance]saveDrawing:_artName page:[NSData dataWithData:UIImagePNGRepresentation(img)] catagory:_artCatagory DB:DBName ];
        
    }
}

#pragma Invalidating the Auto save
-(void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
}

#pragma mark - Create Toolbar
/**
 <#Description#>
 */
- (void) createToolBar
{
    toolbar  =  [UIToolbar new];
    toolbar.barStyle  =  UIBarStyleDefault;
    [toolbar setTranslucent:NO];
    [toolbar sizeToFit];
    toolbar.frame  =  CGRectMake(0,65, self.view.bounds.size.width, 70);
    
    //Add tool bar buttons
    // Drawing tool bar items are added to the toolbar
    
    UIBarButtonItem *textToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Text"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(TextTool:)];
    [textToolBarItem setTag:1];
    
    UIBarButtonItem *shapesToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Shapes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shapebtn:)];
    [shapesToolBarItem setTag:2];
    
    UIBarButtonItem *fillToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"paint"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(panitbtn:)];
    [fillToolBarItem setTag:3];
    colorBtn.backgroundColor = _DrawingView.lineColor;
    UIBarButtonItem *colorToolBarItem  =  [[UIBarButtonItem alloc] initWithCustomView:colorBtn];
    
    //initWithImage:[[UIImage imageNamed:@"Color.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(colorbtn:)];
    // [colorToolBarItem setTarget:self];
    // [colorToolBarItem setAction:@selector(colorbtn)];
    // [colorToolBarItem.target performSelector:@selector(colorbtn)];
    
    [colorToolBarItem setTag:3];
    
    UIBarButtonItem *rulerToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Scale"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rulerbtn:)];
    
    UIBarButtonItem *pencilAndBrushToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"brush"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(DRWWriteTool:)];
    [pencilAndBrushToolBarItem setTag:4];
    
    UIBarButtonItem *eraserToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"eraser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(Eraser:)];
    [eraserToolBarItem setTag:5];
    
    UIBarButtonItem *undoToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"undo-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(undoDraw:)];
    
    UIBarButtonItem *redoToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"redo-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(redoDraw:)];
    
    
    UIBarButtonItem *otherItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(More:)];
    [otherItem setTag:6];
    
    
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    UIBarButtonItem *fixedSpaceItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
    
    fixedSpaceItem.width  =  20; //Add spacing between UIToolbar
    
    //Add buttons to the array
    NSArray *items  =  [NSArray arrayWithObjects: undoToolBarItem, fixedSpaceItem, redoToolBarItem, fixedSpaceItem, flexItem, textToolBarItem, fixedSpaceItem, shapesToolBarItem, fixedSpaceItem,
                        fillToolBarItem, fixedSpaceItem, colorToolBarItem, fixedSpaceItem, rulerToolBarItem, fixedSpaceItem, pencilAndBrushToolBarItem, fixedSpaceItem, eraserToolBarItem, fixedSpaceItem, otherItem, fixedSpaceItem, nil];
    
    //add array of buttons to toolbar
    [toolbar setItems:items animated:NO];
    
    CALayer *bottomBorder  =  [CALayer layer];
    
    bottomBorder.frame  =  CGRectMake(0.0f, toolbar.frame.size.height - 1.0f, toolbar.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor  =  [[UIColor blackColor] CGColor];//[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [toolbar.layer addSublayer:bottomBorder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:toolbar];
    });
}

#pragma ClipArt selection
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
-(IBAction)clipArtSelector:(id)sender
{
    // stampImage = [UIImage imageNamed:@"star1.png"];
    NSArray *clipArtImage = @[@"Vector1.png",@"Vector2.png",@"Vector3.png",@"Vector4.png",@"Vector5.png"];
    switch ([sender tag])
    {
        case 1:
            stampImage = [UIImage imageNamed:[clipArtImage objectAtIndex:[sender tag]-1]];
            
            break;
        case 2:
            stampImage = [UIImage imageNamed:[clipArtImage objectAtIndex:[sender tag]-1]];
            break;
        case 3:
            stampImage = [UIImage imageNamed:[clipArtImage objectAtIndex:[sender tag]-1]];
            break;
        case 4:
            stampImage = [UIImage imageNamed:[clipArtImage objectAtIndex:[sender tag]-1]];
            break;
        case 5:
            stampImage = [UIImage imageNamed:[clipArtImage objectAtIndex:[sender tag]-1]];
            break;
            
    }
    stretchImageView  =  [[CGStretchView alloc] initWithFrame:CGRectMake(100, 100,1021/2,808/2)];
    stretchImageView.image  =  stampImage;
    stretchImageView.isFillActive = YES;
    stretchImageView.delegate  =  self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_DrawingView addSubview:stretchImageView];
    });
}
#pragma Autosave

/**
 <#Description#>
 */
-(void)autoSave
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    __block  BOOL success  =  NO;
    // dispatch_async(dispatch_get_main_queue(), ^{
    UIImage* img  =  [self captureView:_DrawingView.bounds];
    success  =  [[DrawingDataManager getSharedInstance] updateDrawing:_artName page:[NSData dataWithData: UIImagePNGRepresentation(img)] catagory:_artCatagory DB:_DBName ];
    //});
    //});
}

#pragma Captures the Draw view
/**
 <#Description#>
 
 @param frame <#frame description#>
 @return <#return value description#>
 */
- (UIImage *)captureView:(CGRect)frame
{
    CGRect drawView  =  [_DrawingViewBase.layer bounds];
    UIGraphicsBeginImageContext(drawView.size);
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    [_DrawingViewBase.layer renderInContext:context];
    UIImage *img  = nil;
    img  =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

///Text Method
int textTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
-(void)TextTool:(id)sender
{
    textTap++;
    if (textTap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if (textTap == 2)
    {
        textTap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
}

//shapes Method
int shapeTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)shapebtn:(id)sender
{
    shapeTap++;
    if(shapeTap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if(shapeTap == 2)
    {
        shapeTap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
    
    //    UIImage *insert = [UIImage imageNamed:@"arrow.jpg"];
    //    stretchImageView  =  [[CGStretchView alloc] initWithFrame:CGRectMake(100, 100, insert.size.width,insert.size.height)];
    //    stretchImageView.image  =  insert;
    //    stretchImageView.delegate  =  self;
    //    [_DrawingView addSubview:stretchImageView];
}

//color picker
int Drawingcolortap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)colorbtn:(id)sender
{
    Drawingcolortap++;
    if (Drawingcolortap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if(Drawingcolortap == 2)
    {
        Drawingcolortap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
}

//color picker fill
int paintTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)panitbtn:(id)sender
{
    [self closeToolViewDisplayed];
    openViewTag=-1;
    stretchImageView.isFillActive=YES;
    stretchImageView.fillColor = self.DrawingView.lineColor;
    [self.view removeGestureRecognizer:_lpRecognizer];
    //    stretchImageView.image = stampImage;
}

- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color
{
    [self.colorPreviewView setBackgroundColor:color];
    self.DrawingView.lineColor = color;//[UIColor colorWithRed:RED/255.0 green:BLUE/255.0 blue:GREEN/255.0 alpha:1.0];
    colorBtn.backgroundColor = self.DrawingView.lineColor;
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)colorSelection:(id)sender
{
    UIButton *toolselected  =  (UIButton*)sender;
    switch(toolselected.tag)
    {
        case 100:
            
            RED = 253.0;
            GREEN = 83.0;
            BLUE = 8.0;
            break;
            
        case 101:
            
            RED = 251.0;
            GREEN = 153.0;
            BLUE = 2.0;
            
            break;
            
        case 102:
            RED = 250.0;
            GREEN = 188.0;
            BLUE = 2.0;
            break;
            
        case 103:
            RED = 255.0;
            GREEN = 255.0;
            BLUE = 0.0;
            
            break;
        case 104:
            
            RED = 208.0;
            GREEN = 234.0;
            BLUE = 43.0;
            
            break;
        case 105:
            
            RED = 102.0;
            GREEN = 176.0;
            BLUE = 50.0;
            
            break;
        case 106:
            RED = 3.0;
            GREEN = 145.0;
            BLUE = 206.0;
            
            break;
        case 107:
            
            RED = 2.0;
            GREEN = 71.0;
            BLUE = 254.0;
            
            break;
        case 108:
            
            RED = 61.0;
            GREEN = 1.0;
            BLUE = 164.0;
            
            break;
        case 109:
            
            RED = 134.0;
            GREEN = 1.0;
            BLUE = 175.0;
            
            break;
            
    }
    self.DrawingView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1];
    _StdColorPickerView.backgroundColor = self.DrawingView.lineColor;
    colorBtn.backgroundColor = self.DrawingView.lineColor;
    stretchImageView.fillColor = self.DrawingView.lineColor;
}

// Ruler method
int drawRulerTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)rulerbtn:(id)sender
{
    [self closeToolViewDisplayed];
    openViewTag=-1;
    drawRulerTap++;
    if (drawRulerTap == 1)
    {
        rulerImageView  =  [[LURulerView alloc] initWithFrame:CGRectMake(50, 400, 1300, 130)];
        //rulerImageView  =  [[LURulerView alloc] initWithFrame:CGRectMake(0, 0, 1300, 130)];
        rulerImageView.backgroundColor = [UIColor clearColor];
        rulerImageView.image  =  [UIImage imageNamed:@"ruler.png"];
        self.DrawingView.drawTool = NOTESDrawingToolTypeLine;
        self.DrawingView.lineWidth = 6.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:rulerImageView];
        });
    }
    else if(drawRulerTap == 2)
    {
        drawRulerTap = 0;
        [rulerImageView removeFromSuperview];
        self.DrawingView.drawTool = NOTESDrawingToolTypePen;
    }
}

////write tool method
int writeTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)DRWWriteTool:(id)sender
{
    self.DrawingView.drawTool = NOTESDrawingToolTypePen;
    writeTap++;
    if (writeTap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if (writeTap == 2)
    {
        writeTap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)writeSizeSelector:(id)sender
{
    self.DrawingView.lineWidth = self.writeSizeSlider.value;
}

///eraser method
int eraserTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)Eraser:(id)sender
{
    self.DrawingView.drawTool = NOTESDrawingToolTypeEraser;
    eraserTap++;
    if (eraserTap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if (eraserTap == 2)
    {
        eraserTap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
}

- (IBAction)eraserSizeSelector:(id)sender
{
    self.DrawingView.lineWidth = self.eraserSizeSlider.value;
}

#pragma UndoRedo Method
/**
 <#Description#>
 */
-(void)updateButtonStatus
{
    self.undo.enabled = [self.DrawingView canUndo];
    self.redo.enabled = [self.DrawingView canRedo];
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)undoDraw:(id)sender
{
    [self.DrawingView undoLatestStep];
    [self updateButtonStatus];
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)redoDraw:(id)sender
{
    [self.DrawingView redoLatestStep];
    [self updateButtonStatus];
}

///More tools Method
int moreTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (void)More:(id)sender
{
    moreTap++;
    if (moreTap == 1)
    {
        [self openToolViewDisplay:sender];
    }
    else if (moreTap == 2)
    {
        moreTap = 0;
        [self closeToolViewDisplayed];
        openViewTag = -1;
    }
}


/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)Transform:(id)sender
{
    
}

int StampTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)Stamp:(id)sender
{
    //stampImage = [UIImage imageNamed:@"Add.png"];
    StampTap++;
    if (StampTap == 1)
    {
        _DrawingView.lineColor = [UIColor clearColor];
        _DrawingView.imageToStamp  =  stampImage;
        stretchImageView  =  [[CGStretchView alloc] initWithFrame:CGRectMake(10, 10, 32,32)];
        stretchImageView.image  =  stampImage;
        stretchImageView.image =stampImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_DrawingView addSubview:stretchImageView];
        });
    }
    else if(StampTap == 2)
    {
        StampTap = 0;
        stampImage  =  nil;
        _DrawingView.imageToStamp  =  nil;
        _DrawingView.lineColor = colorBtn.backgroundColor;
    }
    
}

/**
 <#Description#>
 */
- (void) clearStamp
{
    stampImage  =  nil;
}

int MirrorTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)Mirror:(id)sender
{
    MirrorTap++;
    if (MirrorTap == 1)
    {
        stretchImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
    else if (MirrorTap == 2)
    {
        MirrorTap = 0;
        stretchImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    }
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)MoreColorPicker:(id)sender
{
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)Clear:(id)sender
{
    [self.DrawingView clear];
    
    [stretchImageView removeFromSuperview];
    [self.DrawingView clear];
    
    [[self.DrawingView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [stretchImageView removeFromSuperview];
    
    
}

#pragma Open the tools UIView on button click
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
-(void)openToolViewDisplay:(id)sender
{
    [self closeToolViewDisplayed];
    openViewTag = [sender tag];
    UIBarButtonItem *toolTag = (UIBarButtonItem*)sender;
    switch (toolTag.tag)
    {
        case 1:
        {
            //            _FontStyleTopOffset.constant  = 136;
            //            [UIView animateWithDuration:1.0 animations:^{
            //                [_textStyleView layoutIfNeeded];
            //            }];
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _textStyleView.frame = CGRectMake(_textStyleView.frame.origin.x, _textStyleView.frame.origin.y + 67, _textStyleView.frame.size.width, _textStyleView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 2://opens the shape UIView
        {
            //            _clipArtTopOffset.constant  = 143;
            //
            //            [UIView animateWithDuration:1.0 animations:^{
            //                [_clipArtView layoutIfNeeded];
            //            }];
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _clipArtView.frame = CGRectMake(_clipArtView.frame.origin.x, _clipArtView.frame.origin.y + 450, _clipArtView.frame.size.width, _clipArtView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
            
        }
            break;
        case 3: //opens the colorPicker
        {
            
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _colorPickerView.frame = CGRectMake(_colorPickerView.frame.origin.x, _colorPickerView.frame.origin.y + 361, _colorPickerView.frame.size.width, _colorPickerView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 4: // open write tool select UIVew
        {
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _writeToolView.frame = CGRectMake(_writeToolView.frame.origin.x, _writeToolView.frame.origin.y + 86, _writeToolView.frame.size.width, _writeToolView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 5:// open eraser UIVew
        {
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _eraserView.frame = CGRectMake(_eraserView.frame.origin.x, _eraserView.frame.origin.y + 88, _eraserView.frame.size.width, _eraserView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 6: // opens additional UIView
        {
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _moreView.frame = CGRectMake(_moreView.frame.origin.x, _moreView.frame.origin.y + 340, _moreView.frame.size.width, _moreView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
    }
}

#pragma close the tools UIView on button click
/**
 <#Description#>
 
 @return <#return value description#>
 */
-(BOOL) closeToolViewDisplayed
{
    BOOL result = NO;
    switch (openViewTag)
    {
        case 1:
        {
            textTap = 0;
            //_FontStyleTopOffset.constant  = 49;
            self.DrawingView.drawTool = NOTESDrawingToolTypeText;
            [UIView animateKeyframesWithDuration:2.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _textStyleView.frame = CGRectMake(_textStyleView.frame.origin.x, _textStyleView.frame.origin.y - 67, _textStyleView.frame.size.width, _textStyleView.frame.size.height);
                                          
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
            
            return YES;
        }
            break;
        case 2:
        {
            shapeTap = 0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _clipArtView.frame = CGRectMake(_clipArtView.frame.origin.x, _clipArtView.frame.origin.y - 450, _clipArtView.frame.size.width, _clipArtView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
            return YES;
        }
            break;
        case 3:
        {
            paintTap = 0;
            Drawingcolortap = 0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _colorPickerView.frame = CGRectMake(_colorPickerView.frame.origin.x, _colorPickerView.frame.origin.y - 361, _colorPickerView.frame.size.width, _colorPickerView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];            return YES;
        }
            break;
        case 4:
        {
            writeTap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _writeToolView.frame = CGRectMake(_writeToolView.frame.origin.x, _writeToolView.frame.origin.y - 86, _writeToolView.frame.size.width, _writeToolView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
        case 5:
        {
            eraserTap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _eraserView.frame = CGRectMake(_eraserView.frame.origin.x, _eraserView.frame.origin.y - 88, _eraserView.frame.size.width, _eraserView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];            return YES;
        }
            break;
        case 6:
        {
            moreTap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:animation
                                      animations:^{
                                          _moreView.frame = CGRectMake(_moreView.frame.origin.x, _moreView.frame.origin.y - 340, _moreView.frame.size.width, _moreView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
    }
    return result;
}

#pragma mark PickerView Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray[component]count];
    
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerArray[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.DrawingView.fontStyle  = (NSString *)pickerArray[component][row];
    }
    else if (component == 1)
    {
        self.DrawingView.fontSize = [pickerArray[component][row]floatValue];
    }
    
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)BIU:(id)sender
{
    UIButton *BIU  =  (UIButton*)sender;
    switch(BIU.tag)
    {
        case 200:
            break;
        case 201:
            break;
        case 202:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

