### 1. 代码规范

```
typedef enum{
	UserSex_Man,
	UserSex_Woman
}UserSex;

@interface UserModel :NSObject


@property(nonatomic, strong) NSString *name;
@property (assign, nonatomic) int age;
@property (nonatomic, assign) UserSex sex;

-(id)initUserModelWithUserName: (NSString*)name withAge:(int)age;


-(void)doLogIn;

@end
```

请纠错

我的答案：
```
typedef enum(NSInteger, DRKGender) {
	DRKGenderUnknown,
	DRKGenderMale,
	DRKGenderFemale,
	DRKGenderNeuter
};

@interface DRKUser : NSObject 

@property (nonatomic, readonly, copy) NSString *name; 
@property (nonatomic, readonly, assign) NSUInteger age;
@property (nonatomic, readonly, assign) DRKGender gender;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(DRKGender)gender;
+ (instancetype)userWithName:(NSString *)name age:(NSUInteger)age gender:(DRKGender)gender;

@end
```

### 2. Property 后面有哪些修饰符？
nonatomic/atomic, readonly/readwrite, strong/weak/assign/copy

### 3. 什么情况下使用weak关键字，相比assign有什么不同？
什么情况下使用weak关键字？ 

- ARC中，weak表示弱引用。一般解决引用循环问题。比如：delegate
- 还有一种情况IBOutlet控件属性一般也是用weak。这个是因为本身对其有过一个强引用了，没必要再强引用一次

不同点：

- weak 表示弱引用， 为其赋值时，setter方法既不添加一个强引用到新值上面，也不释放旧值。并且如果该属性所指向的对象没有任何强引用，该对象就会被释放，同事属性值也会被置为nil。assign用来修饰纯量类型（scalar type， 比如NSInteger）的属性变量，不能修饰对象类型。当然也就不存在强引用还是弱引用的问题了

### 4. 怎么用copy关键字？

- 一般用于对NSArray，NSString，NSDictionary的属性变量的修饰，是因为他们有对应的可变类型：NSMutableArray，NSMutableString，NSMutabelDictionary
- 当定义一个属性变量指向block时，也应该使用copy修饰符

### 5. 这个写法会有什么问题： @property (copy) NSMutableArray *array;

回答：a. app crash, array的实际类型是NSArray，而不是NSMutableArray，这时候如果你对array调用只属于NSMutableArray的方法（比如添加元素），app就会crash掉。
     b. 使用了atomic属性会影响性能

6. 如何让自己的类用copy修饰符？如何重写带copy关键字的setter？
回答： 1）a. 声明该类遵从NSCopying protocol
         B. 实现protocol里面的方法： - (id)copyWithZone:(NSZone *)zone;
2）
- (void)setArray:(NSArray *)array
{
	_array = [array copy];
}

7. @property 的本质是什么？ivar，getter，setter是如何生成并添加到这个类中的？
回答：1）property的本质是定义一个类变量，并且声称getter和setter方法
2）ivar
3）getter和setter是编译器根据property的定义自动生成的

8. @protocol和category中如何使用@property？
回答：1) @protocol中使用@property，只是声明两个方法：setter和getter，不会生成变量
2）category里面使用@property同样只是声明两个方法：setter和getter，不会生成变量，需要自己实现这两个方法

9. runtime 如何实现 weak 属性？
回答：

* 10. weak属性需要在dealloc中置nil么？
回答：不需要，weak属性变量会在没有任何强引用时自动置nil

** 11. @synthesize和@dynamic分别有什么用？
回答：

*** 12. ARC下， 不显示制定任何属性关键字时， 默认的关键字都有哪些？
回答： 1）对于对象类型属性：atomic，readwrite，strong
2） 对于非对象类型的属性：atomic，readwrite，assign

*** 13. 用@property声明的NSString（或NSArray， NSDictionary）经常用copy关键字，为什么？如果改用strong关键字，肯造成什么问题？
1） 因为NSString，NSArray和NSDictionary都有可变类型的子类NSMutableString，NSMutableArray，和NSMutableDictionary，如果你想要你的属性不受赋的值的变化而变化的话，你就必须使用copy修饰符，因为copy修饰符会在赋值时调用copy方法，如果赋来的值可变类型的，就会产生一个对应的不变类型的新值，然后再赋给属性变量
2）如果使用strong的话，可能的问题是你的属性变量的值会随着你赋来的值的变化而变化

*** 14. @synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量吗？

***** 15. 在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？

** 16. objc中向一个nil对象发送消息将会发生什么？
回答：不会发生任何事

*** 17. objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？

*** 18. 什么时候会包unrecognized selector的异常？

**** 19. 一个objc对象如何进行内存布局？（考虑有父类的情况）

**** 20. 一个objc对象的isa的指针指向什么？有什么作用？

**** 21. 下面的代码输出什么？ --

@implementation Son: Father

- (id)init 
{
	self = [super init];
	if (self) {
		NSLog(@"%@", NSStringFromClass([self class]));
		NSLog(@"%@", NSStringFromClass([super class]));
	}
	return self;
}

@end
回答：Son 
     Son

**** 22. runtime如何通过selector找到相应的IMP地址？（分别考虑类方法和实例方法）

**** 23. 使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放吗？

***** 24. objc中的类方法和实例方法有什么本质区别和联系？

***** 25. _objc_msgForward函数是做什么的，直接调用它将会发生什么？

***** 26. runtime如何实现weak变量的自动置nil？

***** 27. 能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？

*** 28. runloop和线程有什么关系？

*** 29. runloop的mode作用是什么？

**** 30. 以 + scheduledTimerWithTimInterval...的方式触发的timer，在滑动页面的列表时，timer会暂停回调吗？为什么？如何解决？

***** 31. 猜想runloop内部是如何实现的？

* 32. objc使用什么机制管理对象内存的？

**** 33. ARC通过什么方式帮助开发者管理内存？

**** 34. 不手动制定autoreleasepool的前提下，一个autorelease对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）

**** 35. BAD_ACCESS在什么情况下出现？

**** 36. 苹果是如何实现autoreleasepool的？

** 37. 使用block时什么情况下会发生引用循环，如何解决？

** 38. 在block内如何修改block外部变量？

*** 39. 使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？

** 40. GCD的队列（dispatch_queue_t)分哪两种类型？

**** 41. 如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）

**** 42. dispatch_barrier_async的作用是什么？

***** 43. 苹果为什么要废弃dispatch_get_current_queue？

***** 44. 一下代码运行结果如何？

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"1");
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSLog(@"2");
	});
	NSLog(@"3");
}

** 45. addObserver:forKeyPath:options:context: 各个参数的作用分别是什么？observer中需要实现的哪个方法才能获得KVO回调？

*** 46. 如何手动触发一个value的KVO？

*** 47. 若一个类有实例变量NSString *_foo，调用setValue:forKey:时，可以以foo还是_foo作为key？

**** 48. KVC的keyPath中的集合运算符如何使用？

**** 49. KVC和KVO的keyPath一定是属性吗？

***** 50. 如何关闭默认的KVO的默认实现，并进入自定义的KVO实现？

***** 51. apple用什么方式实现对一个对象的KVO？

** 52. IBOutlet连出来的视图属性为什么可以被设置为weak？

***** 53. IB中User Defined Runtime Attributes如何使用？

*** 54. 如何调试BAD_ACCESS错误？

*** 55. lldb（gdb）常用的调试命令？
















































































