From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 18 Apr 2012 02:15:58 -0400 (EDT)
Message-ID: <20120418.021558.255251358104374047.davem@davemloft.net>
References: <4F8D23A0.7000109@mellanox.com>
	<20120417.230418.1898458010494189728.davem@davemloft.net>
	<4F8E57F8.9050703@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F8E57F8.9050703-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 18 Apr 2012 08:58:16 +0300

> okay, so please let me phrase that differently, would it be correct to
> say that if we stick to the 1st approach of still somehow associating
> the ipoib_neigh with the neighbour - no matter through what means we
> do that - RCU-ing is must here. Specifically, the neighbour->priv
> mechanism wouldn't get us a way from adding that protection? or maybe
> it could make our life easier if we turn to use it?

I would need to have to go back to the original thread and reread and
reabsorb the full analysis I did back then to answer this, and I
really don't have time to do that right now.

You're going to have to figure out how to fix this race properly on
your own or with someone else's help.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
