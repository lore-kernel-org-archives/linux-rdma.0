From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Infiniband stack allows references to freed memory
Date: Wed, 01 Feb 2012 15:22:13 -0500 (EST)
Message-ID: <20120201.152213.433850213028883896.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Any time an ipoib_neigh is changed, a sequence like the following is made:

			spin_lock_irqsave(&priv->lock, flags);
			/*
			 * It's safe to call ipoib_put_ah() inside
			 * priv->lock here, because we know that
			 * path->ah will always hold one more reference,
			 * so ipoib_put_ah() will never do more than
			 * decrement the ref count.
			 */
			if (neigh->ah)
				ipoib_put_ah(neigh->ah);
			list_del(&neigh->list);
			ipoib_neigh_free(dev, neigh);
			spin_unlock_irqrestore(&priv->lock, flags);
			ipoib_path_lookup(skb, n, dev);

This doesn't work, because you're leaving a stale pointer to the freed up
ipoib_neigh in the special neigh->ha pointer cookie.  Yes, it even fails
with all the locking done to protect _changes_ to *ipoib_neigh(n), and
with the code in ipoib_neigh_free() that NULLs out the pointer.

The core issue is that read side calls to *to_ipoib_neigh(n) are not
being synchronized at all, they are performed without any locking.  So
whether we hold the lock or not when making changes to *ipoib_neigh(n)
you still can have threads see references to freed up ipoib_neigh
objects.

	cpu 1			cpu 2
	n = *ipoib_neigh()
				*ipoib_neigh() = NULL
				kfree(n)
	n->foo == OOPS

To be honest I wouldn't mind if ipoib managed it's neighbour entries
differently.  The way it works now is getting in the way of some
changes I want to make.  Namely that I want to make it so that
dst_entry objects do not have an attached neighbour, instead
neighbours are always looked up on demand.

Such on-demand neigh lookups require having access to the ipv4/ipv6
header destination address of the packet, and in these ipoib paths we
don't have a real obvious way to get at that without lots of kludgy
tests.

Sticking datastructure pointers into the hardware address of the neigh
is not pretty either :-)

Perhaps the ipoib code can have a private path database it manages
entirely itself, which holds all the necessary information and is
looked up by some generic key which is available easily at transmit
time and does not involve generic neighbour entries.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
