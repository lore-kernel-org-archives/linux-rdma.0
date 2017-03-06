From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor private data when creating a CQ
Date: Mon,  6 Mar 2017 16:06:43 +0200
Message-ID: <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488809204-30428-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch drops the need to extend the verbs layer each time with
some non generic fields when creating a CQ. It adds an option to set
some opaque vendor data in some generic way which can fit any vendor.

The solution introduced for creating a CQ but expects to fit for
other IB objects as of QP, SRQ, etc.

It comes as a pre-patch for supplying some private mlx5 fields in
downstream patches.

The solution:
1) Introduce a new comp_mask bit (i.e. IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA)
   and a matching void* vendor data field.

2) Vendor should expose its header file for direct access with
   relevant private structures.

3) Application should supply the input based on vendor-defined structure.

4) Upon getting the private data the vendor will cast to its internal
   structure and use the data as part of CQ creation.

Note:
The format of the input is vendor specific and should be defined in an
extended way to support backward/forward compatibility. (e.g. by using
comp_mask, etc.)

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3 | 2 ++
 libibverbs/verbs.h                | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index a6ae769..2a1bc92 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -28,6 +28,7 @@ struct ibv_comp_channel *channel;          /* Completion channel where completio
 int                     comp_vector;       /* Completion vector used to signal completion events. Must be >= 0 and < context->num_comp_vectors. */
 uint64_t                wc_flags;          /* The wc_flags that should be returned in ibv_poll_cq_ex. Or'ed bit of enum ibv_wc_flags_ex. */
 uint32_t                comp_mask;         /* compatibility mask (extended verb). */
+void                    *vendor_data;      /* Vendor private data for creating a CQ. */
 .in -8
 };
 
@@ -44,6 +45,7 @@ enum ibv_wc_flags_ex {
 
 enum ibv_cq_init_attr_mask {
         IBV_CQ_INIT_ATTR_MASK_FLAGS             = 1 << 0,
+	IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA       = 1 << 1,
 };
 
 enum ibv_create_cq_attr_flags {
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 25f4ede..2575e01 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1399,7 +1399,8 @@ struct ibv_context {
 
 enum ibv_cq_init_attr_mask {
 	IBV_CQ_INIT_ATTR_MASK_FLAGS	= 1 << 0,
-	IBV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 1
+	IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA = 1 << 1,
+	IBV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 2
 };
 
 enum ibv_create_cq_attr_flags {
@@ -1430,6 +1431,8 @@ struct ibv_cq_init_attr_ex {
 	 * enum ibv_create_cq_attr_flags
 	 */
 	uint32_t		flags;
+	/* Vendor private data for creating a CQ */
+	void			*vendor_data;
 };
 
 enum ibv_values_mask {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
