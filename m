From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 1/7] Add timestamp support query_device_ex
Date: Sun, 15 Nov 2015 14:30:28 +0200
Message-ID: <1447590634-12858-2-git-send-email-matanb@mellanox.com>
References: <1447590634-12858-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447590634-12858-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add timestamp support for query_device extended verb.
This is necessary in order to support hca_core_clock and
timestamp_mask. In addition, hca_core_clock_offset is added
to the vendor specific part in order to map the cycles register
correctly.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h |  9 +++++++++
 src/mlx5.h     |  8 ++++++++
 src/verbs.c    | 42 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index c2490a5..97dfeec 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -165,8 +165,17 @@ struct mlx5_query_device_ex {
 	struct ibv_query_device_ex	ibv_cmd;
 };
 
+enum query_device_resp_mask {
+	QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
+	struct {
+		uint32_t comp_mask;
+		uint32_t response_length;
+		uint64_t hca_core_clock_offset;
+	};
 };
 
 #endif /* MLX4_ABI_H */
diff --git a/src/mlx5.h b/src/mlx5.h
index b57c7c7..325e07b 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -307,6 +307,10 @@ struct mlx5_context {
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
 	uint8_t				cqe_version;
+	struct {
+		uint64_t                offset;
+		uint64_t                mask;
+	} core_clock;
 };
 
 struct mlx5_bitmap {
@@ -576,6 +580,10 @@ void mlx5_free_db(struct mlx5_context *context, uint32_t *db);
 
 int mlx5_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *attr);
+int _mlx5_query_device_ex(struct ibv_context *context,
+			  const struct ibv_query_device_ex_input *input,
+			  struct ibv_device_attr_ex *attr, size_t attr_size,
+			  uint32_t *comp_mask);
 int mlx5_query_device_ex(struct ibv_context *context,
 			 const struct ibv_query_device_ex_input *input,
 			 struct ibv_device_attr_ex *attr,
diff --git a/src/verbs.c b/src/verbs.c
index 92f273d..4c054f1 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1475,10 +1475,10 @@ struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 	return NULL;
 }
 
-int mlx5_query_device_ex(struct ibv_context *context,
-			 const struct ibv_query_device_ex_input *input,
-			 struct ibv_device_attr_ex *attr,
-			 size_t attr_size)
+int _mlx5_query_device_ex(struct ibv_context *context,
+			  const struct ibv_query_device_ex_input *input,
+			  struct ibv_device_attr_ex *attr,
+			  size_t attr_size, uint32_t *comp_mask)
 {
 	struct mlx5_query_device_ex_resp resp;
 	struct mlx5_query_device_ex cmd;
@@ -1493,10 +1493,19 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	memset(&resp, 0, sizeof(resp));
 	err = ibv_cmd_query_device_ex(context, input, attr, attr_size,
 				      &raw_fw_ver, &cmd.ibv_cmd, sizeof(cmd.ibv_cmd),
-				      sizeof(cmd), &resp.ibv_resp, sizeof(resp),
-				      sizeof(resp.ibv_resp));
-	if (err)
-		return err;
+				      sizeof(cmd), &resp.ibv_resp,
+				      sizeof(resp.ibv_resp), sizeof(resp));
+	if (err) {
+		err = ibv_cmd_query_device_ex(context, input, attr, attr_size,
+					      &raw_fw_ver, &cmd.ibv_cmd,
+					      sizeof(cmd.ibv_cmd),
+					      sizeof(cmd.ibv_cmd),
+					      &resp.ibv_resp,
+					      sizeof(resp.ibv_resp),
+					      sizeof(resp.ibv_resp));
+		if (err)
+			return err;
+	}
 
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
@@ -1505,5 +1514,22 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	snprintf(a->fw_ver, sizeof(a->fw_ver), "%d.%d.%04d",
 		 major, minor, sub_minor);
 
+	if (resp.comp_mask & QUERY_DEVICE_RESP_MASK_TIMESTAMP &&
+	    resp.response_length >= (offsetof(typeof(resp), hca_core_clock_offset) +
+				     sizeof(resp.hca_core_clock_offset) -
+				     sizeof(resp.ibv_resp)))
+		to_mctx(context)->core_clock.offset =
+			resp.hca_core_clock_offset;
+
+	if (comp_mask)
+		*comp_mask = resp.comp_mask;
+
 	return 0;
 }
+
+int mlx5_query_device_ex(struct ibv_context *context,
+			 const struct ibv_query_device_ex_input *input,
+			 struct ibv_device_attr_ex *attr, size_t attr_size)
+{
+	return _mlx5_query_device_ex(context, input, attr, attr_size, NULL);
+}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
