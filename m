From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 08/11] RDMA/mlx5: Update SRQ functions signatures to mlx5_ib format
Date: Wed, 28 Nov 2018 20:53:40 +0200
Message-ID: <20181128185343.21669-9-leon@kernel.org>
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

Reflect the change of moving SRQ code from mlx5_core to mlx5_ib by
updating function signatures do not require mlx5_core_dev as an input,
because all operations in mlx5_ib are supposed to use mlx5_ib_dev.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c      |   3 +-
 drivers/infiniband/hw/mlx5/srq.c     |  10 +--
 drivers/infiniband/hw/mlx5/srq.h     |  18 ++--
 drivers/infiniband/hw/mlx5/srq_cmd.c | 129 ++++++++++++++-------------
 4 files changed, 83 insertions(+), 77 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index a91580edca92..26ab9041f94a 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -178,8 +178,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 		struct mlx5_core_srq *msrq = NULL;

 		if (qp->ibqp.xrcd) {
-			msrq = mlx5_core_get_srq(dev->mdev,
-						 be32_to_cpu(cqe->srqn));
+			msrq = mlx5_cmd_get_srq(dev, be32_to_cpu(cqe->srqn));
 			srq = to_mibsrq(msrq);
 		} else {
 			srq = to_msrq(qp->ibqp.srq);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 154fd0d3718e..2b184c7f531a 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -297,7 +297,7 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,

 	in.pd = to_mpd(pd)->pdn;
 	in.db_record = srq->db.dma;
-	err = mlx5_core_create_srq(dev->mdev, &srq->msrq, &in);
+	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
 		mlx5_ib_dbg(dev, "create SRQ failed, err %d\n", err);
@@ -321,7 +321,7 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 	return &srq->ibsrq;

 err_core:
-	mlx5_core_destroy_srq(dev->mdev, &srq->msrq);
+	mlx5_cmd_destroy_srq(dev, &srq->msrq);

 err_usr_kern_srq:
 	if (pd->uobject)
@@ -351,7 +351,7 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			return -EINVAL;

 		mutex_lock(&srq->mutex);
-		ret = mlx5_core_arm_srq(dev->mdev, &srq->msrq, attr->srq_limit, 1);
+		ret = mlx5_cmd_arm_srq(dev, &srq->msrq, attr->srq_limit, 1);
 		mutex_unlock(&srq->mutex);

 		if (ret)
@@ -372,7 +372,7 @@ int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 	if (!out)
 		return -ENOMEM;

-	ret = mlx5_core_query_srq(dev->mdev, &srq->msrq, out);
+	ret = mlx5_cmd_query_srq(dev, &srq->msrq, out);
 	if (ret)
 		goto out_box;

@@ -390,7 +390,7 @@ int mlx5_ib_destroy_srq(struct ib_srq *srq)
 	struct mlx5_ib_dev *dev = to_mdev(srq->device);
 	struct mlx5_ib_srq *msrq = to_msrq(srq);

-	mlx5_core_destroy_srq(dev->mdev, &msrq->msrq);
+	mlx5_cmd_destroy_srq(dev, &msrq->msrq);

 	if (srq->uobject) {
 		mlx5_ib_db_unmap_user(to_mucontext(srq->uobject->context), &msrq->db);
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index f23d5de12973..1110aeaa775e 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -35,12 +35,14 @@ struct mlx5_srq_attr {
 	u16 uid;
 };

-int mlx5_core_create_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-			 struct mlx5_srq_attr *in);
-int mlx5_core_destroy_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq);
-int mlx5_core_query_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-			struct mlx5_srq_attr *out);
-int mlx5_core_arm_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-		      u16 lwm, int is_srq);
-struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn);
+struct mlx5_ib_dev;
+
+int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+			struct mlx5_srq_attr *in);
+int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
+int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+		       struct mlx5_srq_attr *out);
+int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+		     u16 lwm, int is_srq);
+struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn);
 #endif /* MLX5_IB_SRQ_H */
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 4a64ad4c9b25..fdb9443f49f0 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cmd.h>
+#include "mlx5_ib.h"
 #include "srq.h"

 static int get_pas_size(struct mlx5_srq_attr *in)
@@ -77,11 +78,14 @@ static void get_srqc(void *srqc, struct mlx5_srq_attr *in)
 	in->db_record	  = MLX5_GET64(srqc, srqc, dbr_addr);
 }

-struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn)
+struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 {
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_srq_table *table;
 	struct mlx5_core_srq *srq;

+	table = &mdev->priv.srq_table;
+
 	spin_lock(&table->lock);

 	srq = radix_tree_lookup(&table->tree, srqn);
@@ -93,7 +97,7 @@ struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn)
 	return srq;
 }

-static int create_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_srq_out)] = {0};
@@ -120,7 +124,7 @@ static int create_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(create_srq_in, create_in, opcode,
 		 MLX5_CMD_OP_CREATE_SRQ);

-	err = mlx5_cmd_exec(dev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -131,8 +135,7 @@ static int create_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int destroy_srq_cmd(struct mlx5_core_dev *dev,
-			   struct mlx5_core_srq *srq)
+static int destroy_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
 	u32 srq_in[MLX5_ST_SZ_DW(destroy_srq_in)] = {0};
 	u32 srq_out[MLX5_ST_SZ_DW(destroy_srq_out)] = {0};
@@ -142,11 +145,11 @@ static int destroy_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_srq_in, srq_in, srqn, srq->srqn);
 	MLX5_SET(destroy_srq_in, srq_in, uid, srq->uid);

-	return mlx5_cmd_exec(dev, srq_in, sizeof(srq_in),
-			     srq_out, sizeof(srq_out));
+	return mlx5_cmd_exec(dev->mdev, srq_in, sizeof(srq_in), srq_out,
+			     sizeof(srq_out));
 }

-static int arm_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int arm_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		       u16 lwm, int is_srq)
 {
 	u32 srq_in[MLX5_ST_SZ_DW(arm_rq_in)] = {0};
@@ -158,11 +161,11 @@ static int arm_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_rq_in, srq_in, lwm,      lwm);
 	MLX5_SET(arm_rq_in, srq_in, uid, srq->uid);

-	return  mlx5_cmd_exec(dev, srq_in, sizeof(srq_in),
-			      srq_out, sizeof(srq_out));
+	return mlx5_cmd_exec(dev->mdev, srq_in, sizeof(srq_in), srq_out,
+			     sizeof(srq_out));
 }

-static int query_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 srq_in[MLX5_ST_SZ_DW(query_srq_in)] = {0};
@@ -177,8 +180,8 @@ static int query_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(query_srq_in, srq_in, opcode,
 		 MLX5_CMD_OP_QUERY_SRQ);
 	MLX5_SET(query_srq_in, srq_in, srqn, srq->srqn);
-	err =  mlx5_cmd_exec(dev, srq_in, sizeof(srq_in),
-			     srq_out, MLX5_ST_SZ_BYTES(query_srq_out));
+	err = mlx5_cmd_exec(dev->mdev, srq_in, sizeof(srq_in), srq_out,
+			    MLX5_ST_SZ_BYTES(query_srq_out));
 	if (err)
 		goto out;

@@ -191,7 +194,7 @@ static int query_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
+static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 			      struct mlx5_core_srq *srq,
 			      struct mlx5_srq_attr *in)
 {
@@ -221,7 +224,7 @@ static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
 		 MLX5_CMD_OP_CREATE_XRC_SRQ);

 	memset(create_out, 0, sizeof(create_out));
-	err = mlx5_cmd_exec(dev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
 			    sizeof(create_out));
 	if (err)
 		goto out;
@@ -233,7 +236,7 @@ static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	return err;
 }

-static int destroy_xrc_srq_cmd(struct mlx5_core_dev *dev,
+static int destroy_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 			       struct mlx5_core_srq *srq)
 {
 	u32 xrcsrq_in[MLX5_ST_SZ_DW(destroy_xrc_srq_in)]   = {0};
@@ -244,12 +247,12 @@ static int destroy_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_xrc_srq_in, xrcsrq_in, xrc_srqn, srq->srqn);
 	MLX5_SET(destroy_xrc_srq_in, xrcsrq_in, uid, srq->uid);

-	return mlx5_cmd_exec(dev, xrcsrq_in, sizeof(xrcsrq_in),
+	return mlx5_cmd_exec(dev->mdev, xrcsrq_in, sizeof(xrcsrq_in),
 			     xrcsrq_out, sizeof(xrcsrq_out));
 }

-static int arm_xrc_srq_cmd(struct mlx5_core_dev *dev,
-			   struct mlx5_core_srq *srq, u16 lwm)
+static int arm_xrc_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+			   u16 lwm)
 {
 	u32 xrcsrq_in[MLX5_ST_SZ_DW(arm_xrc_srq_in)]   = {0};
 	u32 xrcsrq_out[MLX5_ST_SZ_DW(arm_xrc_srq_out)] = {0};
@@ -260,11 +263,11 @@ static int arm_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, lwm,      lwm);
 	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, uid, srq->uid);

-	return  mlx5_cmd_exec(dev, xrcsrq_in, sizeof(xrcsrq_in),
+	return  mlx5_cmd_exec(dev->mdev, xrcsrq_in, sizeof(xrcsrq_in),
 			      xrcsrq_out, sizeof(xrcsrq_out));
 }

-static int query_xrc_srq_cmd(struct mlx5_core_dev *dev,
+static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 			     struct mlx5_core_srq *srq,
 			     struct mlx5_srq_attr *out)
 {
@@ -282,8 +285,8 @@ static int query_xrc_srq_cmd(struct mlx5_core_dev *dev,
 		 MLX5_CMD_OP_QUERY_XRC_SRQ);
 	MLX5_SET(query_xrc_srq_in, xrcsrq_in, xrc_srqn, srq->srqn);

-	err =  mlx5_cmd_exec(dev, xrcsrq_in, sizeof(xrcsrq_in), xrcsrq_out,
-			     MLX5_ST_SZ_BYTES(query_xrc_srq_out));
+	err = mlx5_cmd_exec(dev->mdev, xrcsrq_in, sizeof(xrcsrq_in),
+			    xrcsrq_out, MLX5_ST_SZ_BYTES(query_xrc_srq_out));
 	if (err)
 		goto out;

@@ -298,39 +301,39 @@ static int query_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	return err;
 }

-static int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
+static int mlx5_core_create_rmp(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 				u32 *rmpn)
 {
 	u32 out[MLX5_ST_SZ_DW(create_rmp_out)] = { 0 };
 	int err;

 	MLX5_SET(create_rmp_in, in, opcode, MLX5_CMD_OP_CREATE_RMP);
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
 	if (!err)
 		*rmpn = MLX5_GET(create_rmp_out, out, rmpn);

 	return err;
 }

-static int mlx5_core_modify_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen)
+static int mlx5_core_modify_rmp(struct mlx5_ib_dev *dev, u32 *in, int inlen)
 {
 	u32 out[MLX5_ST_SZ_DW(modify_rmp_out)] = {0};

 	MLX5_SET(modify_rmp_in, in, opcode, MLX5_CMD_OP_MODIFY_RMP);
-	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
 }

-static int mlx5_core_query_rmp(struct mlx5_core_dev *dev, u32 rmpn, u32 *out)
+static int mlx5_core_query_rmp(struct mlx5_ib_dev *dev, u32 rmpn, u32 *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_rmp_in)] = {0};
 	int outlen = MLX5_ST_SZ_BYTES(query_rmp_out);

 	MLX5_SET(query_rmp_in, in, opcode, MLX5_CMD_OP_QUERY_RMP);
 	MLX5_SET(query_rmp_in, in, rmpn,   rmpn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, outlen);
 }

-static int create_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	void *create_in;
@@ -362,8 +365,7 @@ static int create_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int destroy_rmp_cmd(struct mlx5_core_dev *dev,
-			   struct mlx5_core_srq *srq)
+static int destroy_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rmp_in)]   = {};
 	u32 out[MLX5_ST_SZ_DW(destroy_rmp_out)] = {};
@@ -371,11 +373,10 @@ static int destroy_rmp_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_rmp_in, in, opcode, MLX5_CMD_OP_DESTROY_RMP);
 	MLX5_SET(destroy_rmp_in, in, rmpn, srq->srqn);
 	MLX5_SET(destroy_rmp_in, in, uid, srq->uid);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }

-static int arm_rmp_cmd(struct mlx5_core_dev *dev,
-		       struct mlx5_core_srq *srq,
+static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
 	void *in;
@@ -405,7 +406,7 @@ static int arm_rmp_cmd(struct mlx5_core_dev *dev,
 	return err;
 }

-static int query_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 *rmp_out;
@@ -430,7 +431,7 @@ static int query_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int create_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_xrq_out)] = {0};
@@ -465,7 +466,7 @@ static int create_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(xrqc, xrqc, cqn, in->cqn);
 	MLX5_SET(create_xrq_in, create_in, opcode, MLX5_CMD_OP_CREATE_XRQ);
 	MLX5_SET(create_xrq_in, create_in, uid, in->uid);
-	err = mlx5_cmd_exec(dev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -476,7 +477,7 @@ static int create_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int destroy_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_xrq_in)] = {0};
 	u32 out[MLX5_ST_SZ_DW(destroy_xrq_out)] = {0};
@@ -485,10 +486,10 @@ static int destroy_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
 	MLX5_SET(destroy_xrq_in, in, xrqn,   srq->srqn);
 	MLX5_SET(destroy_xrq_in, in, uid, srq->uid);

-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }

-static int arm_xrq_cmd(struct mlx5_core_dev *dev,
+static int arm_xrq_cmd(struct mlx5_ib_dev *dev,
 		       struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
@@ -501,10 +502,10 @@ static int arm_xrq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(arm_rq_in, in, lwm,	    lwm);
 	MLX5_SET(arm_rq_in, in, uid, srq->uid);

-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }

-static int query_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
+static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrq_in)] = {0};
@@ -520,7 +521,7 @@ static int query_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(query_xrq_in, in, opcode, MLX5_CMD_OP_QUERY_XRQ);
 	MLX5_SET(query_xrq_in, in, xrqn, srq->srqn);

-	err = mlx5_cmd_exec(dev, in, sizeof(in), xrq_out, outlen);
+	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), xrq_out, outlen);
 	if (err)
 		goto out;

@@ -543,11 +544,10 @@ static int query_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-static int create_srq_split(struct mlx5_core_dev *dev,
-			    struct mlx5_core_srq *srq,
+static int create_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			    struct mlx5_srq_attr *in)
 {
-	if (!dev->issi)
+	if (!dev->mdev->issi)
 		return create_srq_cmd(dev, srq, in);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
@@ -559,10 +559,9 @@ static int create_srq_split(struct mlx5_core_dev *dev,
 	}
 }

-static int destroy_srq_split(struct mlx5_core_dev *dev,
-			     struct mlx5_core_srq *srq)
+static int destroy_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
-	if (!dev->issi)
+	if (!dev->mdev->issi)
 		return destroy_srq_cmd(dev, srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
@@ -574,11 +573,14 @@ static int destroy_srq_split(struct mlx5_core_dev *dev,
 	}
 }

-int mlx5_core_create_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-			 struct mlx5_srq_attr *in)
+int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+			struct mlx5_srq_attr *in)
 {
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_srq_table *table;
 	int err;
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
+
+	table = &mdev->priv.srq_table;

 	switch (in->type) {
 	case IB_SRQT_XRC:
@@ -612,12 +614,15 @@ int mlx5_core_create_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }

-int mlx5_core_destroy_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
+int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_srq_table *table;
 	struct mlx5_core_srq *tmp;
 	int err;

+	table = &mdev->priv.srq_table;
+
 	spin_lock_irq(&table->lock);
 	tmp = radix_tree_delete(&table->tree, srq->srqn);
 	spin_unlock_irq(&table->lock);
@@ -635,10 +640,10 @@ int mlx5_core_destroy_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
 	return 0;
 }

-int mlx5_core_query_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-			struct mlx5_srq_attr *out)
+int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+		       struct mlx5_srq_attr *out)
 {
-	if (!dev->issi)
+	if (!dev->mdev->issi)
 		return query_srq_cmd(dev, srq, out);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
@@ -650,10 +655,10 @@ int mlx5_core_query_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	}
 }

-int mlx5_core_arm_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
-		      u16 lwm, int is_srq)
+int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+		     u16 lwm, int is_srq)
 {
-	if (!dev->issi)
+	if (!dev->mdev->issi)
 		return arm_srq_cmd(dev, srq, lwm, is_srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
