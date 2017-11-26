From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 2/4] mlx5: Introduce mlx5dv_create_qp()
Date: Sun, 26 Nov 2017 19:45:15 +0200
Message-ID: <1511718317-3381-5-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A vendor QP has a generic type that doesn't add any additional info
about this QP, not even to the vendor itself. It is required to add more
info about the specific type of the QP and extra initialization data
without tainting the verbs interface command layout. For this purpose
the application calls mlx5dv_create_qp() instead of ibv_create_qp() and
passes the vendor specific data along with the generic QP
initialization data. This function still calls the ibv_cmd_create_qp()
but extra data is now piggybacking on the standard command structure.
Since this function returns an object of type (ibv_qp *) any function
that take (ibv_qp *) as an argument will work with this object. For
instance, ibv_modify_qp() will be used to modify the state of a QP that
was created with mlx5dv_creae_qp().

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  5 +++++
 providers/mlx5/mlx5dv.h   | 39 +++++++++++++++++++++++++++++++++++++++
 providers/mlx5/verbs.c    | 19 +++++++++++++++----
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index d1e8b9d..71e2424 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -163,6 +163,9 @@ struct mlx5_create_qp_drv_ex {
 	__u32			reserved;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64			sq_buf_addr;
+	__u32			vendor_qp_type;
+	__u32			reserved1;
+
 };
 
 struct mlx5_create_qp_ex {
@@ -199,6 +202,8 @@ struct mlx5_create_qp {
 	__u32                           reserved;
 	/* SQ buffer address - used for Raw Packet QP */
 	__u64                           sq_buf_addr;
+	__u32				vendor_qp_type;
+	__u32                           reserved1;
 };
 
 struct mlx5_create_qp_resp {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 600f6e1..0fc4021 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -107,6 +107,45 @@ struct mlx5dv_cq_init_attr {
 struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
 				   struct ibv_cq_init_attr_ex *cq_attr,
 				   struct mlx5dv_cq_init_attr *mlx5_cq_attr);
+
+enum mlx5dv_dc_type{
+	MLX5_VENDOR_QPT_DCT     = 1,
+	MLX5_VENDOR_QPT_DCI,
+};
+
+enum mlx5dv_dc_handshake_mode {
+	MLX5DV_QP_HANDSHAKE_MODE_FULL = 0,
+	MLX5DV_QP_HANDSHAKE_MODE_HALF
+};
+
+enum mlx5dv_qp_init_attr_mask {
+	MLX5DV_QP_INIT_ATTR_MASK_DC	= 1 << 0,
+};
+
+struct mlx5dv_dc_attr {
+	enum mlx5dv_dc_type vendor_qp_type;
+	union {
+		struct {
+			enum mlx5dv_dc_handshake_mode	mode;
+			uint8_t	reverse_cnak_sl;
+		} dc_ini;
+		struct {
+			uint64_t access_key;
+			uint32_t min_responders;
+			uint32_t max_responders;
+		} dc_tgt;
+	};
+};
+
+struct mlx5dv_qp_init_attr {
+	uint64_t comp_mask;
+	struct mlx5dv_dc_attr dc_attr;
+};
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_init_attr_ex,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr);
+
 /*
  * Most device capabilities are exported by ibv_query_device(...),
  * but there is HW device-specific information which is important
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index c2e8c64..835a226 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1244,7 +1244,8 @@ enum {
 };
 
 static struct ibv_qp *create_qp(struct ibv_context *context,
-			 struct ibv_qp_init_attr_ex *attr)
+				struct ibv_qp_init_attr_ex *attr,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr)
 {
 	struct mlx5_create_qp		cmd;
 	struct mlx5_create_qp_resp	resp;
@@ -1374,6 +1375,9 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = usr_idx;
 	}
 
+	if (mlx5_qp_init_attr) {
+		cmd.vendor_qp_type = mlx5_qp_init_attr->vendor_qp_type;
+	}
 	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
 		ret = mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
 	else
@@ -1448,7 +1452,7 @@ struct ibv_qp *mlx5_create_qp(struct ibv_pd *pd,
 	memcpy(&attrx, attr, sizeof(*attr));
 	attrx.comp_mask = IBV_QP_INIT_ATTR_PD;
 	attrx.pd = pd;
-	qp = create_qp(pd->context, &attrx);
+	qp = create_qp(pd->context, &attrx, NULL);
 	if (qp)
 		memcpy(attr, &attrx, sizeof(*attr));
 
@@ -1785,7 +1789,14 @@ int mlx5_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr)
 {
-	return create_qp(context, attr);
+	return create_qp(context, attr, NULL);
+}
+
+struct ibv_qp *mlx5dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *qp_init_attr_ex,
+				struct mlx5dv_qp_init_attr *mlx5_qp_init_attr)
+{
+	return create_qp(context, qp_init_attr_ex, mlx5_qp_init_attr);
 }
 
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
@@ -1870,7 +1881,7 @@ create_cmd_qp(struct ibv_context *context,
 	init_attr.send_cq = srq_attr->cq;
 	init_attr.recv_cq = srq_attr->cq;
 
-	qp = create_qp(context, &init_attr);
+	qp = create_qp(context, &init_attr, NULL);
 	if (!qp)
 		return NULL;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
