From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH v2] IB/CMA: Invalidate connections in port space IPoIB over Ethernet link layer
Date: Mon, 11 Jul 2011 20:29:29 +0300
Message-ID: <1310405369-24822-1-git-send-email-monis@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch fixes a kernel crash in cma_set_qkey().
When link layer is ETHERNET it is wrong to use IPoIB port space since no IPoIB
interface is available. Specifically, setting qkey when port space is
RDMA_PS_IPOIB, requires mgid calculation and SA query which is illegal over Ethernet.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..2d60130 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -359,6 +359,10 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 
+	if (dev_ll == IB_LINK_LAYER_ETHERNET &&
+		id_priv->id.ps == RDMA_PS_IPOIB)
+		return -EINVAL;
+
 	mutex_lock(&lock);
 	iboe_addr_get_sgid(dev_addr, &iboe_gid);
 	memcpy(&gid, dev_addr->src_dev_addr +
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
