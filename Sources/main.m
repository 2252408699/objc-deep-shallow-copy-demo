#import <Foundation/Foundation.h>

@interface NotificationTemplate : NSObject <NSCopying>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray<NSMutableString *> *tags;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *metadata;
- (instancetype)initWithTitle:(NSString *)title
                         tags:(NSMutableArray<NSMutableString *> *)tags
                     metadata:(NSMutableDictionary<NSString *, NSString *> *)metadata;
- (NotificationTemplate *)deepCopy;
@end

@implementation NotificationTemplate
- (instancetype)initWithTitle:(NSString *)title
                         tags:(NSMutableArray<NSMutableString *> *)tags
                     metadata:(NSMutableDictionary<NSString *, NSString *> *)metadata {
    self = [super init];
    if (self) {
        _title = [title copy];
        _tags = tags;
        _metadata = metadata;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NotificationTemplate *copy = [[[self class] allocWithZone:zone]
        initWithTitle:self.title
                 tags:[self.tags mutableCopy]
             metadata:self.metadata];
    return copy;
}

- (NotificationTemplate *)deepCopy {
    NSMutableArray<NSMutableString *> *copiedTags =
        [NSMutableArray arrayWithCapacity:self.tags.count];
    for (NSMutableString *tag in self.tags) {
        [copiedTags addObject:[tag mutableCopy]];
    }
    return [[NotificationTemplate alloc]
        initWithTitle:self.title
                 tags:copiedTags
             metadata:[self.metadata mutableCopy]];
}
@end

static void Check(BOOL condition, NSString *label) {
    if (!condition) {
        NSLog(@"FAIL: %@", label);
        exit(1);
    }
    NSLog(@"PASS: %@", label);
}

int main(void) {
    @autoreleasepool {
        NotificationTemplate *original = [[NotificationTemplate alloc]
            initWithTitle:@"Order shipped"
                     tags:[@[ [@"ios" mutableCopy], [@"priority" mutableCopy] ] mutableCopy]
                 metadata:[@{ @"channel": @"push", @"locale": @"en" } mutableCopy]];

        NotificationTemplate *topLevelCopy = [original copy];
        Check(topLevelCopy.tags != original.tags, @"top-level tag arrays are different objects");
        Check(topLevelCopy.tags[0] == original.tags[0], @"top-level copy shares mutable tag elements");

        [topLevelCopy.tags[0] appendString:@"-edited"];
        Check([original.tags[0] isEqualToString:@"ios-edited"],
              @"shared element mutation is visible through original array");

        NotificationTemplate *independent = [original deepCopy];
        Check(independent != original, @"deep copy creates a new template object");
        Check(independent.tags[0] != original.tags[0], @"deep copy creates independent tag elements");
        Check(independent.metadata != original.metadata, @"deep copy creates independent metadata");

        [independent.tags[0] appendString:@"-draft"];
        independent.metadata[@"channel"] = @"email";
        Check([original.tags[0] isEqualToString:@"ios-edited"] &&
              [original.metadata[@"channel"] isEqualToString:@"push"],
              @"editing deep copy leaves original template unchanged");

        NSLog(@"Original tags: %@", original.tags);
        NSLog(@"Independent tags: %@", independent.tags);
        NSLog(@"All copy-semantics checks passed.");
    }
    return 0;
}
