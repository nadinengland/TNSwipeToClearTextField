//
//  TNSwipeToClearTextField.m
//  TNSwipeToClearTextField
//
//  Created by Thomas Nadin on 26/05/2012.
//  Copyright (c) 2012 Thomas Nadin. All rights reserved.
//

#import "TNSwipeToClearTextField.h"

@interface TNSwipeToClearTextField()

@property (strong) NSString* removedText;
@property (assign) BOOL canUndo;

- (void)initializeSwipeRecognizers;
- (void)clearSwipeRecognized:(UIGestureRecognizer*)recognizer;
- (void)undoSwipeRecognized:(UIGestureRecognizer*)recognizer;
- (void)textFieldDidChange:(UITextView*)textView;
//- (void)textFieldDidBeginEditing:(id)sender;

@end

@implementation TNTextField

@synthesize removedText = _removedText;
@synthesize canUndo = _canUndo;

- (id)init
{
	self = [super init];
    if (self) {
        [self initializeSwipeRecognizers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
			[self initializeSwipeRecognizers];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			[self initializeSwipeRecognizers];
    }
    return self;
}

#pragma mark - Initalize Swip Recognizer

- (void)initializeSwipeRecognizers
{
	// Clear (Left) Recognizer
	UISwipeGestureRecognizer* clearRecognizer;
	
	clearRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clearSwipeRecognized:)];
	clearRecognizer.direction = (UISwipeGestureRecognizerDirectionLeft);
	
	[self addGestureRecognizer:clearRecognizer];
	
	// Undo (Right) Recognizer
	UISwipeGestureRecognizer* undoRecognizer;
	
	undoRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(undoSwipeRecognized:)];
	undoRecognizer.direction = (UISwipeGestureRecognizerDirectionRight);
	
	[self addGestureRecognizer:undoRecognizer];
	
	// Register for Events
	[self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	//[self addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
}

#pragma mark - Text Field Events

- (void)textFieldDidChange:(id)sender
{
	self.canUndo = NO;
}

/*
- (void)textFieldDidBeginEditing:(UITextView*)textView
{
	if (textView.hasText == YES) {
		UITextPosition* start = [textView positionFromPosition:textView.beginningOfDocument offset:1];
		//UITextPosition* end = [textView positionFromPosition:textView.beginningOfDocument offset:3];
		//UITextRange* range = [textView textRangeFromPosition:start toPosition:end];
		UITextRange* range = [textView textRangeFromPosition:start toPosition:textView.endOfDocument];
		[textView setSelectedTextRange:range];
	}
}
*/

#pragma mark - UIGestureRecognizer Delegate

- (void)clearSwipeRecognized:(UISwipeGestureRecognizer *)recognizer
{
	BOOL correctState = (recognizer.state == UIGestureRecognizerStateEnded);
	BOOL hasText = (self.hasText == YES);
	
	if (correctState && hasText) {
		// Store for later
		self.removedText = self.text;
		
		// Remove and set for undo
		self.text = nil;
		self.canUndo = YES;
		
		// Focus
		[self becomeFirstResponder];
	}
}

- (void)undoSwipeRecognized:(UIGestureRecognizer *)recognizer
{
	BOOL isEndState = (recognizer.state == UIGestureRecognizerStateEnded);
	BOOL notNil = (self.removedText != nil);
	BOOL canUndo = (self.canUndo == YES);

	if (isEndState && notNil && canUndo) {
		self.text = self.removedText;
	}
}


#pragma mark - UIKeyInput Protocol Overrides

- (BOOL)hasText
{
	BOOL notNil = (self.text != nil);
	BOOL notEmpty = (self.text.length > 0);
	
	return (notNil && notEmpty);
}

@end
