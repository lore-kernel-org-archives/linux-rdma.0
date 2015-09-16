From: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] IB/uverbs: Add support for checksum capability reporting in user verbs
Date: Wed, 16 Sep 2015 18:56:07 +0300
Message-ID: <ac71c808fb494bb57043ccf94a6c736d2ed87899.1442413048.git.bodong@mellanox.com>
References: <cover.1442413048.git.bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

New field csum_cap is added to respective uverbs counterpart according
to ib_verbs.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 7 +++++++
 include/uapi/rdma/ib_user_verbs.h    | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ff..9d5deec 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3464,6 +3464,13 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.hca_core_clock = attr.hca_core_clock;
 	resp.response_length += sizeof(resp.hca_core_clock);
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.csum_cap))
+		goto end;
+
+	resp.csum_cap.eth_csum_cap = attr.csum_cap.eth_csum_cap;
+	resp.csum_cap.ib_csum_cap = attr.csum_cap.ib_csum_cap;
+	resp.response_length += sizeof(resp.csum_cap);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (err)
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 978841e..9d69546 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -218,6 +218,11 @@ struct ib_uverbs_odp_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_csum_cap_per_link {
+	__u32 eth_csum_cap;
+	__u32 ib_csum_cap;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -225,6 +230,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
+	struct ib_uverbs_csum_cap_per_link csum_cap;
 };
 
 struct ib_uverbs_query_port {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
