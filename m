From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/core: Report LSO capabilities when querying device
Date: Mon, 18 Apr 2016 19:25:16 +0300
Message-ID: <1460996717-18778-2-git-send-email-majd@mellanox.com>
References: <1460996717-18778-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460996717-18778-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

LSO capabilities include the max LSO packet size in byte, and what QP
types the hardware supports.

Relevant verbs to report LSO caps from kernel to user space is updated
accordingly.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 7 +++++++
 include/rdma/ib_verbs.h              | 6 ++++++
 include/uapi/rdma/ib_user_verbs.h    | 6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fdc7ec..b0fb94b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3655,6 +3655,13 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.hca_core_clock = attr.hca_core_clock;
 	resp.response_length += sizeof(resp.hca_core_clock);
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.lso_caps))
+		goto end;
+
+	resp.lso_caps.max_lso = attr.lso_caps.max_lso;
+	resp.lso_caps.supported_qpts = attr.lso_caps.supported_qpts;
+	resp.response_length += sizeof(resp.lso_caps);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fb2cef4..d5a466f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -271,6 +271,11 @@ struct ib_cq_init_attr {
 	u32		flags;
 };
 
+struct ib_lso_caps {
+	u32 max_lso;
+	u32 supported_qpts; /* Use enum ib_qp_type */
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -317,6 +322,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	struct ib_lso_caps	lso_caps;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 8126c14..fa039f5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -219,6 +219,11 @@ struct ib_uverbs_odp_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_lso_caps {
+	__u32 max_lso;
+	__u32 supported_qpts; /* Use enum ib_qp_type */
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -226,6 +231,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
+	struct ib_uverbs_lso_caps lso_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
