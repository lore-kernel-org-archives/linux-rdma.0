From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] librdmacm-1.0.16
Date: Mon, 13 Aug 2012 15:42:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A7D8F3@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A61E63@ORSMSX101.amr.corp.intel.com>
	<CAOzFzEgkqKYcP99sGC+SP-pgS2abt1wA9dtJ7x9O99kzO31xtw@mail.gmail.com>
 <CAOzFzEhwt-XFowYf4J=cphJ_hxQBmtf0GOZVdS7az2ReH4cfdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhwt-XFowYf4J=cphJ_hxQBmtf0GOZVdS7az2ReH4cfdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Are there any plans to include SOCK_DGRAM support?
> >
> > I could see that being potentionally interesting along with mapping
> > broadcast/multicast to IB physical layer multicast.
> 
> I took a look at linux/net/rds to see if something similar could be
> done in terms of transparently supporting existing UDP applications
> but some of the semantics I think could get difficult.
> Specifically RDS won't send to congested hosts, which is not a UDPism at all.
> Also the queuing etc doesn't map very well to UDP, this would have to
> be massaged into working nicely.
> 
> Has anyone done anything similar to rsockets for exposing IB UD
> (transparently) to apps as UDP?

I would like to support SOCK_DGRAM/UDP, and I've had some discussions on what may be the best way to support it.  If I had to predict, at some point I expect it to be supported.

The main difficulty lies in address resolution.  A LOT of non-trivial protocol ends up needing to be hidden under a simple sendto() call.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
