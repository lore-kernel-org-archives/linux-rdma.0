From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in ucma_destroy_id
Date: Wed, 4 Jul 2018 16:18:16 -0700
Message-ID: <20180704231816.GI725@sol.localdomain>
References: <001a113f2be0b4b0ad0567464413@google.com>
 <000000000000b4f5de0568760341@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000000000000b4f5de0568760341@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+449737930e1faf08523e@syzkaller.appspotmail.com>
Cc: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, ira.weiny@intel.com, jgg@ziepe.ca, leonro@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 28, 2018 at 02:56:01AM -0700, syzbot wrote:
> syzbot has found reproducer for the following crash on upstream commit
> 3eb2ce825ea1ad89d20f7a3b5780df850e4be274 (Sun Mar 25 22:44:30 2018 +0000)
> Linux 4.16-rc7
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=449737930e1faf08523e
> 
> So far this crash happened 38 times on upstream.
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6522989826801664
> syzkaller reproducer:
> https://syzkaller.appspot.com/x/repro.syz?id=4513717152645120
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=6625862883475456
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-8440362230543204781
> compiler: gcc (GCC) 7.1.1 20170620
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+449737930e1faf08523e@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed.
> 
> INFO: task syzkaller681645:4295 blocked for more than 120 seconds.
>       Not tainted 4.16.0-rc7+ #3
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syzkaller681645 D20744  4295   4293 0x00000000
> Call Trace:
>  context_switch kernel/sched/core.c:2862 [inline]
>  __schedule+0x8fb/0x1ec0 kernel/sched/core.c:3440
>  schedule+0xf5/0x430 kernel/sched/core.c:3499
>  schedule_timeout+0x1a3/0x230 kernel/time/timer.c:1777
>  do_wait_for_common kernel/sched/completion.c:86 [inline]
>  __wait_for_common kernel/sched/completion.c:107 [inline]
>  wait_for_common kernel/sched/completion.c:118 [inline]
>  wait_for_completion+0x415/0x770 kernel/sched/completion.c:139
>  ucma_destroy_id+0x2f0/0x500 drivers/infiniband/core/ucma.c:611
>  ucma_write+0x2d6/0x3d0 drivers/infiniband/core/ucma.c:1649
>  __vfs_write+0xef/0x970 fs/read_write.c:480
>  vfs_write+0x189/0x510 fs/read_write.c:544
>  SYSC_write fs/read_write.c:589 [inline]
>  SyS_write+0xef/0x220 fs/read_write.c:581
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x440719
> RSP: 002b:00007ffc7e451f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007ffc7e451f50 RCX: 0000000000440719
> RDX: 0000000000000018 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 00007ffc7e451fa0 R09: 00007ffc7e451fa0
> R10: 00007ffc7e451fa0 R11: 0000000000000246 R12: 0000000000402040
> R13: 00000000004020d0 R14: 0000000000000000 R15: 0000000000000000

This was fixed by commit ef95a90ae6f4f2:

#syz fix: RDMA/ucma: ucma_context reference leak in error path

- Eric
