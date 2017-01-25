From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 7/8] mlx4: Add ibv_query_device_ex support
Date: Wed, 25 Jan 2017 16:49:50 +0200
Message-ID: <1485355791-27646-8-git-send-email-yishaih@mellanox.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485355791-27646-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The extended query_device verb allows the user to get
additional vendor specific device parameters.
With this commit ibv_query_device_ex can be used to
retrieve the HCA's core clock offset.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4-abi.h | 15 +++++++++++++++
 providers/mlx4/mlx4.c     |  1 +
 providers/mlx4/mlx4.h     |  4 ++++
 providers/mlx4/verbs.c    | 37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index 3b8bac5..7d89505 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -51,6 +51,10 @@ struct mlx4_alloc_ucontext_resp_v3 {
 	__u16				bf_regs_per_page;
 };
 
+enum mlx4_query_dev_ex_resp_mask {
+	MLX4_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
+};
+
 struct mlx4_alloc_ucontext_resp {
 	struct ibv_get_context_resp	ibv_resp;
 	__u32				dev_caps;
@@ -95,6 +99,17 @@ struct mlx4_resize_cq {
 	__u64				buf_addr;
 };
 
+struct mlx4_query_device_ex_resp {
+	struct ibv_query_device_resp_ex ibv_resp;
+	__u32				comp_mask;
+	__u32				response_length;
+	__u64				hca_core_clock_offset;
+};
+
+struct mlx4_query_device_ex {
+	struct ibv_query_device_ex	ibv_cmd;
+};
+
 struct mlx4_create_srq {
 	struct ibv_create_srq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 3f29d1a..755768e 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -217,6 +217,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
+	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
 
 	return 0;
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 9d43b63..8c01ec1 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -375,6 +375,10 @@ void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type, uint32_t
 
 int mlx4_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *attr);
+int mlx4_query_device_ex(struct ibv_context *context,
+			 const struct ibv_query_device_ex_input *input,
+			 struct ibv_device_attr_ex *attr,
+			 size_t attr_size);
 int mlx4_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr);
 
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 4b00550..c523c41 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -64,6 +64,43 @@ int mlx4_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 	return 0;
 }
 
+int mlx4_query_device_ex(struct ibv_context *context,
+			 const struct ibv_query_device_ex_input *input,
+			 struct ibv_device_attr_ex *attr,
+			 size_t attr_size)
+{
+	struct mlx4_context *mctx = to_mctx(context);
+	struct mlx4_query_device_ex_resp resp = {};
+	struct mlx4_query_device_ex cmd = {};
+	uint64_t raw_fw_ver;
+	unsigned sub_minor;
+	unsigned major;
+	unsigned minor;
+	int err;
+
+	err = ibv_cmd_query_device_ex(context, input, attr, attr_size,
+				      &raw_fw_ver,
+				      &cmd.ibv_cmd, sizeof(cmd.ibv_cmd), sizeof(cmd),
+				      &resp.ibv_resp, sizeof(resp.ibv_resp),
+				      sizeof(resp));
+	if (err)
+		return err;
+
+	if (resp.comp_mask & MLX4_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET) {
+		mctx->core_clock.offset = resp.hca_core_clock_offset;
+		mctx->core_clock.offset_valid = 1;
+	}
+
+	major     = (raw_fw_ver >> 32) & 0xffff;
+	minor     = (raw_fw_ver >> 16) & 0xffff;
+	sub_minor = raw_fw_ver & 0xffff;
+
+	snprintf(attr->orig_attr.fw_ver, sizeof attr->orig_attr.fw_ver,
+		 "%d.%d.%03d", major, minor, sub_minor);
+
+	return 0;
+}
+
 int mlx4_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
