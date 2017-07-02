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
	DRKGenderFemale
};

@interface DRKUser : NSObject 

@property (nonatomic, copy) NSString *name; 
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) DRKGender gender;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age gender:(DRKGender)gender;
+ (instancetype)userWithName:(NSString *)name age:(NSUInteger)age gender:(DRKGender)gender;

@end
```

### 2. Property 后面有哪些修饰符？

- 原子性
	- atomic
	- nonatomic
- 读写权限
	- readwrite
	- readonly
- 内存管理
	- strong
	- weak
	- assign
	- copy
	- unsafe_unretained
- 方法名
	+ `getter=<name>`
	+ `setter=<name>`

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

- app crash, array的实际类型是NSArray，而不是NSMutableArray，这时候如果你对array调用只属于NSMutableArray的方法（比如添加元素），app就会crash掉。
- 使用了atomic属性会影响性能


### 6. 如何让自己的类用copy修饰符？如何重写带copy关键字的setter？

如何让自己的类用copy修饰符

- 声明该类遵从NSCopying protocol
- 实现protocol里面的方法： - (id)copyWithZone:(NSZone *)zone;

如何重写带copy关键字的setter

```
- (void)setArray:(NSArray *)array
{
	_array = [array copy];
}
```

### 7. @property 的本质是什么？ivar，getter，setter是如何生成并添加到这个类中的？

@property的本质是什么

- property的本质是定义一个实例变量（ivar），并且生成getter和setter方法

ivar，getter，setter是如何生成并添加到这个类中的

- “自动合成”（`autosynthesis`）：编译器在编译期间会根据property的名字向类中添加一个实例变量，该实例变量的名字是属性名前面加下划线（当然也可以使用@synthesizel来自己指定实例变量名：`@synthesize propertyName = instanceVariableName;`）。同时编译器还会生成该实例变量的存取方法（`Access Methods`）也就是getter和setter方法

### 8. @protocol和category中如何使用@property？

- @protocol中使用@property，只会声明两个方法：setter和getter，不会生成变量
- category里面使用@property同样只会声明两个方法：setter和getter，不会生成变量，需要自己实现这两个方法
- 如果真的想给category添加属性的实现，需要使用runtime机制，会用到两个函数：
	
	- `objc_setAssociatedObject`
	- `objc_getAssociatedObject`

### 9. runtime 如何实现 weak 属性？

- runtime时，当初始化一个weak对象时，会把weak变量所指向的对象地址作为key，weak变量的地址作为value存进一个hash表中，当weak变量所指向的对象引用计数为0，被释放时，会以这个该对象地址为key，在hash表中搜索weak变量，然后设置为nil


### 10. weak属性需要在dealloc中置nil么？（*）

- 不需要，在ARC模式下，无论strong属性还是weak属性都不需要在dealloc中置nil

### 11. @synthesize和@dynamic分别有什么用？（**）

- @synthesize 是用来告诉编译器自动生成getter和setter方法的
- @dynamic 是用来告诉编译器不要为属性变量生成getter和setter方法，用户自己会考虑生成getter和setter方法，这时候如果你没有添加getter和setter的话，如果运行时调用getter或setter方法就会crash。

### 12. ARC下， 不显示制定任何属性关键字时， 默认的关键字都有哪些？（***）
 
- 对于对象类型属性：atomic，readwrite，strong
- 对于非对象类型的属性：atomic，readwrite，assign


### 13. 用@property声明的NSString（或NSArray， NSDictionary）经常用copy关键字，为什么？如果改用strong关键字，肯造成什么问题？（***）

- 因为NSString，NSArray和NSDictionary都有可变类型的子类NSMutableString，NSMutableArray，和NSMutableDictionary，如果你想要你的属性不受赋的值的变化而变化的话，你就必须使用copy修饰符，因为copy修饰符会在赋值时调用copy方法，如果赋来的值可变类型的，就会产生一个对应的不变类型的新值，然后再赋给属性变量
- 如果使用strong的话，可能的问题是你的属性变量的值会随着你赋来的值的变化而变化

### 14. @synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量吗？（***）

- 当你声明一个属性时，如果没有写@synthesize，默认编译器会帮你添加成 `@synthesize propertyName = _propertyName;`，这表示实例变量的名字是_propertyName（比如 `@synthesize firstName = _firstName;`, _firstName就是实例变量名），即默认情况下，实例变量名是属性名前面加一个下划线。
- 当你声明一个属性，如果你想自己决定实例变量名，`@synthesize propertyName = instanceVariableName; `(比如`@synthesize firstName = ivar_firstName;`这时候ivar_firstName就是实例变量名)
- 当你声明property名为foo，存在一个_foo的实例变量，如果你没有重写@synthesize的话，是不会自动生成新变量的

### 15. 在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？（*****）

- 当你同时重写了getter和setter的时候，自动合成（autosynthesis)会失效，你需要使用@synthesize手动合成实例变量
- 对于只读属性，你只要重写了getter方法，自动合成同样会失效
- 使用@synthesize指定实例变量名（不建议使用，建议使用默认规则）

### 16. objc中向一个nil对象发送消息将会发生什么？（**）

- 对nil对象发送消息不会有任何作用

### 17. objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？（***）

- `[obj foo];`方法编译后就是`objc_msgSend(obj, @selector(foo));`，所以向对象发送消息，其实就是调用objc_msgSend()函数

### 18. 什么时候会抛unrecognized selector的异常？（***）

- 简单的说：当你调用某个对象的方法，而这个对象又没有实现这个方法的时候，就会抛unrecognized selector的异常
- 深入点的解释：当你调用某个对象的方法时，runtime library会根据该对象里面isa指针找到这个对象的类对象，然后在类对象中的方法列表以及父类对象的方法列表中查找这个方法，然后一直查到最顶层的父类对象，都没有找到这个方法的话，程序就会抛unrecognized selector的异常

### 19. 一个objc对象如何进行内存布局？（考虑有父类的情况）（****）


### 20. 一个objc对象的isa的指针指向什么？有什么作用？（****）

- objc对象的isa的指针指向该对象的元类

### 21. 下面的代码输出什么？ （****）

@implementation Son: Father
```
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
```
- Son 
- Son

### 22. runtime如何通过selector找到相应的IMP地址？（分别考虑类方法和实例方法）(****)

- 实例方法：调用实例对象方法时，runtime library会根据该对象里面isa指针找到这个对象的类对象，然后在类对象中的方法列表以及父类对象的方法列表中查找这个方法，每个类对象里面都维护着该类的实现的方法列表，方法列表中记录着方法名，方法实现以及参数类型，根据selector提供的方法名就能找到对应的方法实现
- 类方法：调用类方法时，runtime library会根据类对象的isa指针找到这个的类对象的元类对象（meta class），元类对象中同样维护着类方法的列表，根据selector提供的方法名就可以找到对用的方法实现了。


### 23. 使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放吗？（****）

- 不需要

### 24. objc中的类方法和实例方法有什么本质区别和联系？（****）


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





