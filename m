From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/7] IB/mlx5: Enable modify and query verbs objects via DEVX
Date: Mon, 26 Nov 2018 08:28:35 +0200
Message-ID: <20181126062838.5907-5-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enables modify and query verbs objects via the DEVX interface.
To support this the above DEVX handlers were changed to get any
object type via the UVERBS_IDR_ANY_OBJECT mechanism.

The type checking and handling is done per object as part of the
driver code.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 108 ++++++++++++++++++++++++++----
 1 file changed, 96 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 0aa2ee732eaa..f80b78aab4da 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -9,6 +9,7 @@
 #include <rdma/uverbs_ioctl.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/ib_umem.h>
+#include <rdma/uverbs_std_types.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
@@ -132,7 +133,7 @@ static u64 get_enc_obj_id(u16 opcode, u32 obj_id)
 	return ((u64)opcode << 32) | obj_id;
 }
 
-static int devx_is_valid_obj_id(struct devx_obj *obj, const void *in)
+static u64 devx_get_obj_id(const void *in)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 	u64 obj_id;
@@ -336,13 +337,96 @@ static int devx_is_valid_obj_id(struct devx_obj *obj, const void *in)
 					MLX5_GET(arm_xrq_in, in, xrqn));
 		break;
 	default:
+		obj_id = 0;
+	}
+
+	return obj_id;
+}
+
+static bool devx_is_valid_obj_id(struct ib_uobject *uobj, const void *in)
+{
+	u64 obj_id = devx_get_obj_id(in);
+
+	if (!obj_id)
 		return false;
+
+	switch (uobj_get_object_id(uobj)) {
+	case UVERBS_OBJECT_CQ:
+		return get_enc_obj_id(MLX5_CMD_OP_CREATE_CQ,
+				      to_mcq(uobj->object)->mcq.cqn) ==
+				      obj_id;
+
+	case UVERBS_OBJECT_SRQ:
+	{
+		struct mlx5_core_srq *srq = &(to_msrq(uobj->object)->msrq);
+		struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
+		u16 opcode;
+
+		switch (srq->common.res) {
+		case MLX5_RES_XSRQ:
+			opcode = MLX5_CMD_OP_CREATE_XRC_SRQ;
+			break;
+		case MLX5_RES_XRQ:
+			opcode = MLX5_CMD_OP_CREATE_XRQ;
+			break;
+		default:
+			if (!dev->mdev->issi)
+				opcode = MLX5_CMD_OP_CREATE_SRQ;
+			else
+				opcode = MLX5_CMD_OP_CREATE_RMP;
+		}
+
+		return get_enc_obj_id(opcode,
+				      to_msrq(uobj->object)->msrq.srqn) ==
+				      obj_id;
 	}
 
-	if (obj_id == obj->obj_id)
-		return true;
+	case UVERBS_OBJECT_QP:
+	{
+		struct mlx5_ib_qp *qp = to_mqp(uobj->object);
+		enum ib_qp_type	qp_type = qp->ibqp.qp_type;
+
+		if (qp_type == IB_QPT_RAW_PACKET ||
+		    (qp->flags & MLX5_IB_QP_UNDERLAY)) {
+			struct mlx5_ib_raw_packet_qp *raw_packet_qp =
+							 &qp->raw_packet_qp;
+			struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+			struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+
+			return (get_enc_obj_id(MLX5_CMD_OP_CREATE_RQ,
+					       rq->base.mqp.qpn) == obj_id ||
+				get_enc_obj_id(MLX5_CMD_OP_CREATE_SQ,
+					       sq->base.mqp.qpn) == obj_id ||
+				get_enc_obj_id(MLX5_CMD_OP_CREATE_TIR,
+					       rq->tirn) == obj_id ||
+				get_enc_obj_id(MLX5_CMD_OP_CREATE_TIS,
+					       sq->tisn) == obj_id);
+		}
+
+		if (qp_type == MLX5_IB_QPT_DCT)
+			return get_enc_obj_id(MLX5_CMD_OP_CREATE_DCT,
+					      qp->dct.mdct.mqp.qpn) == obj_id;
+
+		return get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
+				      qp->ibqp.qp_num) == obj_id;
+	}
 
-	return false;
+	case UVERBS_OBJECT_WQ:
+		return get_enc_obj_id(MLX5_CMD_OP_CREATE_RQ,
+				      to_mrwq(uobj->object)->core_qp.qpn) ==
+				      obj_id;
+
+	case UVERBS_OBJECT_RWQ_IND_TBL:
+		return get_enc_obj_id(MLX5_CMD_OP_CREATE_RQT,
+				      to_mrwq_ind_table(uobj->object)->rqtn) ==
+				      obj_id;
+
+	case MLX5_IB_OBJECT_DEVX_OBJ:
+		return ((struct devx_obj *)uobj->object)->obj_id == obj_id;
+
+	default:
+		return false;
+	}
 }
 
 static void devx_set_umem_valid(const void *in)
@@ -994,7 +1078,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
 	struct mlx5_ib_ucontext *c = to_mucontext(uobj->context);
-	struct devx_obj *obj = uobj->object;
+	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
 	void *cmd_out;
 	int err;
 	int uid;
@@ -1006,7 +1090,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	if (!devx_is_obj_modify_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(obj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1016,7 +1100,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
-	err = mlx5_cmd_exec(obj->mdev, cmd_in,
+	err = mlx5_cmd_exec(mdev->mdev, cmd_in,
 			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
 			    cmd_out, cmd_out_len);
 	if (err)
@@ -1035,10 +1119,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 							  MLX5_IB_ATTR_DEVX_OBJ_QUERY_HANDLE);
 	struct mlx5_ib_ucontext *c = to_mucontext(uobj->context);
-	struct devx_obj *obj = uobj->object;
 	void *cmd_out;
 	int err;
 	int uid;
+	struct mlx5_ib_dev *mdev = to_mdev(uobj->context->device);
 
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
@@ -1047,7 +1131,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	if (!devx_is_obj_query_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(obj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1055,7 +1139,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_exec(obj->mdev, cmd_in,
+	err = mlx5_cmd_exec(mdev->mdev, cmd_in,
 			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
 			    cmd_out, cmd_out_len);
 	if (err)
@@ -1293,7 +1377,7 @@ DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_DEVX_OBJ_MODIFY,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE,
-			MLX5_IB_OBJECT_DEVX_OBJ,
+			UVERBS_IDR_ANY_OBJECT,
 			UVERBS_ACCESS_WRITE,
 			UA_MANDATORY),
 	UVERBS_ATTR_PTR_IN(
@@ -1309,7 +1393,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 DECLARE_UVERBS_NAMED_METHOD(
 	MLX5_IB_METHOD_DEVX_OBJ_QUERY,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_OBJ_QUERY_HANDLE,
-			MLX5_IB_OBJECT_DEVX_OBJ,
+			UVERBS_IDR_ANY_OBJECT,
 			UVERBS_ACCESS_READ,
 			UA_MANDATORY),
 	UVERBS_ATTR_PTR_IN(
-- 
2.19.1
