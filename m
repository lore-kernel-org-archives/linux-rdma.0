From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Tue, 17 Apr 2012 23:04:18 -0400 (EDT)
Message-ID: <20120417.230418.1898458010494189728.davem@davemloft.net>
References: <CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA@mail.gmail.com>
	<20120201.202128.703330634975191244.davem@davemloft.net>
	<4F8D23A0.7000109@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F8D23A0.7000109-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 17 Apr 2012 11:02:40 +0300

> Dave, as for the conversion to dst_neigh_lookup, looking on net-next,
> I see about 30 hits for dst_get_neighbour_noref vs 13 hits for
> dst_neigh_lookup, so I wasn't sure about your comment re the ipoib
> conversion being what actually remains to make that change happen, can
> you elaborate here a little further?

It is the only major instance that I don't personally have plans for
a dst_neigh_lookup() conversion.

I can't do some of those transformations to dst_neigh_lookup() in
net/ipv4 and net/ipv6 until the others are out of the way.

> Also, if ipoib moves to use that api, you made a comment that it will
> have a reference on the neighbour which will need to be released. I
> took a look on the net/atm use case which should to some extent be
> similar to ipoib, I see that neigh_release is called for neighbours
> retrieved by that API, okay.

Right.

> Just for the sake of example, does the atm code free from the races
> you mention re ipoib? I see that it does stick its own object on the
> neighbour through the priv pointer but wasn't sure if it helps in that
> respect without further RCU-ing things.

I haven't audited ATM for races of any kind, and I have no plans to
do so, sorry.

Please, I did fully audit and analyze the IPoIB case, so please use
one of the approaches suggsted.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
