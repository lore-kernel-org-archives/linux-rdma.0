From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 11:24:41 -0600
Message-ID: <20180614172441.GE24762@mellanox.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com>
 <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com>
 <20180614142448.GC24762@mellanox.com>
 <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2018 at 10:03:09AM -0700, Cong Wang wrote:
> On Thu, Jun 14, 2018 at 7:24 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > This was my brief reaction too, this code path almost certainly has a
> > use-after-free, and we should fix the concurrency between the two
> > places in some correct way..
> 
> First of all, why use-after-free could trigger an imbalance unlock?
> IOW, why do we have to solve use-after-free to fix this imbalance
> unlock?

The issue syzkaller hit is that accessing ctx->file does not seem
locked in any way and can race with other manipulations of ctx->file.

So.. for this patch to be correct we need to understand how this
statement:

   f = ctx->file

Avoids f becoming a dangling pointer - and without locking, my
suspicion is that it doesn't - because missing locking around
ctx->file is probably the actual bug syzkaller found.

If this is not the case, then add a comment explaining how f's
lifetime is OK.

Otherwise, we need some kind of locking and guessing we need to hold a
kref for f?

> Third of all, the use-after-free I can see (race with ->close) exists
> before my patch, this patch doesn't make it better or worse, nor
> I have any intend to fix it.

I'm not sure that race exists, there should be something that flushes
the WQ on the path to close... (though I have another email that
perhaps that is broken, sigh)

Jason
