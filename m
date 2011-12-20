From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 25/25 v2] rdma/cm: Export AF_IB statistics
Date: Tue, 20 Dec 2011 21:44:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661BEC@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Report AF_IB source and destination addresses through
netlink interface.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   37 ++++++++++---------------------------
 1 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0fa6523..4deb152 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3631,33 +3631,16 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 			id_stats->bound_dev_if =
 				id->route.addr.dev_addr.bound_dev_if;
 
-			if (cma_family(id_priv) == AF_INET) {
-				if (ibnl_put_attr(skb, nlh,
-						  sizeof(struct sockaddr_in),
-						  cma_src_addr(id_priv),
-						  RDMA_NL_RDMA_CM_ATTR_SRC_ADDR)) {
-					goto out;
-				}
-				if (ibnl_put_attr(skb, nlh,
-						  sizeof(struct sockaddr_in),
-						  cma_dst_addr(id_priv),
-						  RDMA_NL_RDMA_CM_ATTR_DST_ADDR)) {
-					goto out;
-				}
-			} else if (cma_family(id_priv) == AF_INET6) {
-				if (ibnl_put_attr(skb, nlh,
-						  sizeof(struct sockaddr_in6),
-						  cma_src_addr(id_priv),
-						  RDMA_NL_RDMA_CM_ATTR_SRC_ADDR)) {
-					goto out;
-				}
-				if (ibnl_put_attr(skb, nlh,
-						  sizeof(struct sockaddr_in6),
-						  cma_dst_addr(id_priv),
-						  RDMA_NL_RDMA_CM_ATTR_DST_ADDR)) {
-					goto out;
-				}
-			}
+			if (ibnl_put_attr(skb, nlh,
+					  rdma_addr_size(cma_src_addr(id_priv)),
+					  cma_src_addr(id_priv),
+					  RDMA_NL_RDMA_CM_ATTR_SRC_ADDR))
+				goto out;
+			if (ibnl_put_attr(skb, nlh,
+					  rdma_addr_size(cma_src_addr(id_priv)),
+					  cma_dst_addr(id_priv),
+					  RDMA_NL_RDMA_CM_ATTR_DST_ADDR))
+				goto out;
 
 			id_stats->pid		= id_priv->owner;
 			id_stats->port_space	= id->ps;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
