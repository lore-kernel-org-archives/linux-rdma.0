From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 01 Feb 2012 20:21:28 -0500 (EST)
Message-ID: <20120201.202128.703330634975191244.davem@davemloft.net>
References: <CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ@mail.gmail.com>
	<20120201.171703.1299449838314569881.davem@davemloft.net>
	<CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 1 Feb 2012 15:28:18 -0800

> I'm happy to do it but I'm still not quite sure I understand what the
> end state is.  Is it just a matter of peeking into the skb contents
> to get at the daddr, looking up the neigh based on that and then
> continuing to handle neighs as we do now?

Right, you also will now have a reference to the neigh so you must
release it.

> Does that also work for ARP packets?

ARP packets have no dst_entry, so would need to be handled specially
right now anyways.

> Are there any examples in your tree I can crib off of?

grep for dst_neigh_lookup() in the net-next tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
