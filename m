From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Independent server management of Multicasting connections
Date: Mon, 21 Nov 2011 17:05:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121071551.14306gf6ogr9z8yf-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  From what I understand, and I may not understand correctly, to
> perform IB Multicast, betweeen two nodes, I need to swap addresses and
> remote keys for the two nodes.  In the examples I have seen this has

You only need to do this for unicast UD.  Multicast doesn't require exchanging addresses and qkeys, but see below.

> been done via RDMA CM directly between the two nodes.  Does it matter
> how this information is exchanged?  In my application I will have

For multicast, you need to 1. have the SA create the multicast group and 2. join the group.  To create the group, you need to either have the SA automatically create the group (if this is possible) or create it dynamically.  To create the group dynamically from user space, you should use the rdma_cm or ib_umad interfaces.  The rdma_cm is easier.

To join the group, you need to let the SA know that the node should receive multicast traffic, so that it can program the switches.  This is done through the rdma_cm (easy way) or using ib_umad (hard way that gets harder if you want to support multiple applications joining the same group from the same system).

> several nodes multicasting to several other nodes and I want to manage
> the connections from a independent application.  What I would like to
> do is write this application, server, etc. so that each node would
> request connection with another node and then be provied with the
> information it needs to multicast.  For example... Node 1 would
> request a connection (from the server app) Node 2 and Node 2 would
> request a connection (again, from the server app) to Node 1.  The
> Server app would provide Node 2's "credentials" to Node 1 and likewise
> to Node 2.  Is this even possible?

The SA basically does the work that you're describing for your server app.  Node 1 can ask the SA to create a multicast group.  Node 2 can ask to join that group.  Somehow node 2 needs to know what group node 1 created.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
