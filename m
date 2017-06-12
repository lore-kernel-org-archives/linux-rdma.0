From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/uverbs: Enable user space programs to use out of order placement
Date: Mon, 12 Jun 2017 09:49:17 +0300
Message-ID: <20170612064918.12510-3-leon@kernel.org>
References: <20170612064918.12510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612064918.12510-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch enables user space programs to query out of order device
capability.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 16 ++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 16 ++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb156414..122ba59c633b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3766,6 +3766,15 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+static void copy_ooo_caps(struct ib_uverbs_ooo_caps *uverb_caps,
+			  struct ib_ooo_caps *attr_caps)
+{
+	uverb_caps->rc_caps = attr_caps->rc_caps;
+	uverb_caps->xrc_caps = attr_caps->xrc_caps;
+	uverb_caps->ud_caps = attr_caps->ud_caps;
+	uverb_caps->uc_caps = attr_caps->uc_caps;
+}
+
 int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      struct ib_udata *ucore,
@@ -3854,6 +3863,13 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 	resp.raw_packet_caps = attr.raw_packet_caps;
 	resp.response_length += sizeof(resp.raw_packet_caps);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.ooo_caps))
+		goto end;
+
+	copy_ooo_caps(&resp.ooo_caps, &attr.ooo_caps);
+	resp.response_length += sizeof(resp.ooo_caps);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 270c350bedc6..3519ff8e34cd 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -236,6 +236,17 @@ struct ib_uverbs_rss_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_ooo_caps {
+	/*
+	 * Per transport capability indicating whether out of order data
+	 * placement is supported or not.
+	 */
+	 __u32 rc_caps;
+	 __u32 xrc_caps;
+	 __u32 ud_caps;
+	 __u32 uc_caps;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -247,6 +258,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_rss_caps rss_caps;
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
+	struct ib_uverbs_ooo_caps ooo_caps;
 };
 
 struct ib_uverbs_query_port {
@@ -555,9 +567,9 @@ enum {
 
 enum {
 	/*
-	 * This value is equal to IB_QP_RATE_LIMIT.
+	 * This value is equal to IB_QP_OOO_RW_DATA_PLACEMENT.
 	 */
-	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 25,
+	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 26,
 };
 
 struct ib_uverbs_ex_create_qp {
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
