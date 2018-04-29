#import <Foundation/Foundation.h>


int main(int argc, char * argv[]) {

	int a = 2;
	void (^blk)(void) = ^{
        printf("%d", a);
    };

    blk();

    return 0;
}