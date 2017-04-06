//
//  ViewController.m
//  dispatch_semaphone
//
//  Created by hh on 17/4/5.
//  Copyright © 2017年 DLY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testDispatchSemaphone];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^(){
        [self groupSync];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建并发为10的线程队列

- (void)testDispatchSemaphone{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"线程%@%i",[NSThread currentThread],i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)groupSync
{
    dispatch_queue_t disqueue =  dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(3);
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^(){
            sleep(2);
            NSLog(@"任务1完成");
        });
        
        NSLog(@"任务一完成");
    });
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(1);
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my2", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^(){
            sleep(2);
            NSLog(@"任务2完成");
        });
        NSLog(@"任务二完成");
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        NSLog(@"dispatch_group_notify 执行");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
        NSLog(@"dispatch_group_wait 结束");
    });
}

@end
