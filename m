From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Fri, 15 Jun 2018 13:08:33 -0600
Message-ID: <20180615190833.GC5877@mellanox.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com>
 <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com>
 <20180614142448.GC24762@mellanox.com>
 <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com>
 <20180614172441.GE24762@mellanox.com>
 <CAM_iQpXFmqcCQWkyGPmev5LrPpDoEc=wpXQVDWJx2UQWPhwb2g@mail.gmail.com>
 <20180615025739.GB29138@mellanox.com>
 <CAM_iQpUYWzxMDgJJazLwvD1Tx_7i4PRC0r+2JKar3Vr4bW-Q+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpUYWzxMDgJJazLwvD1Tx_7i4PRC0r+2JKar3Vr4bW-Q+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 15, 2018 at 10:57:49AM -0700, Cong Wang wrote:

> > No, it *is* the point - you've proposed a solution, one of many, and
> > we need to see an actual sensible design for how the locking around
> > ctx->file should work correctly.
> 
> I proposed to a solution for imbalance unlock, you ask a design
> for use-after-free, which is *irrelevant*. So why it is the point?

The point is, I don't care about the imbalance report.

I care about the actual bug, which you have identified as
ucma_migrate_id() running concurrently with ucma_event_handler(). That
seems like a great analysis, BTW.

Stop that from happening and the lock imbalance warning will naturally go
away. So will the use after free.

I gave you some general ideas on how to do that, obviously they are
not easy to do eg somehow solving the dealock with mut would be
tricky. But maybe there is still some kind of simple solution..

Another option might be to just fail ucma_migrate_id() when
ucma_event_handler() is outstanding.. That *might* be OK.. We've
talked about doing things like this for other ucma syzkaller
bugs. Also a bit complicated.

Anyhow I'm NAK'ing this patch, since it just doesn't move things
forward, and removes a warning that is pointing at a bunch of
different bugs.

Jason
