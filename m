From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: KASAN: use-after-free Read in alloc_workqueue
Date: Sun, 3 Mar 2019 13:38:25 -0800
Message-ID: <e0ef3cb3-111b-2b89-16df-3da89f937d4e@acm.org>
References: <0000000000008a8bf4058334b76e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000008a8bf4058334b76e@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+17335689e239ce135d8b@syzkaller.appspotmail.com>, danitg@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, roland@purestorage.com, sean.hefty@intel.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
List-Id: linux-rdma@vger.kernel.org

On 3/3/19 10:22 AM, syzbot wrote:
> syzbot found the following crash on:
> 
> HEAD commit:    c63e9e91a254 Add linux-next specific files for 20190301
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ac728d200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f5875f9dc6e009b2
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=17335689e239ce135d8b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134808fb200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1541889d200000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+17335689e239ce135d8b@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __read_once_size 
> include/linux/compiler.h:197 [inline]
> BUG: KASAN: use-after-free in lockdep_register_key+0x3b9/0x490 
> kernel/locking/lockdep.c:1023
> Read of size 8 at addr ffff888090fc2698 by task syz-executor134/7858
> 
> CPU: 1 PID: 7858 Comm: syz-executor134 Not tainted 
> 5.0.0-rc8-next-20190301 #1
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
>   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>   __read_once_size include/linux/compiler.h:197 [inline]
>   lockdep_register_key+0x3b9/0x490 kernel/locking/lockdep.c:1023
>   wq_init_lockdep kernel/workqueue.c:3444 [inline]
>   alloc_workqueue+0x427/0xe70 kernel/workqueue.c:4263
>   ucma_open+0x76/0x290 drivers/infiniband/core/ucma.c:1732
>   misc_open+0x398/0x4c0 drivers/char/misc.c:141
>   chrdev_open+0x247/0x6b0 fs/char_dev.c:417
>   do_dentry_open+0x488/0x1160 fs/open.c:771
>   vfs_open+0xa0/0xd0 fs/open.c:880
>   do_last fs/namei.c:3416 [inline]
>   path_openat+0x10e9/0x46e0 fs/namei.c:3533
>   do_filp_open+0x1a1/0x280 fs/namei.c:3563
>   do_sys_open+0x3fe/0x5d0 fs/open.c:1063
>   __do_sys_openat fs/open.c:1090 [inline]
>   __se_sys_openat fs/open.c:1084 [inline]
>   __x64_sys_openat+0x9d/0x100 fs/open.c:1084
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe

I think this is caused by a change I made in the workqueue 
implementation. I will submit a fix.

Bart.
