From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum offload capabilities report
Date: Wed,  5 Aug 2015 18:34:26 +0300
Message-ID: <1438788867-18332-2-git-send-email-amirv@mellanox.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438788867-18332-1-git-send-email-amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

- TX/RX checksum offload capabilities are now reporting through
  a new member "csum_cap" inside ib_device_attr.
- The capabilities cover IP_HDR and TCP_UDP.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
 include/rdma/ib_verbs.h              | 8 ++++++++
 include/uapi/rdma/ib_user_verbs.h    | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ff..c3d7c54 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3435,6 +3435,12 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	copy_query_dev_fields(file, &resp.base, &attr);
 	resp.comp_mask = 0;
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.csum_caps))
+		goto end;
+
+	resp.csum_caps = attr.csum_caps;
+	resp.response_length += sizeof(resp.csum_caps);
+
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
 		goto end;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0940051..582483e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -190,6 +190,13 @@ struct ib_cq_init_attr {
 	u32		flags;
 };
 
+enum ib_csum_cap_flags {
+	IB_CSUM_RX_TCP_UDP       = 1 << 0,
+	IB_CSUM_RX_IP_HDR        = 1 << 1,
+	IB_CSUM_TX_TCP_UDP       = 1 << 2,
+	IB_CSUM_TX_IP_HDR        = 1 << 3
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -236,6 +243,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	u32                     csum_caps;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 978841e..5eb7de1 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -205,6 +205,7 @@ struct ib_uverbs_query_device_resp {
 
 struct ib_uverbs_ex_query_device {
 	__u32 comp_mask;
+	__u32 csum_caps;
 	__u32 reserved;
 };
 
@@ -221,6 +222,7 @@ struct ib_uverbs_odp_caps {
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
+	__u32 csum_caps;
 	__u32 response_length;
 	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
-- 
2.4.3.413.ga5fe668

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
