### Block简介

> Block objects are a C-level syntactic and runtime feature. They are similar to standard C functions, but in addition to executable code they may also contain variable bindings to automatic(stack) or managed(heap) memory. A block can therefore maintain a set of (data) that it can use to impact behavior when executed.

这是Block的官方文档简介，可以这么理解这段话

* Block是C语言级别的功能
* Block跟C语言的函数很像，可以理解为匿名函数。但它除了一段可执行的代码以外，还包含自己的局部变量。更简单点说：Block包括一段代码和运行这段代码需要的数据

### Block语法

Block语法的格式
```
返回类型 (^Block变量名称)(参数列表) = ^(参数列表) { 表达式 }
int multiplier = 7;
int (^myBlock)(int) = ^(int num) { return num * multiplier }
```