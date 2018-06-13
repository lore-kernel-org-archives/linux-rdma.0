From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: WARNING: bad unlock balance in ucma_event_handler
Date: Wed, 13 Jun 2018 11:05:43 -0600
Message-ID: <20180613170543.GB30019@ziepe.ca>
References: <000000000000af6530056e863794@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000000000000af6530056e863794@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com>
Cc: dasaratharaman.chandramouli@intel.com, dledford@redhat.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, roland@purestorage.com, sean.hefty@intel.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 06:47:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    73fcb1a370c7 Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16d70827800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> dashboard link: https://syzkaller.appspot.com/bug?extid=e5579222b6a3edd96522
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=176daf97800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e7bd57800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com
> 
> 
> =====================================
> WARNING: bad unlock balance detected!
> 4.17.0-rc5+ #58 Not tainted
> kworker/u4:0/6 is trying to release lock (&file->mut) at:
> [<ffffffff8593ecc0>] ucma_event_handler+0x780/0xff0
> drivers/infiniband/core/ucma.c:390
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 4 locks held by kworker/u4:0/6:
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> __write_once_size include/linux/compiler.h:215 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: atomic64_set
> include/asm-generic/atomic-instrumented.h:40 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: atomic_long_set
> include/asm-generic/atomic-long.h:57 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: set_work_data
> kernel/workqueue.c:617 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> process_one_work+0xaef/0x1b50 kernel/workqueue.c:2116
>  #1:         (ptrval) ((work_completion)(&(&req->work)->work)){+.+.}, at:
> process_one_work+0xb46/0x1b50 kernel/workqueue.c:2120
>  #2:         (ptrval) (&id_priv->handler_mutex){+.+.}, at:
> addr_handler+0xa6/0x3d0 drivers/infiniband/core/cma.c:2796
>  #3:         (ptrval) (&file->mut){+.+.}, at: ucma_event_handler+0x10e/0xff0
> drivers/infiniband/core/ucma.c:350

I think this is probably a use-after-free race, eg when we do
ctx->file->mut we have raced with ucma_free_ctx() ..

Which probably means something along the way to free_ctx() did not
call rdma_addr_cancel?

Jason
