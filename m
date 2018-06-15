From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 20:57:39 -0600
Message-ID: <20180615025739.GB29138@mellanox.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com>
 <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com>
 <20180614142448.GC24762@mellanox.com>
 <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com>
 <20180614172441.GE24762@mellanox.com>
 <CAM_iQpXFmqcCQWkyGPmev5LrPpDoEc=wpXQVDWJx2UQWPhwb2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpXFmqcCQWkyGPmev5LrPpDoEc=wpXQVDWJx2UQWPhwb2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2018 at 04:14:13PM -0700, Cong Wang wrote:
> On Thu, Jun 14, 2018 at 10:24 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> > On Thu, Jun 14, 2018 at 10:03:09AM -0700, Cong Wang wrote:
> >> On Thu, Jun 14, 2018 at 7:24 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> >> >
> >> > This was my brief reaction too, this code path almost certainly has a
> >> > use-after-free, and we should fix the concurrency between the two
> >> > places in some correct way..
> >>
> >> First of all, why use-after-free could trigger an imbalance unlock?
> >> IOW, why do we have to solve use-after-free to fix this imbalance
> >> unlock?
> >
> > The issue syzkaller hit is that accessing ctx->file does not seem
> > locked in any way and can race with other manipulations of ctx->file.
> >
> > So.. for this patch to be correct we need to understand how this
> > statement:
> >
> >    f = ctx->file
> >
> > Avoids f becoming a dangling pointer - and without locking, my
> 
> It doesn't, because this is not the point, this is not the cause
> of the unlock imbalance either. syzbot didn't report use-after-free
> or a kernel segfault here.

No, it *is* the point - you've proposed a solution, one of many, and
we need to see an actual sensible design for how the locking around
ctx->file should work correctly.

We need solutions that solve the underlying problem, not just paper
over the symptoms.

Stated another way, for a syzkaller report like this there are a few
really obvious fixes.

1) Capture the lock pointer on the stack:
  f = ctx->file
  mutex_lock(&f->mut);
  mutex_unlock(&f->mut);

2) Prevent ctx->file from changing, eg add more locking:
  mutex_lock(&mut);
  mutex_lock(&ctx->file->mut);
  mutex_unlock(&ctx->file->mut));
  mutex_unlock(&mut);

3) Prevent ctx->file from being changing/freed by flushing the
   WQ at the right times:

   rdma_addr_cancel(...);
   ctx->file = XYZ;

This patch proposed #1. An explanation is required why that is a
correct locking design for this code. It sure looks like it isn't.

Looking at this *just a bit*, I wonder why not do something like
this:

  mutex_lock(&mut);
  f = ctx->file;
  mutex_lock(&f->mutex);
  mutex_unlock(&mut);
 
? At least that *might* make sense. Though probably it deadlocks as it
looks like we call rdma_addr_cancel() while holding mut. Yuk.

But maybe that sequence could be done before launching the work..

> > I'm not sure that race exists, there should be something that flushes
> > the WQ on the path to close... (though I have another email that
> > perhaps that is broken, sigh)
> 
> This is not related to my patch, but to convince you, let me explain:
> 
> struct ucma_file is not refcnt'ed, I know you cancel the work in
> rdma_destroy_id(), but after ucma_migrate_id() the ctx has already
> been moved to the new file, for the old file, it won't cancel the
> ctx flying with workqueue. So, I think the following use-after-free
> could happen:
> 
> ucma_event_handler():
> cur_file = ctx->file; // old file
> 
> ucma_migrate_id():
> lock();
> list_move_tail(&ctx->list, &new_file->ctx_list);
> ctx->file = new_file;
> unlock();
> 
> ucma_close():
> // retrieve old file via filp->private_data
> // the loop won't cover the ctx moved to the new_file
> kfree(file);

Yep. That sure seems like the right analysis!

> This is _not_ the cause of the unlock imbalance, and is _not_ expected
> to solve by patch either.

What do you mean? Not calling rdma_addr_cancel() prior to freeing the
file is *exactly* the cause of the lock imbalance.

The design of this code *assumes* that rdma_addr_cancel() will be
called before altering/freeing/etc any of the state it is working on,
migration makes a state change that violates that invariant.

Jason
