From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/5] IB/core: Add extended device capability flags
Date: Sun, 17 Apr 2016 17:19:34 +0300
Message-ID: <1460902778-5977-2-git-send-email-matanb@mellanox.com>
References: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460902778-5977-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since all the uverbs device_cap_flags are occupied, we need a place to
expose more device capabilities.

This patch adds a new 64 bit device_cap_flags_ex to expose new
device capabilities.

The lower 32 bits will be identical to the original device_cap_flags,
The upper 32 bits will be new capabilities.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 +++++
 include/uapi/rdma/ib_user_verbs.h    | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fdc7ec..9acb849 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3655,6 +3655,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.hca_core_clock = attr.hca_core_clock;
 	resp.response_length += sizeof(resp.hca_core_clock);
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.device_cap_flags_ex))
+		goto end;
+
+	resp.device_cap_flags_ex = attr.device_cap_flags;
+	resp.response_length += sizeof(resp.device_cap_flags_ex);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 8126c14..b6543d7 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -226,6 +226,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
+	__u64 device_cap_flags_ex;
 };
 
 struct ib_uverbs_query_port {
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
