From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] IB/CMA: fail qkey setting for RDMA_PS_IPOIB and IB_LINK_LAYER_ETHERNET
Date: Thu, 7 Jul 2011 16:37:37 +0300
Message-ID: <1310045857-26040-1-git-send-email-monis@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In general, when link layer is ETHERNET it is wrong to use IPoIB port space since
no IPoIB interface is available. Specifically, setting qkey when port space is
RDMA_PS_IPOIB, requires SA query which is impossible when link layer is IB_LINK_LAYER_ETHERNET.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..9bf83d5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -314,6 +314,9 @@ static int cma_set_qkey(struct rdma_id_private *id_priv)
 		id_priv->qkey = RDMA_UDP_QKEY;
 		break;
 	case RDMA_PS_IPOIB:
+		if (rdma_port_get_link_layer(id_priv->cma_dev->device, id_priv->id.port_num) ==
+			IB_LINK_LAYER_ETHERNET)
+			return -EINVAL;
 		ib_addr_get_mgid(&id_priv->id.route.addr.dev_addr, &rec.mgid);
 		ret = ib_sa_get_mcmember_rec(id_priv->id.device,
 					     id_priv->id.port_num, &rec.mgid,
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
