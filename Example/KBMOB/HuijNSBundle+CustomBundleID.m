#import "HuijNSBundle+CustomBundleID.h"
#import <objc/runtime.h>

static char const * const kOriginalInfoDictKey = "kOriginalInfoDictKey";
static char const * const kCurrentBundleIDKey = "kCurrentBundleIDKey";

@implementation NSBundle (CustomBundleID)

#pragma mark - 线程安全的属性访问
- (NSDictionary *)originalInfoDictionary {
    @synchronized (self) {
        return objc_getAssociatedObject(self, kOriginalInfoDictKey);
    }
}

- (void)setOriginalInfoDictionary:(NSDictionary *)dict {
    @synchronized (self) {
        objc_setAssociatedObject(self, kOriginalInfoDictKey, [dict copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSString *)currentBundleID {
    @synchronized (self) {
        return [objc_getAssociatedObject(self, kCurrentBundleIDKey) copy]; // 返回拷贝保证线程安全
    }
}

- (void)setCurrentBundleID:(NSString *)bundleID {
    @synchronized (self) {
        objc_setAssociatedObject(self, kCurrentBundleIDKey, [bundleID copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

#pragma mark - 安全的方法交换
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(bundleIdentifier)
                      withNewSelector:@selector(hj_swizzled_bundleIdentifier)];
        
        [self swizzleInstanceMethod:@selector(objectForInfoDictionaryKey:)
                      withNewSelector:@selector(hj_swizzled_objectForInfoDictionaryKey:)];
        
        [self swizzleInstanceMethod:@selector(infoDictionary)
                      withNewSelector:@selector(hj_swizzled_infoDictionary)];
    });
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector
              withNewSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 修改后的交换方法
- (NSString *)hj_swizzled_bundleIdentifier {
    NSString *customID = nil;
    @synchronized (self) {
        customID = self.currentBundleID;
    }
    return customID ?: [self hj_swizzled_bundleIdentifier]; // 保持递归调用原始实现
}

- (id)hj_swizzled_objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleIdentifier"]) {
        NSString *customID = nil;
        @synchronized (self) {
            customID = self.currentBundleID;
        }
        if (customID) return customID;
    }
    return [self hj_swizzled_objectForInfoDictionaryKey:key];
}

- (NSDictionary<NSString *, id> *)hj_swizzled_infoDictionary {
    // 安全获取原始字典（避免直接操作不可变字典）
    NSDictionary *originalDict = [self hj_swizzled_infoDictionary];
    NSMutableDictionary *mergedDict = [NSMutableDictionary dictionaryWithDictionary:originalDict];
    
    @synchronized (self) {
        if (self.currentBundleID) {
            // 从关联对象获取原始值（线程安全）
            NSDictionary *originalInfo = self.originalInfoDictionary;
            
            // 保留关键字段的原始值
            mergedDict[@"CFBundleName"] = originalInfo[@"CFBundleName"] ?: mergedDict[@"CFBundleName"];
            mergedDict[@"CFBundleExecutable"] = originalInfo[@"CFBundleExecutable"] ?: mergedDict[@"CFBundleExecutable"];
            
            // 更新 Bundle ID
            mergedDict[@"CFBundleIdentifier"] = self.currentBundleID;
        }
    }
    
    return [mergedDict mutableCopy]; // 返回可变字典
}

#pragma mark - 公开方法（线程安全）
- (void)custom_setBundleIdentifier:(NSString *)bundleID {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 线程安全保存原始字典
        NSDictionary *original = [[NSBundle mainBundle].infoDictionary copy];
        [[NSBundle mainBundle] setOriginalInfoDictionary:original];
    });
    
    @synchronized (self) {
        self.currentBundleID = bundleID;
    }
}

@end
