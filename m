From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 4/5] Expose RSS capabilities
Date: Tue, 30 Aug 2016 18:38:42 +0300
Message-ID: <1472571523-12067-5-git-send-email-yishaih@mellanox.com>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Expose RSS capabilities, data comes as part of vendor
channel.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h | 11 +++++++++++
 src/verbs.c    |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 90f998e..4b5b577 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -237,11 +237,22 @@ struct mlx5_query_device_ex {
 	struct ibv_query_device_ex	ibv_cmd;
 };
 
+struct mlx5_reserved_tso_caps {
+	__u64 reserved;
+};
+
+struct mlx5_rss_caps {
+	__u64 rx_hash_fields_mask; /* enum ibv_rx_hash_fields */
+	__u8 rx_hash_function; /* enum ibv_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
 	__u32				response_length;
 	struct ibv_tso_caps		tso_caps;
+	struct mlx5_rss_caps            rss_caps; /* vendor data channel */
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/src/verbs.c b/src/verbs.c
index a80d377..23b4cdc 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1860,7 +1860,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 		return err;
 
 	attr->tso_caps = resp.tso_caps;
-
+	attr->rss_caps.rx_hash_fields_mask = resp.rss_caps.rx_hash_fields_mask;
+	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
 	sub_minor = raw_fw_ver & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
