From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] IB/core: Fix unaligned accesses
Date: Fri,  1 May 2015 17:22:29 -0400
Message-ID: <1430515349-183903-1-git-send-email-david.ahern@oracle.com>
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

Signed-off-by: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v3
- updated definition of IB_CM_COMPARE_SIZE to account for u32 walking
  per Yann's comment
- added const to src/mask args to cm_mask_copy and removed extra whitespace
  per Bart's comments
- changed 2 private_data declarations to u32 as suggested by Jason

v2
- updated per Jason's comments

 drivers/infiniband/core/cm.c      | 17 ++++++++---------
 drivers/infiniband/core/cm_msgs.h |  4 ++--
 include/rdma/ib_cm.h              |  7 ++++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494e2a3a..0c276a53b8a8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -437,20 +437,19 @@ static struct cm_id_private * cm_acquire_id(__be32 local_id, __be32 remote_id)
 	return cm_id_priv;
 }
 
-static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
+static void cm_mask_copy(u32 *dst, const u32 *src, const u32 *mask)
 {
 	int i;
 
-	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
-		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
-					     ((unsigned long *) mask)[i];
+	for (i = 0; i < IB_CM_COMPARE_SIZE; i++)
+		dst[i] = src[i] & mask[i];
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
@@ -538,7 +537,7 @@ static struct cm_id_private * cm_insert_listen(struct cm_id_private *cm_id_priv)
 
 static struct cm_id_private * cm_find_listen(struct ib_device *device,
 					     __be64 service_id,
-					     u8 *private_data)
+					     u32 *private_data)
 {
 	struct rb_node *node = cm.listen_service_table.rb_node;
 	struct cm_id_private *cm_id_priv;
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index be068f47e47e..8b76f0ef965e 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -103,7 +103,7 @@ struct cm_req_msg {
 	/* local ACK timeout:5, rsvd:3 */
 	u8 alt_offset139;
 
-	u8 private_data[IB_CM_REQ_PRIVATE_DATA_SIZE];
+	u32 private_data[IB_CM_REQ_PRIVATE_DATA_SIZE / sizeof(u32)];
 
 } __attribute__ ((packed));
 
@@ -801,7 +801,7 @@ struct cm_sidr_req_msg {
 	__be16 rsvd;
 	__be64 service_id;
 
-	u8 private_data[IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE];
+	u32 private_data[IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE / sizeof(u32)];
 } __attribute__ ((packed));
 
 struct cm_sidr_rep_msg {
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 0e3ff30647d5..39ed2d2fbd51 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -105,7 +105,8 @@ enum ib_cm_data_size {
 	IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE = 216,
 	IB_CM_SIDR_REP_PRIVATE_DATA_SIZE = 136,
 	IB_CM_SIDR_REP_INFO_LENGTH	 = 72,
-	IB_CM_COMPARE_SIZE		 = 64
+	/* compare done u32 at a time */
+	IB_CM_COMPARE_SIZE		 = (64 / sizeof(u32))
 };
 
 struct ib_cm_id;
@@ -337,8 +338,8 @@ void ib_destroy_cm_id(struct ib_cm_id *cm_id);
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
