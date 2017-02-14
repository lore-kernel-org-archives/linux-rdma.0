From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cma: Family of destination address should be equal to family of source address
Date: Tue, 14 Feb 2017 07:24:08 +0200
Message-ID: <20170214052408.16361-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The destination address in a listening rdma_id does not have an address
family. Since address family in both sides of a connection must be the
same in rdma_bind_addr() we set the address family of the destination to
the address family of the source.

This patch serves the logic in cma_port_is_unique() which requires to
know if destination address that is associated with a rdma_id is any address
(cma_zero_addr() and cma_loopback_addr()).

This can happen when port reuse is checked for a port number
that is being listened to.

Fixes: 19b752a19dce ("IB/cma: Allow port reuse for rdma_id")
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3e70a9c5d79d..8a7e2b041a94 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3205,6 +3205,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
+	struct sockaddr  *daddr;

 	if (addr->sa_family != AF_INET && addr->sa_family != AF_INET6 &&
 	    addr->sa_family != AF_IB)
@@ -3244,6 +3245,9 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err2;

+	daddr = cma_dst_addr(id_priv);
+	daddr->sa_family = addr->sa_family;
+
 	return 0;
 err2:
 	if (id_priv->cma_dev)
--
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
