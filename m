From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Mon, 10 May 2010 10:36:17 -0700
Message-ID: <1C56604F650B44A8B00B3CA55D00B95D@amr.corp.intel.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100510154656.22415.47740.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>For iWARP rdma_cm ids, the "route" information is the L2 src and
>next hop addresses.
>
>Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>---
>
> drivers/infiniband/core/ucma.c |   13 +++++++++++++
> 1 files changed, 13 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
>index ac7edc2..0498383 100644
>--- a/drivers/infiniband/core/ucma.c
>+++ b/drivers/infiniband/core/ucma.c
>@@ -583,6 +583,16 @@ static void ucma_copy_ib_route(struct
>rdma_ucm_query_route_resp *resp,
> 	}
> }
>
>+static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
>+			       struct rdma_route *route)
>+{
>+	struct rdma_dev_addr *dev_addr;
>+
>+	dev_addr = &route->addr.dev_addr;
>+	rdma_addr_get_dgid(dev_addr, (union ib_gid *) &resp->ib_route[0].dgid);
>+	rdma_addr_get_sgid(dev_addr, (union ib_gid *) &resp->ib_route[0].sgid);

This looks good for the current code.

For 2.6.35/36, I've submitted changes to the query operation to support AF_IB,
essentially breaking the query_route call into query_addr, query_path, and
query_gid.  I'm guessing that this functionality should be part of the query_gid
call.  I'll adjust those patches, but if you get a chance to review the query
changes, I'd appreciate it.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
