From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] kernel/wq: Fix a alloc_workqueue() error path
Date: Sun,  3 Mar 2019 14:00:46 -0800
Message-ID: <20190303220046.29448-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, syzbot+17335689e239ce135d8b@syzkaller.appspotmail.com
List-Id: linux-rdma@vger.kernel.org

This patch fixes a use-after-free and a memory leak in an alloc_workqueue()
error path. This patch avoids that e.g. the following complaint gets
reported:

BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:197 [inline]
BUG: KASAN: use-after-free in lockdep_register_key+0x3b9/0x490 kernel/locking/lockdep.c:1023
Read of size 8 at addr ffff888090fc2698 by task syz-executor134/7858

CPU: 1 PID: 7858 Comm: syz-executor134 Not tainted 5.0.0-rc8-next-20190301 #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
 kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 __read_once_size include/linux/compiler.h:197 [inline]
 lockdep_register_key+0x3b9/0x490 kernel/locking/lockdep.c:1023
 wq_init_lockdep kernel/workqueue.c:3444 [inline]
 alloc_workqueue+0x427/0xe70 kernel/workqueue.c:4263
 ucma_open+0x76/0x290 drivers/infiniband/core/ucma.c:1732
 misc_open+0x398/0x4c0 drivers/char/misc.c:141
 chrdev_open+0x247/0x6b0 fs/char_dev.c:417
 do_dentry_open+0x488/0x1160 fs/open.c:771
 vfs_open+0xa0/0xd0 fs/open.c:880
 do_last fs/namei.c:3416 [inline]
 path_openat+0x10e9/0x46e0 fs/namei.c:3533
 do_filp_open+0x1a1/0x280 fs/namei.c:3563
 do_sys_open+0x3fe/0x5d0 fs/open.c:1063
 __do_sys_openat fs/open.c:1090 [inline]
 __se_sys_openat fs/open.c:1084 [inline]
 __x64_sys_openat+0x9d/0x100 fs/open.c:1084
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Allocated by task 7789:
 save_stack+0x45/0xd0 mm/kasan/common.c:75
 set_track mm/kasan/common.c:87 [inline]
 __kasan_kmalloc mm/kasan/common.c:497 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
 __do_kmalloc mm/slab.c:3726 [inline]
 __kmalloc+0x15c/0x740 mm/slab.c:3735
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:743 [inline]
 alloc_workqueue+0x13c/0xe70 kernel/workqueue.c:4236
 ucma_open+0x76/0x290 drivers/infiniband/core/ucma.c:1732
 misc_open+0x398/0x4c0 drivers/char/misc.c:141
 chrdev_open+0x247/0x6b0 fs/char_dev.c:417
 do_dentry_open+0x488/0x1160 fs/open.c:771
 vfs_open+0xa0/0xd0 fs/open.c:880
 do_last fs/namei.c:3416 [inline]
 path_openat+0x10e9/0x46e0 fs/namei.c:3533
 do_filp_open+0x1a1/0x280 fs/namei.c:3563
 do_sys_open+0x3fe/0x5d0 fs/open.c:1063
 __do_sys_openat fs/open.c:1090 [inline]
 __se_sys_openat fs/open.c:1084 [inline]
 __x64_sys_openat+0x9d/0x100 fs/open.c:1084
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7789:
 save_stack+0x45/0xd0 mm/kasan/common.c:75
 set_track mm/kasan/common.c:87 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
 __cache_free mm/slab.c:3498 [inline]
 kfree+0xcf/0x230 mm/slab.c:3821
 alloc_workqueue+0xc3e/0xe70 kernel/workqueue.c:4295
 ucma_open+0x76/0x290 drivers/infiniband/core/ucma.c:1732
 misc_open+0x398/0x4c0 drivers/char/misc.c:141
 chrdev_open+0x247/0x6b0 fs/char_dev.c:417
 do_dentry_open+0x488/0x1160 fs/open.c:771
 vfs_open+0xa0/0xd0 fs/open.c:880
 do_last fs/namei.c:3416 [inline]
 path_openat+0x10e9/0x46e0 fs/namei.c:3533
 do_filp_open+0x1a1/0x280 fs/namei.c:3563
 do_sys_open+0x3fe/0x5d0 fs/open.c:1063
 __do_sys_openat fs/open.c:1090 [inline]
 __se_sys_openat fs/open.c:1084 [inline]
 __x64_sys_openat+0x9d/0x100 fs/open.c:1084
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888090fc2580
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 280 bytes inside of
 512-byte region [ffff888090fc2580, ffff888090fc2780)

Reported-by: syzbot+17335689e239ce135d8b@syzkaller.appspotmail.com
Fixes: 669de8bda87b ("kernel/workqueue: Use dynamic lockdep keys for workqueues")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 kernel/workqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 497900263dbc..35fd0e697087 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4291,6 +4291,8 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 	return wq;
 
 err_free_wq:
+	wq_unregister_lockdep(wq);
+	wq_free_lockdep(wq);
 	free_workqueue_attrs(wq->unbound_attrs);
 	kfree(wq);
 	return NULL;
-- 
2.20.1
