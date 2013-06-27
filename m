From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 for-next 1/4] IB/core: Add receive Flow Steering
 support
Date: Thu, 27 Jun 2013 20:55:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD37415@ORSMSX109.amr.corp.intel.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
	<1372251464-13394-2-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD36FF3@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The TCP/IP filters are broken into separate filters based in L4/L3.  It would
> seem to
> > make sense if the IB filters were similarly divided into L2/L3/L4 filters.
> IB and IPv6
> > could probably share the same filter definition.
> 
> IPv6 filters wasn't defined through this submission, but as I wrote,
> the scheme provided allows for adding more filters and flow specs.

My point was that the IPv6 filter should be defined and used here.  The following basic filters were defined:

ethernet -	src/dst mac ...
ip -		src/dst ip
tcp/udp -	src/dst port

These are at least somewhat intuitive to me.  The IB filter is

ib -		(src/dst?) qpn, dgid

This is equivalent to creating a filter that's:

tcpip - 	port, dst ip

IMO, it would be better to define IB filters using the same structure that you used for tcp/ip/ethernet.  For example

ibqp - 	src/dst qpn (pkey?)
ipv6 -	src/dst ipv6/gids (flowlabel?)
iblink - 	src/dst lids, (sl?)

If the hardware can only support matching on the qpn and dgid, then it can simply fail any requests which specify a non-zero mask on the unsupported components.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
