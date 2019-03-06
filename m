From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] IB/mlx5: Use mlx5 core to create/destroy a DEVX DCT
Date: Wed,  6 Mar 2019 19:21:42 +0200
Message-ID: <20190306172142.21036-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

To prevent a hardware memory leak when a DEVX DCT object is destroyed
without calling DRAIN DCT before, (e.g. under cleanup flow), need to
manage its creation and destruction via mlx5 core.

In that case the DRAIN DCT command will be called and only once that
it will be completed the DESTROY DCT command will be called.
Otherwise, the DESTROY DCT may fail and a hardware leak may occur.

As of that change the DRAIN DCT command should not be exposed any more
from DEVX, it's managed internally by the driver to work as expected by
the device specification.

Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c            | 34 +++++++++++++++-----
 drivers/infiniband/hw/mlx5/qp.c              |  4 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c |  6 ++--
 include/linux/mlx5/qp.h                      |  3 +-
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index eaa055007f28..9e08df7914aa 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -20,6 +20,7 @@
 
 enum devx_obj_flags {
 	DEVX_OBJ_FLAGS_INDIRECT_MKEY = 1 << 0,
+	DEVX_OBJ_FLAGS_DCT = 1 << 1,
 };
 
 struct devx_async_data {
@@ -39,7 +40,10 @@ struct devx_obj {
 	u32			dinlen; /* destroy inbox length */
 	u32			dinbox[MLX5_MAX_DESTROY_INBOX_SIZE_DW];
 	u32			flags;
-	struct mlx5_ib_devx_mr	devx_mr;
+	union {
+		struct mlx5_ib_devx_mr	devx_mr;
+		struct mlx5_core_dct	core_dct;
+	};
 };
 
 struct devx_umem {
@@ -347,7 +351,6 @@ static u64 devx_get_obj_id(const void *in)
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_RQ,
 					MLX5_GET(arm_rq_in, in, srq_number));
 		break;
-	case MLX5_CMD_OP_DRAIN_DCT:
 	case MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_DCT,
 					MLX5_GET(drain_dct_in, in, dctn));
@@ -618,7 +621,6 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_2RST_QP:
 	case MLX5_CMD_OP_ARM_XRC_SRQ:
 	case MLX5_CMD_OP_ARM_RQ:
-	case MLX5_CMD_OP_DRAIN_DCT:
 	case MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION:
 	case MLX5_CMD_OP_ARM_XRQ:
 	case MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY:
@@ -1124,7 +1126,11 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
 		devx_cleanup_mkey(obj);
 
-	ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
+	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
+		ret = mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else
+		ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
+				    sizeof(out));
 	if (ib_is_destroy_retryable(ret, why, uobject))
 		return ret;
 
@@ -1185,9 +1191,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		devx_set_umem_valid(cmd_in);
 	}
 
-	err = mlx5_cmd_exec(dev->mdev, cmd_in,
-			    cmd_in_len,
-			    cmd_out, cmd_out_len);
+	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
+		obj->flags |= DEVX_OBJ_FLAGS_DCT;
+		err = mlx5_core_create_dct(dev->mdev, &obj->core_dct,
+					   cmd_in, cmd_in_len,
+					   cmd_out, cmd_out_len);
+	} else {
+		err = mlx5_cmd_exec(dev->mdev, cmd_in,
+				    cmd_in_len,
+				    cmd_out, cmd_out_len);
+	}
+
 	if (err)
 		goto obj_free;
 
@@ -1214,7 +1228,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
 		devx_cleanup_mkey(obj);
 obj_destroy:
-	mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
+	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
+		mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else
+		mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
+			      sizeof(out));
 obj_free:
 	kfree(obj);
 	return err;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6b1f0e76900b..7cd006da1dae 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3729,6 +3729,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
 		struct mlx5_ib_modify_qp_resp resp = {};
+		u32 out[MLX5_ST_SZ_DW(create_dct_out)] = {0};
 		u32 min_resp_len = offsetof(typeof(resp), dctn) +
 				   sizeof(resp.dctn);
 
@@ -3747,7 +3748,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		MLX5_SET(dctc, dctc, hop_limit, attr->ah_attr.grh.hop_limit);
 
 		err = mlx5_core_create_dct(dev->mdev, &qp->dct.mdct, qp->dct.in,
-					   MLX5_ST_SZ_BYTES(create_dct_in));
+					   MLX5_ST_SZ_BYTES(create_dct_in), out,
+					   sizeof(out));
 		if (err)
 			return err;
 		resp.dctn = qp->dct.mdct.mqp.qpn;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 54cdfb354c0e..be249e675733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -261,16 +261,16 @@ static int _mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
 
 int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 			 struct mlx5_core_dct *dct,
-			 u32 *in, int inlen)
+			 u32 *in, int inlen,
+			 u32 *out, int outlen)
 {
-	u32 out[MLX5_ST_SZ_DW(create_dct_out)]   = {0};
 	struct mlx5_core_qp *qp = &dct->mqp;
 	int err;
 
 	init_completion(&dct->drained);
 	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
 
-	err = mlx5_cmd_exec(dev, in, inlen, &out, sizeof(out));
+	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
 	if (err) {
 		mlx5_core_warn(dev, "create DCT failed, ret %d\n", err);
 		return err;
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index b26ea9077384..0343c81d4c5f 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -557,7 +557,8 @@ static inline struct mlx5_core_mkey *__mlx5_mr_lookup(struct mlx5_core_dev *dev,
 
 int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 			 struct mlx5_core_dct *qp,
-			 u32 *in, int inlen);
+			 u32 *in, int inlen,
+			 u32 *out, int outlen);
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			u32 *in,
-- 
2.19.1
