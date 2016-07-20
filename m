From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/ipoib: Report SG feature regardless of HW UD CSUM capability
Date: Wed, 20 Jul 2016 01:30:06 -0700
Message-ID: <1469003406-1540-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Decouple SG support from HW ability to do UD checksum.
This coupling is for historical reasons and removed with 'commit
ec5f06156423 ("net: Kill link between CSUM and SG features.")'

During driver load it is assumed that device does not supports SG. The
final decision is taken after creating UD QP based on device capability.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v0 -> v1:
	* Fix patch title
	* Move settings to ipoib_setup instead of ipoib_set_dev_feature
v1 -> v2:
	* Move settings to ipoib_transport_dev_init
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |    3 +--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |   10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5f58c41..74bcaa0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1967,8 +1967,7 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 	priv->hca_caps = hca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features = NETIF_F_SG |
-			NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		priv->dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 
 		if (priv->hca_caps & IB_DEVICE_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 1e7cbba..c55ecb2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -135,7 +135,8 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		.cap = {
 			.max_send_wr  = ipoib_sendq_size,
 			.max_recv_wr  = ipoib_recvq_size,
-			.max_send_sge = 1,
+			.max_send_sge = min_t(u32, priv->ca->attrs.max_sge,
+					      MAX_SKB_FRAGS + 1),
 			.max_recv_sge = IPOIB_UD_RX_SG
 		},
 		.sq_sig_type = IB_SIGNAL_ALL_WR,
@@ -205,10 +206,6 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	if (priv->hca_caps & IB_DEVICE_MANAGED_FLOW_STEERING)
 		init_attr.create_flags |= IB_QP_CREATE_NETIF_QP;
 
-	if (dev->features & NETIF_F_SG)
-		init_attr.cap.max_send_sge =
-			min_t(u32, priv->ca->attrs.max_sge, MAX_SKB_FRAGS + 1);
-
 	priv->qp = ib_create_qp(priv->pd, &init_attr);
 	if (IS_ERR(priv->qp)) {
 		printk(KERN_WARNING "%s: failed to create QP\n", ca->name);
@@ -234,6 +231,9 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->rx_wr.next = NULL;
 	priv->rx_wr.sg_list = priv->rx_sge;
 
+	if (init_attr.cap.max_send_sge > 1)
+		dev->features |= NETIF_F_SG;
+
 	priv->max_send_sge = init_attr.cap.max_send_sge;
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
