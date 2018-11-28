From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 11/11] RDMA/mlx5: Unfold modify RMP function
Date: Wed, 28 Nov 2018 20:53:43 +0200
Message-ID: <20181128185343.21669-12-leon@kernel.org>
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

There is no need to perform modify_rmp in two separate function,
while one of them uses stack as a placeholder for data while other
allocates it dynamically. Combine those two functions to one call
instead of two.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/srq_cmd.c | 62 +++++++++++++++-------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 955df638b416..7aaaffbd4afa 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -298,24 +298,6 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int mlx5_core_modify_rmp(struct mlx5_ib_dev *dev, u32 *in, int inlen)
-{
-	u32 out[MLX5_ST_SZ_DW(modify_rmp_out)] = {0};
-
-	MLX5_SET(modify_rmp_in, in, opcode, MLX5_CMD_OP_MODIFY_RMP);
-	return mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
-}
-
-static int mlx5_core_query_rmp(struct mlx5_ib_dev *dev, u32 rmpn, u32 *out)
-{
-	u32 in[MLX5_ST_SZ_DW(query_rmp_in)] = {0};
-	int outlen = MLX5_ST_SZ_BYTES(query_rmp_out);
-
-	MLX5_SET(query_rmp_in, in, opcode, MLX5_CMD_OP_QUERY_RMP);
-	MLX5_SET(query_rmp_in, in, rmpn,   rmpn);
-	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, outlen);
-}
-
 static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
@@ -373,15 +355,24 @@ static int destroy_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
-	void *in;
+	void *out = NULL;
+	void *in = NULL;
 	void *rmpc;
 	void *wq;
 	void *bitmask;
+	int outlen;
+	int inlen;
 	int err;
 
-	in = kvzalloc(MLX5_ST_SZ_BYTES(modify_rmp_in), GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
+	inlen = MLX5_ST_SZ_BYTES(modify_rmp_in);
+	outlen = MLX5_ST_SZ_BYTES(modify_rmp_out);
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	out = kvzalloc(outlen, GFP_KERNEL);
+	if (!in || !out) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	rmpc =	  MLX5_ADDR_OF(modify_rmp_in,   in,   ctx);
 	bitmask = MLX5_ADDR_OF(modify_rmp_in,   in,   bitmask);
@@ -393,25 +384,39 @@ static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(wq,		wq,	 lwm,	    lwm);
 	MLX5_SET(rmp_bitmask,	bitmask, lwm,	    1);
 	MLX5_SET(rmpc, rmpc, state, MLX5_RMPC_STATE_RDY);
+	MLX5_SET(modify_rmp_in, in, opcode, MLX5_CMD_OP_MODIFY_RMP);
 
-	err = mlx5_core_modify_rmp(dev, in, MLX5_ST_SZ_BYTES(modify_rmp_in));
+	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, outlen);
 
+out:
 	kvfree(in);
+	kvfree(out);
 	return err;
 }
 
 static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
-	u32 *rmp_out;
+	u32 *rmp_out = NULL;
+	u32 *rmp_in = NULL;
 	void *rmpc;
+	int outlen;
+	int inlen;
 	int err;
 
-	rmp_out =  kvzalloc(MLX5_ST_SZ_BYTES(query_rmp_out), GFP_KERNEL);
-	if (!rmp_out)
-		return -ENOMEM;
+	outlen = MLX5_ST_SZ_BYTES(query_rmp_out);
+	inlen = MLX5_ST_SZ_BYTES(query_rmp_in);
+
+	rmp_out = kvzalloc(outlen, GFP_KERNEL);
+	rmp_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!rmp_out || !rmp_in) {
+		err = -ENOMEM;
+		goto out;
+	}
 
-	err = mlx5_core_query_rmp(dev, srq->srqn, rmp_out);
+	MLX5_SET(query_rmp_in, rmp_in, opcode, MLX5_CMD_OP_QUERY_RMP);
+	MLX5_SET(query_rmp_in, rmp_in, rmpn,   srq->srqn);
+	err = mlx5_cmd_exec(dev->mdev, rmp_in, inlen, rmp_out, outlen);
 	if (err)
 		goto out;
 
@@ -422,6 +427,7 @@ static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 out:
 	kvfree(rmp_out);
+	kvfree(rmp_in);
 	return err;
 }
 
-- 
2.19.1
