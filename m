From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 02/11] net/mlx5: Remove dead transobj code
Date: Wed, 28 Nov 2018 20:53:34 +0200
Message-ID: <20181128185343.21669-3-leon@kernel.org>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Delete functions which are not called and not needed.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/transobj.c    | 66 -------------------
 include/linux/mlx5/transobj.h                 |  5 --
 2 files changed, 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index a1ee9a8a769e..ab482124e901 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -301,72 +301,6 @@ int mlx5_core_query_rmp(struct mlx5_core_dev *dev, u32 rmpn, u32 *out)
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
 
-int mlx5_core_arm_rmp(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm)
-{
-	void *in;
-	void *rmpc;
-	void *wq;
-	void *bitmask;
-	int  err;
-
-	in = kvzalloc(MLX5_ST_SZ_BYTES(modify_rmp_in), GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	rmpc    = MLX5_ADDR_OF(modify_rmp_in,   in,   ctx);
-	bitmask = MLX5_ADDR_OF(modify_rmp_in,   in,   bitmask);
-	wq      = MLX5_ADDR_OF(rmpc,	        rmpc, wq);
-
-	MLX5_SET(modify_rmp_in, in,	 rmp_state, MLX5_RMPC_STATE_RDY);
-	MLX5_SET(modify_rmp_in, in,	 rmpn,      rmpn);
-	MLX5_SET(wq,		wq,	 lwm,	    lwm);
-	MLX5_SET(rmp_bitmask,	bitmask, lwm,	    1);
-	MLX5_SET(rmpc,		rmpc,	 state,	    MLX5_RMPC_STATE_RDY);
-
-	err =  mlx5_core_modify_rmp(dev, in, MLX5_ST_SZ_BYTES(modify_rmp_in));
-
-	kvfree(in);
-
-	return err;
-}
-
-int mlx5_core_create_xsrq(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			  u32 *xsrqn)
-{
-	u32 out[MLX5_ST_SZ_DW(create_xrc_srq_out)] = {0};
-	int err;
-
-	MLX5_SET(create_xrc_srq_in, in, opcode,     MLX5_CMD_OP_CREATE_XRC_SRQ);
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
-	if (!err)
-		*xsrqn = MLX5_GET(create_xrc_srq_out, out, xrc_srqn);
-
-	return err;
-}
-
-int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 xsrqn)
-{
-	u32 in[MLX5_ST_SZ_DW(destroy_xrc_srq_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(destroy_xrc_srq_out)] = {0};
-
-	MLX5_SET(destroy_xrc_srq_in, in, opcode,   MLX5_CMD_OP_DESTROY_XRC_SRQ);
-	MLX5_SET(destroy_xrc_srq_in, in, xrc_srqn, xsrqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-
-int mlx5_core_arm_xsrq(struct mlx5_core_dev *dev, u32 xsrqn, u16 lwm)
-{
-	u32 in[MLX5_ST_SZ_DW(arm_xrc_srq_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(arm_xrc_srq_out)] = {0};
-
-	MLX5_SET(arm_xrc_srq_in, in, opcode,   MLX5_CMD_OP_ARM_XRC_SRQ);
-	MLX5_SET(arm_xrc_srq_in, in, xrc_srqn, xsrqn);
-	MLX5_SET(arm_xrc_srq_in, in, lwm,      lwm);
-	MLX5_SET(arm_xrc_srq_in, in, op_mod,
-		 MLX5_ARM_XRC_SRQ_IN_OP_MOD_XRC_SRQ);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-
 int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rqtn)
 {
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
index 7f5ca2cd3a32..39ebb699875b 100644
--- a/include/linux/mlx5/transobj.h
+++ b/include/linux/mlx5/transobj.h
@@ -63,11 +63,6 @@ int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
 int mlx5_core_modify_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen);
 int mlx5_core_destroy_rmp(struct mlx5_core_dev *dev, u32 rmpn);
 int mlx5_core_query_rmp(struct mlx5_core_dev *dev, u32 rmpn, u32 *out);
-int mlx5_core_arm_rmp(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
-int mlx5_core_create_xsrq(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			  u32 *rmpn);
-int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 rmpn);
-int mlx5_core_arm_xsrq(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
 
 int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rqtn);
-- 
2.19.1
