From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_cm UD sendto without connect
Date: Thu, 3 Nov 2011 15:44:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8CD1B@ORSMSX101.amr.corp.intel.com>
References: <CAND8VyAYHTg3T2rMmPPMMjXbkN4dZJSDukXhQZFJnVYT2fW+1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAND8VyAYHTg3T2rMmPPMMjXbkN4dZJSDukXhQZFJnVYT2fW+1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is it possible to send/recv datagrams with no previous connection
> similar to UDP sendto/recvfrom?  UD examples I've seen are connection
> oriented and listen/connect/accept, establishing a connection prior to
> conversing.

To send a datagram, you need the QP number, qkey, and addressing information of the remote side.  The UD examples that use listen/connect are still connectionless, but require the use of those calls mainly to resolve the remote QP number.

We may be able to add a sendto operation to the rdma_cm, but it would need to resolve the QPN and ibv_ah under the API for the first send to each destination.

> It appears that in order to do what I want, I need an ibv_ah to put in
> the send wr.  But how do I create one of these from an IP address/port
> without doing an rdma_connect and waiting for
> RDMA_CM_EVENT_ESTABLISHED?

You still need to convert the IP address into an RDMA address (i.e. LID) and discover the QPN. 
 
> From the receiving side, it looks like I can construct an ah from the
> wc.  Is that a low-cost operation?

This probably depends on the implementation, but in general I wouldn't consider it a fast path operation.  Someone from Mellanox should know the real cost.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
