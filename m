From: syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in __list_del_entry_valid (4)
Date: Sun, 25 Mar 2018 17:01:03 -0700
Message-ID: <001a1141551246502d056845782e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, jgg@ziepe.ca, leonro@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

Hello,

syzbot hit the following crash on upstream commit
bcfc1f4554662d8f2429ac8bd96064a59c149754 (Sat Mar 24 16:50:12 2018 +0000)
Merge tag 'pinctrl-v4.16-3' of  
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
syzbot dashboard link:  
https://syzkaller.appspot.com/bug?extid=29ee8f76017ce6cf03da

So far this crash happened 2 times on upstream.
syzkaller reproducer:  
https://syzkaller.appspot.com/x/repro.syz?id=5803165253369856
Raw console output:  
https://syzkaller.appspot.com/x/log.txt?id=5801459614482432
Kernel config:  
https://syzkaller.appspot.com/x/.config?id=-5034017172441945317
compiler: gcc (GCC) 7.1.1 20170620
user-space arch: i386

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for  
details.
If you forward the report, please keep this part and the footer.

audit: type=1400 audit(1521923673.824:8): avc:  denied  { map } for   
pid=4229 comm="syz-execprog" path="/root/syzkaller-shm086223256" dev="sda1"  
ino=16482 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
tcontext=unconfined_u:object_r:file_t:s0 tclass=file permissive=1
IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0x144/0x150  
lib/list_debug.c:54
Read of size 8 at addr ffff8801afaf33e0 by task syz-executor0/4703

CPU: 0 PID: 4703 Comm: syz-executor0 Not tainted 4.16.0-rc6+ #275
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
  print_address_description+0x73/0x250 mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report+0x23c/0x360 mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  __list_del_entry_valid+0x144/0x150 lib/list_debug.c:54
  __list_del_entry include/linux/list.h:117 [inline]
  list_del include/linux/list.h:125 [inline]
  cma_cancel_listens drivers/infiniband/core/cma.c:1569 [inline]
  cma_cancel_operation+0x455/0xd60 drivers/infiniband/core/cma.c:1597
  rdma_destroy_id+0xff/0xda0 drivers/infiniband/core/cma.c:1661
  ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1728
  __fput+0x327/0x7e0 fs/file_table.c:209
  ____fput+0x15/0x20 fs/file_table.c:243
  task_work_run+0x199/0x270 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
  do_group_exit+0x149/0x400 kernel/exit.c:968
  get_signal+0x73a/0x16d0 kernel/signal.c:2469
  do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
  exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:336 [inline]
  do_fast_syscall_32+0xbe6/0xf9f arch/x86/entry/common.c:392
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f03c99
RSP: 002b:00000000f7ede10c EFLAGS: 00000296 ORIG_RAX: 00000000000000f0
RAX: fffffffffffffe00 RBX: 000000000813af98 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 4703:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
  set_track mm/kasan/kasan.c:459 [inline]
  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
  kmem_cache_alloc_trace+0x136/0x740 mm/slab.c:3607
  kmalloc include/linux/slab.h:512 [inline]
  kzalloc include/linux/slab.h:701 [inline]
  rdma_create_id+0xd0/0x630 drivers/infiniband/core/cma.c:787
  ucma_create_id+0x35f/0x920 drivers/infiniband/core/ucma.c:480
  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1649
  __vfs_write+0xef/0x970 fs/read_write.c:480
  vfs_write+0x189/0x510 fs/read_write.c:544
  SYSC_write fs/read_write.c:589 [inline]
  SyS_write+0xef/0x220 fs/read_write.c:581
  do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
  do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 4703:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
  set_track mm/kasan/kasan.c:459 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
  __cache_free mm/slab.c:3485 [inline]
  kfree+0xd9/0x260 mm/slab.c:3800
  rdma_destroy_id+0x821/0xda0 drivers/infiniband/core/cma.c:1691
  ucma_close+0x100/0x2f0 drivers/infiniband/core/ucma.c:1728
  __fput+0x327/0x7e0 fs/file_table.c:209
  ____fput+0x15/0x20 fs/file_table.c:243
  task_work_run+0x199/0x270 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x9bb/0x1ad0 kernel/exit.c:865
  do_group_exit+0x149/0x400 kernel/exit.c:968
  get_signal+0x73a/0x16d0 kernel/signal.c:2469
  do_signal+0x90/0x1e90 arch/x86/kernel/signal.c:809
  exit_to_usermode_loop+0x258/0x2f0 arch/x86/entry/common.c:162
  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:336 [inline]
  do_fast_syscall_32+0xbe6/0xf9f arch/x86/entry/common.c:392
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff8801afaf3200
  which belongs to the cache kmalloc-1024 of size 1024
The buggy address is located 480 bytes inside of
  1024-byte region [ffff8801afaf3200, ffff8801afaf3600)
The buggy address belongs to the page:
page:ffffea0006bebc80 count:1 mapcount:0 mapping:ffff8801afaf2000 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffff8801afaf2000 0000000000000000 0000000100000007
raw: ffffea0007272f20 ffffea0006bc6520 ffff8801dac00ac0 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801afaf3280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801afaf3300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801afaf3380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff8801afaf3400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801afaf3480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.
