From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/core: use RCU for uverbs id lookup
Date: Tue, 24 Nov 2015 21:22:57 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259C1121@fmsmsx120.amr.corp.intel.com>
References: <20151102171325.7601.96477.stgit@phlsvslse11.ph.intel.com>
 <20151102174056.GA13982@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102174056.GA13982-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Debbage, Mark" <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Nov 02, 2015 at 12:13:25PM -0500, Mike Marciniszyn wrote:
> > The current implementation gets a spin_lock, and at any scale with qib
> > and hfi1 post send, the lock contention grows exponentially with the
> > number of QPs.
> >
> > idr_find() is RCU compatibile, so read doesn't need the lock.
> >
> > Change to use rcu_read_lock() and rcu_read_unlock() in
> > __idr_get_uobj().
> >
> > kfree_rcu() is used to insure a grace period between the idr removal
> > and actual free.
> 
> Looks OK to me.
> 
> Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Doug, 

What is the status of this patch?

I don't see it any of the public repos.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
