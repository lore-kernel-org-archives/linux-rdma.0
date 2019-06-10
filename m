From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: WARNING: bad unlock balance in ucma_event_handler
Date: Mon, 10 Jun 2019 16:47:32 -0300
Message-ID: <20190610194732.GH18468@ziepe.ca>
References: <000000000000af6530056e863794@google.com>
 <20180613170543.GB30019@ziepe.ca>
 <20190610184853.GG63833@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610184853.GG63833@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: syzbot <syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com>, dasaratharaman.chandramouli@intel.com, dledford@redhat.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, roland@purestorage.com, sean.hefty@intel.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 10, 2019 at 11:48:54AM -0700, Eric Biggers wrote:
> On Wed, Jun 13, 2018 at 11:05:43AM -0600, Jason Gunthorpe wrote:
> > On Wed, Jun 13, 2018 at 06:47:02AM -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following crash on:
> > > 
> > > HEAD commit:    73fcb1a370c7 Merge branch 'akpm' (patches from Andrew)
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16d70827800000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=e5579222b6a3edd96522
> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=176daf97800000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e7bd57800000
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com
> > > 
> > > 
> > > =====================================
> > > WARNING: bad unlock balance detected!
> > > 4.17.0-rc5+ #58 Not tainted
> > > kworker/u4:0/6 is trying to release lock (&file->mut) at:
> > > [<ffffffff8593ecc0>] ucma_event_handler+0x780/0xff0
> > > drivers/infiniband/core/ucma.c:390
> > > but there are no more locks to release!
> > > 
> > > other info that might help us debug this:
> > > 4 locks held by kworker/u4:0/6:
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> > > __write_once_size include/linux/compiler.h:215 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> > > arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: atomic64_set
> > > include/asm-generic/atomic-instrumented.h:40 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: atomic_long_set
> > > include/asm-generic/atomic-long.h:57 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at: set_work_data
> > > kernel/workqueue.c:617 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> > > set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
> > >  #0:         (ptrval) ((wq_completion)"ib_addr"){+.+.}, at:
> > > process_one_work+0xaef/0x1b50 kernel/workqueue.c:2116
> > >  #1:         (ptrval) ((work_completion)(&(&req->work)->work)){+.+.}, at:
> > > process_one_work+0xb46/0x1b50 kernel/workqueue.c:2120
> > >  #2:         (ptrval) (&id_priv->handler_mutex){+.+.}, at:
> > > addr_handler+0xa6/0x3d0 drivers/infiniband/core/cma.c:2796
> > >  #3:         (ptrval) (&file->mut){+.+.}, at: ucma_event_handler+0x10e/0xff0
> > > drivers/infiniband/core/ucma.c:350
> > 
> > I think this is probably a use-after-free race, eg when we do
> > ctx->file->mut we have raced with ucma_free_ctx() ..
> > 
> > Which probably means something along the way to free_ctx() did not
> > call rdma_addr_cancel?
> > 
> > Jason
> 
> This is still happening.  Just FYI, ignoring these reports doesn't make the bugs
> go away.  Here's a crash report from v5.2.0-rc4:

There are many unfixed syzkaller bugs in rdma_cm, so I'm not surprised
it is still happening..

Nobody has stepped forward to work on this code, and it is not a
simple mess to understand, let alone try to fix.

> =====================================
> WARNING: bad unlock balance detected!
> 5.2.0-rc4 #44 Not tainted
> kworker/u4:2/61 is trying to release lock (&file->mut) at:
> [<ffffffff851a3f81>] ucma_event_handler+0x711/0xef0 drivers/infiniband/core/ucma.c:394
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 4 locks held by kworker/u4:2/61:
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: __write_once_size include/linux/compiler.h:221 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: set_work_data kernel/workqueue.c:620 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:647 [inline]
>  #0: 000000005ff5546b ((wq_completion)ib_addr){+.+.}, at: process_one_work+0x87e/0x1790 kernel/workqueue.c:2240
>  #1: 00000000d75dabcd ((work_completion)(&(&req->work)->work)){+.+.}, at: process_one_work+0x8b4/0x1790 kernel/workqueue.c:2244
>  #2: 0000000058b7aa49 (&id_priv->handler_mutex){+.+.}, at: addr_handler+0xaf/0x3d0 drivers/infiniband/core/cma.c:3031
>  #3: 00000000e5042b0a (&file->mut){+.+.}, at: ucma_event_handler+0xb3/0xef0 drivers/infiniband/core/ucma.c:354

Well, it is holding the (logical) lock it is releasing, so this
probably menas ctx->file changed value while this event handler is
running. :\

A quick look suggests ucma_migrate_id does that..

.. and we can quickly see the bug, we try to obtain a lock:

        mutex_lock(&ctx->file->mut);

while another thread is changing that pointer under the lock we are
trying to get:

        ctx->file = new_file;

So probably mutex_lock went to sleep, holding &ctx->file->mut in a
register, then the thing in the lock changed ctx->file, finally the
unlock reloaded ctx->file and got the new unlocked value, and crash.

Which just an insane design in the first place.

That is as far as I can get, trying to figure out how to rework
ctx->file to be properly ref counted, accessed and locked, is a major
task.. I don't even know right now what migrate_id is supposed to be
for :(

Jason
