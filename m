From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 01 Feb 2012 17:17:03 -0500 (EST)
Message-ID: <20120201.171703.1299449838314569881.davem@davemloft.net>
References: <20120201.165041.1820098802489365638.davem@davemloft.net>
	<20120201.170210.981802234698152048.davem@davemloft.net>
	<CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=46rom: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 1 Feb 2012 14:06:48 -0800

> On Wed, Feb 1, 2012 at 2:02 PM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wr=
ote:
>> So the crux of the matter is making sure we can get at the correct
>> destination address in the packet header. =A0Also we might have to
>> conditionalize the code based upon protocol type, does ipoib handle
>> ipv6?
>=20
> Yes, it does both v4 and v6.

So it should be just a matter of checking skb->protocol or similar,
plucking out the daddr from the ipv4/ipv6 header, and then adding
the appropriate neigh release calls.

I have absolutely no way to test this stuff, so could you please
work on the dst_lookup_neigh() conversion of ipoib?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
