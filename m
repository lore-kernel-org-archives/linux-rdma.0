From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 10/11] RDMA/mlx5: Unfold create RMP function
Date: Wed, 28 Nov 2018 20:53:42 +0200
Message-ID: <20181128185343.21669-11-leon@kernel.org>
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

There is no need to perform create_rmp in two separate function, while
one of them uses stack as a placeholder for data while other allocates
it dynamically. Combine those two functions to one instead of two.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/srq_cmd.c | 35 +++++++++++++---------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 6be89c6be40f..955df638b416 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -298,20 +298,6 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }

-static int mlx5_core_create_rmp(struct mlx5_ib_dev *dev, u32 *in, int inlen,
-				u32 *rmpn)
-{
-	u32 out[MLX5_ST_SZ_DW(create_rmp_out)] = { 0 };
-	int err;
-
-	MLX5_SET(create_rmp_in, in, opcode, MLX5_CMD_OP_CREATE_RMP);
-	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
-	if (!err)
-		*rmpn = MLX5_GET(create_rmp_out, out, rmpn);
-
-	return err;
-}
-
 static int mlx5_core_modify_rmp(struct mlx5_ib_dev *dev, u32 *in, int inlen)
 {
 	u32 out[MLX5_ST_SZ_DW(modify_rmp_out)] = {0};
@@ -333,18 +319,24 @@ static int mlx5_core_query_rmp(struct mlx5_ib_dev *dev, u32 rmpn, u32 *out)
 static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
-	void *create_in;
+	void *create_out = NULL;
+	void *create_in = NULL;
 	void *rmpc;
 	void *wq;
 	int pas_size;
+	int outlen;
 	int inlen;
 	int err;

 	pas_size = get_pas_size(in);
 	inlen = MLX5_ST_SZ_BYTES(create_rmp_in) + pas_size;
+	outlen = MLX5_ST_SZ_BYTES(create_rmp_out);
 	create_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!create_in)
-		return -ENOMEM;
+	create_out = kvzalloc(outlen, GFP_KERNEL);
+	if (!create_in || !create_out) {
+		err = -ENOMEM;
+		goto out;
+	}

 	rmpc = MLX5_ADDR_OF(create_rmp_in, create_in, ctx);
 	wq = MLX5_ADDR_OF(rmpc, rmpc, wq);
@@ -354,11 +346,16 @@ static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	set_wq(wq, in);
 	memcpy(MLX5_ADDR_OF(rmpc, rmpc, wq.pas), in->pas, pas_size);

-	err = mlx5_core_create_rmp(dev, create_in, inlen, &srq->srqn);
-	if (!err)
+	MLX5_SET(create_rmp_in, create_in, opcode, MLX5_CMD_OP_CREATE_RMP);
+	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out, outlen);
+	if (!err) {
+		srq->srqn = MLX5_GET(create_rmp_out, create_out, rmpn);
 		srq->uid = in->uid;
+	}

+out:
 	kvfree(create_in);
+	kvfree(create_out);
 	return err;
 }
