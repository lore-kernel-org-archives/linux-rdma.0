From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/core: Fix unaligned accesses
Date: Thu, 30 Apr 2015 22:42:48 -0400
Message-ID: <1430448168-38479-1-git-send-email-david.ahern@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Addresses the following kernel logs seen during boot of sparc systems:

Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]

Changed signature of cm_mask_copy from u8 to u32 as suggested by Jason
Gunthorpe.

Signed-off-by: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2
- updated per Jason's comments

 drivers/infiniband/core/cm.c | 17 ++++++++---------
 include/rdma/ib_cm.h         |  4 ++--
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494e2a3a..cbbf741987b3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -437,20 +437,19 @@ static struct cm_id_private * cm_acquire_id(__be32 local_id, __be32 remote_id)
 	return cm_id_priv;
 }
 
-static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
+static void cm_mask_copy(u32 *dst, u32 *src, u32 *mask)
 {
 	int i;
 
-	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
-		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
-					     ((unsigned long *) mask)[i];
+	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(u32); i++)
+		dst[i] =  src[i] & mask[i];
 }
 
 static int cm_compare_data(struct ib_cm_compare_data *src_data,
 			   struct ib_cm_compare_data *dst_data)
 {
-	u8 src[IB_CM_COMPARE_SIZE];
-	u8 dst[IB_CM_COMPARE_SIZE];
+	u32 src[IB_CM_COMPARE_SIZE];
+	u32 dst[IB_CM_COMPARE_SIZE];
 
 	if (!src_data || !dst_data)
 		return 0;
@@ -460,10 +459,10 @@ static int cm_compare_data(struct ib_cm_compare_data *src_data,
 	return memcmp(src, dst, IB_CM_COMPARE_SIZE);
 }
 
-static int cm_compare_private_data(u8 *private_data,
+static int cm_compare_private_data(u32 *private_data,
 				   struct ib_cm_compare_data *dst_data)
 {
-	u8 src[IB_CM_COMPARE_SIZE];
+	u32 src[IB_CM_COMPARE_SIZE];
 
 	if (!dst_data)
 		return 0;
@@ -546,7 +545,7 @@ static struct cm_id_private * cm_find_listen(struct ib_device *device,
 
 	while (node) {
 		cm_id_priv = rb_entry(node, struct cm_id_private, service_node);
-		data_cmp = cm_compare_private_data(private_data,
+		data_cmp = cm_compare_private_data((u32 *) private_data,
 						   cm_id_priv->compare_data);
 		if ((cm_id_priv->id.service_mask & service_id) ==
 		     cm_id_priv->id.service_id &&
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 0e3ff30647d5..0dd576f40c83 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -337,8 +337,8 @@ void ib_destroy_cm_id(struct ib_cm_id *cm_id);
 #define IB_SDP_SERVICE_ID_MASK	cpu_to_be64(0xFFFFFFFFFFFF0000ULL)
 
 struct ib_cm_compare_data {
-	u8  data[IB_CM_COMPARE_SIZE];
-	u8  mask[IB_CM_COMPARE_SIZE];
+	u32  data[IB_CM_COMPARE_SIZE];
+	u32  mask[IB_CM_COMPARE_SIZE];
 };
 
 /**
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
