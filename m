From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Multiple multicast groups
Date: Tue, 13 Dec 2011 22:21:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325660A13@ORSMSX102.amr.corp.intel.com>
References: <20111213135346.132670b3va8kdk62@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213135346.132670b3va8kdk62-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I am trying to modify one of the multicast examples (mckey.c) so that
> I have multiple multicast groups each one handling a different type of
> data.  I am somewhat confused as to how I would do this.  can I keep 1
> RDMA CM channel between each server/client pair?  Would I need to keep
> a qp, send/recv queue and completion queue for each multicast group?

You can use a single QP, rdma_cm_id, completion channel, and CQ for all multicast groups.  Simply call rdma_join_multicast() for every group that you want to join.   E.g.

rdma_create_id()
rdma_bind_addr()
rdma_create_qp()
rdma_join_multicast()
rdma_join_multicast()
rdma_join_multicast()
rdma_join_multicast()
...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
