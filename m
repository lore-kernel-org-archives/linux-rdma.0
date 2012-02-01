From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 01 Feb 2012 17:02:10 -0500 (EST)
Message-ID: <20120201.170210.981802234698152048.davem@davemloft.net>
References: <20120201.161333.2203265702893105548.davem@davemloft.net>
	<CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
	<20120201.165041.1820098802489365638.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.165041.1820098802489365638.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Date: Wed, 01 Feb 2012 16:50:41 -0500 (EST)

> From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Wed, 1 Feb 2012 13:42:30 -0800
> 
>> OK.  So do you have any thoughts about what the generic key available
>> at transmit time (as you alluded to in your first message) might be?
>> 
>> As far as I can figure things, it has to be something roughly
>> equivalent to the neighbour, since it has to have the same type of
>> information as what ARP/ND tells us.
>> 
>> I guess I don't understand the on-demand lookup of the neigh.
> 
> It's "inaddr_any(rt->rt_gateway) ? ip_hdr(skb)->daddr : rt->rt_gateway",
> ie. the nexthop.  That's the value we need to do proper on-demand
> neigh lookups, it's the "daddr" argument to dst_lookup_neigh().

Actually, the argument is "&ip_hdr(skb)->daddr".

So the crux of the matter is making sure we can get at the correct
destination address in the packet header.  Also we might have to
conditionalize the code based upon protocol type, does ipoib handle
ipv6?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
