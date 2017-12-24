From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 8/8] RDMA/cma: Mark end of CMA ID messages
Date: Sun, 24 Dec 2017 15:43:28 +0200
Message-ID: <20171224134328.17398-9-leon@kernel.org>
References: <20171224134328.17398-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134328.17398-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The commit 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and
put_attr") removes nlmsg_len calculation in ibnl_put_attr causing
netlink messages and caused to miss source and destination addresses.

Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e5c9f42a7e4b..209373159dd7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4439,6 +4439,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 			id_stats->qp_type	= id->qp_type;

 			i_id++;
+			nlmsg_end(skb, nlh);
 		}

 		cb->args[1] = 0;
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
