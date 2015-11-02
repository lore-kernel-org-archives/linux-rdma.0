From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: use RCU for uverbs id lookup
Date: Mon, 2 Nov 2015 10:40:56 -0700
Message-ID: <20151102174056.GA13982@obsidianresearch.com>
References: <20151102171325.7601.96477.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102171325.7601.96477.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 12:13:25PM -0500, Mike Marciniszyn wrote:
> The current implementation gets a spin_lock, and at any scale with
> qib and hfi1 post send, the lock contention grows exponentially
> with the number of QPs.
> 
> idr_find() is RCU compatibile, so read doesn't need the lock.
> 
> Change to use rcu_read_lock() and rcu_read_unlock() in
> __idr_get_uobj().
> 
> kfree_rcu() is used to insure a grace period between the
> idr removal and actual free.

Looks OK to me.

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
