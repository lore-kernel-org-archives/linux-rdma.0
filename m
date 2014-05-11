From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 for-next 2/3] IB: Add a QP creation flag to allow specifying a NOIO allocation directive
Date: Sun, 11 May 2014 15:15:11 +0300
Message-ID: <1399810512-30774-3-git-send-email-ogerlitz@mellanox.com>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399810512-30774-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This addresses a problem whereby NFS client writes would enter
uninterruptible sleep forever. The issue happened when using NFS
over IPoIB connected mode.

The problem encountered was described as follows: it's not memory
reclamation that is the problem as such. There is an indirect dependency
between network filesystems writing back pages and ipoib_cm_tx_init()
due to how a kworker is used. Page reclaim cannot make forward progress
until ipoib_cm_tx_init() succeeds and it is stuck in page reclaim itself
waiting for network transmission. Ordinarily this situation may be
avoided by having the caller use GFP_NOFS but ipoib_cm_tx_init()
does not have that information.

To address this, take a more general approach and generalize the
solution such that when the new QP creation flag is provided, the
HW driver should use a GFP_NOIO for the memory allocations related
to the new QP.

Use the new flag in the ipoib connected mode path, and if the driver
doesn't support that, re-issue the QP creation w.o this specification.

Signed-off-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   19 ++++++++++++++++---
 include/rdma/ib_verbs.h                 |    1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 1377f85..e2ce0e6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1030,12 +1030,23 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 		.cap.max_send_sge	= 1,
 		.sq_sig_type		= IB_SIGNAL_ALL_WR,
 		.qp_type		= IB_QPT_RC,
-		.qp_context		= tx
+		.qp_context		= tx,
+		.create_flags		= IB_QP_CREATE_USE_GFP_NOIO
 	};
 
-	return ib_create_qp(priv->pd, &attr);
+	struct ib_qp *tx_qp;
+
+	tx_qp = ib_create_qp(priv->pd, &attr);
+	if (PTR_ERR(tx_qp) == -EINVAL) {
+		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
+			   priv->ca->name);
+		attr.create_flags &= ~IB_QP_CREATE_USE_GFP_NOIO;
+		tx_qp = ib_create_qp(priv->pd, &attr);
+	}
+	return tx_qp;
 }
 
+
 static int ipoib_cm_send_req(struct net_device *dev,
 			     struct ib_cm_id *id, struct ib_qp *qp,
 			     u32 qpn,
@@ -1104,12 +1115,14 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	int ret;
 
-	p->tx_ring = vzalloc(ipoib_sendq_size * sizeof *p->tx_ring);
+	p->tx_ring = __vmalloc(ipoib_sendq_size * sizeof *p->tx_ring,
+			       GFP_NOIO, PAGE_KERNEL);
 	if (!p->tx_ring) {
 		ipoib_warn(priv, "failed to allocate tx ring\n");
 		ret = -ENOMEM;
 		goto err_tx;
 	}
+	memset(p->tx_ring, 0, ipoib_sendq_size * sizeof *p->tx_ring);
 
 	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
 	if (IS_ERR(p->qp)) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index acd8251..d75b02f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -783,6 +783,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
 	IB_QP_CREATE_NETIF_QP			= 1 << 5,
 	IB_QP_CREATE_SIGNATURE_EN		= 1 << 6,
+	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
