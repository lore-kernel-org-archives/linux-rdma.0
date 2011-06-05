From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdma_cm and PSNs
Date: Sun, 5 Jun 2011 13:22:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373012DA1@ORSMSX101.amr.corp.intel.com>
References: <201106041737.16482.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106041737.16482.kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> While doing this I have noticed that in a simple RDMA application, librdma
> does not seem to configure the PSNs between the two nodes to match each other;
> not through calls to ibv_modify_qp anyhow. The arguments given to
> ibv_modify_qp by librdma_cm seem to be (for example):
> 
> Node 1:
> RQ_PSN is 464684127
> SQ_PSN is 2204625
> 
> Node 2:
> RQ_PSN is 1327604689
> SQ_PSN is 11699295

Are you capturing the ibv_modify_qp calls for the correct transitions?  You can check the qp_attr_mask to see when the PSN values are being set.  RQ_PSN is set on the RTR transition call.  SQ_PSN is set on the RTS transition.

> If I use ibv_query_qp() to query the PSNs they will prove to match (SQ -> RQ
> on the opposite nodes), as they should. If not through ibv_modify_qp, how is
> librdma_cm configuring the PSNs?

The PSNs are set by the kernel using random numbers.  For IB, the underlying CM exchanges the PSNs as part of the connection process.  The librdmacm calls into the kernel (rdma_init_qp_attr() or something like that) to get the attributes that it passes into ibv_modify_qp.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
