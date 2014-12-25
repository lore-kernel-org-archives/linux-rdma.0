From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] RDMA/ocrdma: introducing a function to check RoCE-v2 support
Date: Thu, 25 Dec 2014 06:30:18 +0530
Message-ID: <c1040ad6-3daa-4cce-9368-16f10d636952@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

This patch replaces the checks for RoCE-v2 support with
an inline function to perform the same check for ease
of readability.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |    3 +--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    6 ++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 ++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 2c868d7..e3f9478 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -577,4 +577,9 @@ static inline u8 ocrdma_is_enabled_and_synced(u32 state)
 		(state & OCRDMA_STATE_FLAG_SYNC);
 }
 
+static inline bool ocrdma_is_rocev2_supported(struct ocrdma_dev *dev)
+{
+	return (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
+		dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6) ? true : false;
+}
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 5b326dd..2560903 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -200,8 +200,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		if (isvlan)
 			*ahid_addr |= (OCRDMA_AH_VLAN_VALID_MASK <<
 				       OCRDMA_AH_VLAN_VALID_SHIFT);
-		if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
-		    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+		if (ocrdma_is_rocev2_supported(dev))
 			*ahid_addr |= ((u32)ah->hdr_type &
 				       OCRDMA_AH_L3_TYPE_MASK) <<
 				       OCRDMA_AH_L3_TYPE_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 34e9c1d..1c3bc5c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -220,8 +220,7 @@ static enum ib_port_type ocrdma_get_port_type(struct ib_device *device,
 {
 	struct ocrdma_dev *dev = get_ocrdma_dev(device);
 
-	return (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
-		dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6) ?
+	return ocrdma_is_rocev2_supported(dev) ?
 		IB_PORT_TYPE_RoCEV2 : IB_PORT_TYPE_V1;
 }
 
@@ -339,8 +338,7 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 {
 	int tblsz = OCRDMA_MAX_SGID;
 
-	if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
-	    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+	if (ocrdma_is_rocev2_supported(dev))
 		tblsz *= 2;
 
 	mutex_init(&dev->dev_lock);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e80e37f..ef8282f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -191,8 +191,7 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	    IB_PORT_CM_SUP |
 	    IB_PORT_REINIT_SUP |
 	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP | IB_PORT_IP_BASED_GIDS;
-	if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
-	    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+	if (ocrdma_is_rocev2_supported(dev))
 		props->port_cap_flags |= IB_PORT_RoCEV2_BASED_GIDS;
 
 	props->gid_tbl_len = dev->gid_tblsz;
@@ -2709,8 +2708,7 @@ static int ocrdma_update_ud_rcqe(struct ocrdma_dev *dev, struct ib_wc *ibwc,
 			  OCRDMA_CQE_UD_XFER_LEN_SHIFT) &
 			  OCRDMA_CQE_UD_XFER_LEN_MASK;
 
-	if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
-	    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6) {
+	if (ocrdma_is_rocev2_supported(dev)) {
 		hdr_type = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
 			    OCRDMA_CQE_UD_L3TYPE_SHIFT) &
 			    OCRDMA_CQE_UD_L3TYPE_MASK;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
