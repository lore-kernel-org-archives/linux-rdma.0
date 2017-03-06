From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/5] mlx5: Explicitly align mlx5 query device response to 64 bit
Date: Mon,  6 Mar 2017 16:06:40 +0200
Message-ID: <1488809204-30428-2-git-send-email-yishaih@mellanox.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488809204-30428-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Explicitly align packet pacing response to 64 bit so that further
capabilities that going to be read will match to mlx5 kernel response.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h | 7 ++++++-
 providers/mlx5/verbs.c    | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 5d10486..8025131 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -263,6 +263,11 @@ struct mlx5_rss_caps {
 	__u8 reserved[7];
 };
 
+struct mlx5_packet_pacing_caps {
+	struct ibv_packet_pacing_caps caps;
+	__u32  reserved;
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
@@ -270,7 +275,7 @@ struct mlx5_query_device_ex_resp {
 	struct ibv_tso_caps		tso_caps;
 	struct mlx5_rss_caps            rss_caps; /* vendor data channel */
 	__u64				reserved_cqe_comp;
-	struct ibv_packet_pacing_caps	packet_pacing_caps;
+	struct mlx5_packet_pacing_caps	packet_pacing_caps;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 98a9557..a659d3e 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1922,7 +1922,7 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	attr->tso_caps = resp.tso_caps;
 	attr->rss_caps.rx_hash_fields_mask = resp.rss_caps.rx_hash_fields_mask;
 	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
-	attr->packet_pacing_caps = resp.packet_pacing_caps;
+	attr->packet_pacing_caps = resp.packet_pacing_caps.caps;
 
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
