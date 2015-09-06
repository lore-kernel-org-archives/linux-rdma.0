From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libmlx5: Implement query device extended verb
Date: Sun,  6 Sep 2015 09:35:31 +0300
Message-ID: <1441521331-18202-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simply pass the extended query device verb to back to libiverbs, in
order to support it.

Also share some code with the legacy query device verb.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c  |  1 +
 src/mlx5.h  |  3 +++
 src/verbs.c | 41 +++++++++++++++++++++++++++++++++++------
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index d02328881992..f058ac498819 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -583,6 +583,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, close_xrcd, mlx5_close_xrcd);
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
+	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
 
 	return 0;
 
diff --git a/src/mlx5.h b/src/mlx5.h
index 6ad79fe324d3..364afe12de68 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -537,6 +537,9 @@ void mlx5_free_db(struct mlx5_context *context, uint32_t *db);
 
 int mlx5_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *attr);
+int mlx5_query_device_ex(struct ibv_context *context,
+			 const struct ibv_query_device_ex_input *input,
+			 struct ibv_device_attr_ex *attr, size_t attr_size);
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr);
 int mlx5_query_port(struct ibv_context *context, uint8_t port,
diff --git a/src/verbs.c b/src/verbs.c
index 8ddf4e631c9f..f269c37ea266 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -53,23 +53,52 @@
 
 int mlx5_single_threaded = 0;
 
+static int raw_fw_ver_to_string(uint64_t raw_fw_ver, char *buf, size_t len)
+{
+	unsigned major, minor, sub_minor;
+
+	major     = (raw_fw_ver >> 32) & 0xffff;
+	minor     = (raw_fw_ver >> 16) & 0xffff;
+	sub_minor = raw_fw_ver & 0xffff;
+
+	return snprintf(buf, len, "%d.%d.%04d", major, minor, sub_minor);
+}
+
 int mlx5_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 {
 	struct ibv_query_device cmd;
 	uint64_t raw_fw_ver;
-	unsigned major, minor, sub_minor;
 	int ret;
 
 	ret = ibv_cmd_query_device(context, attr, &raw_fw_ver, &cmd, sizeof cmd);
 	if (ret)
 		return ret;
 
-	major     = (raw_fw_ver >> 32) & 0xffff;
-	minor     = (raw_fw_ver >> 16) & 0xffff;
-	sub_minor = raw_fw_ver & 0xffff;
+	raw_fw_ver_to_string(raw_fw_ver, attr->fw_ver, sizeof attr->fw_ver);
+
+	return 0;
+}
+
+int mlx5_query_device_ex(struct ibv_context *context,
+			 const struct ibv_query_device_ex_input *input,
+			 struct ibv_device_attr_ex *attr, size_t attr_size)
+{
+	struct ibv_query_device_ex cmd;
+	struct ibv_query_device_resp_ex resp;
+	uint64_t raw_fw_ver;
+	int ret;
+
+	cmd.comp_mask = 0;
+	ret = ibv_cmd_query_device_ex(context, input, attr, attr_size,
+				      &raw_fw_ver, &cmd,
+				      sizeof(struct ibv_query_device_ex),
+				      sizeof(cmd), &resp,
+				      sizeof(struct ibv_query_device_resp_ex),
+				      sizeof(resp));
+	if (ret)
+		return ret;
 
-	snprintf(attr->fw_ver, sizeof attr->fw_ver,
-		 "%d.%d.%04d", major, minor, sub_minor);
+	raw_fw_ver_to_string(raw_fw_ver, attr->orig_attr.fw_ver, sizeof attr->orig_attr.fw_ver);
 
 	return 0;
 }
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
