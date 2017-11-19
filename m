From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx4: Add a report of RSS capabilities in ibv_query_device_ex
Date: Sun, 19 Nov 2017 18:56:22 +0200
Message-ID: <1511110582-20014-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report few extra RSS capabilities that were missed in previous patches.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

The matching kernel part was already merged into 4.15.
PR was sent:
https://github.com/linux-rdma/rdma-core/pull/256

 providers/mlx4/mlx4-abi.h | 8 +++++++-
 providers/mlx4/verbs.c    | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index 4f2132c..c4783d2 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -99,13 +99,19 @@ struct mlx4_resize_cq {
 	__u64				buf_addr;
 };
 
+struct mlx4_rss_caps {
+	__u64 rx_hash_fields_mask; /* enum ibv_rx_hash_fields */
+	__u8 rx_hash_function; /* enum ibv_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
 struct mlx4_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
 	__u32				response_length;
 	__u64				hca_core_clock_offset;
 	__u32				max_inl_recv_sz;
-	__u32				reserved;
+	struct mlx4_rss_caps            rss_caps; /* vendor data channel */
 };
 
 struct mlx4_query_device_ex {
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 8532882..8a2773f 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -87,6 +87,9 @@ int mlx4_query_device_ex(struct ibv_context *context,
 	if (err)
 		return err;
 
+	attr->rss_caps.rx_hash_fields_mask = resp.rss_caps.rx_hash_fields_mask;
+	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
+
 	if (resp.comp_mask & MLX4_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET) {
 		mctx->core_clock.offset = resp.hca_core_clock_offset;
 		mctx->core_clock.offset_valid = 1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
