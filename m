From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/core: Add flow-steering support for IPoIB UD traffic
Date: Thu,  7 Nov 2013 15:25:12 +0200
Message-ID: <1383830717-17312-2-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When creating the IPoIB UD QP, provide hint to the low level driver
that the QP should support flow-steering. This means that privileged
user space applications could steer TCP/IP IPoIB traffic from the
network stack, in a similar manner done with Ethernet RAW_PACKET QPs.

The hint is provided through new QP creation flag called NETIF_QP.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    3 +++
 include/rdma/ib_verbs.h                    |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 049a997..c56d5d4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -192,6 +192,9 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	if (priv->hca_caps & IB_DEVICE_BLOCK_MULTICAST_LOOPBACK)
 		init_attr.create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
 
+	if (priv->hca_caps & IB_DEVICE_MANAGED_FLOW_STEERING)
+		init_attr.create_flags |= IB_QP_CREATE_NETIF_QP;
+
 	if (dev->features & NETIF_F_SG)
 		init_attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e393171..bb81c37 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -631,6 +631,7 @@ enum ib_qp_type {
 enum ib_qp_create_flags {
 	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	IB_QP_CREATE_NETIF_QP			= 1 << 5,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
