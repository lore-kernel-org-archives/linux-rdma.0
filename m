From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 5/7] net/mlx5: Set uid as part of SRQ commands
Date: Thu, 20 Sep 2018 21:35:24 +0300
Message-ID: <20180920183526.13995-6-leon@kernel.org>
References: <20180920183526.13995-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920183526.13995-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of SRQ commands so that the firmware can manage the
SRQ object in a secured way.

That will enable using an SRQ that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 30 ++++++++++++++++++++++++---
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 22 ++++++++++----------
 include/linux/mlx5/srq.h                      |  1 +
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 23cc337a96c9..5c519615fb1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -166,6 +166,7 @@ static int create_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	if (!create_in)
 		return -ENOMEM;

+	MLX5_SET(create_srq_in, create_in, uid, in->uid);
 	srqc = MLX5_ADDR_OF(create_srq_in, create_in, srq_context_entry);
 	pas = MLX5_ADDR_OF(create_srq_in, create_in, pas);

@@ -178,8 +179,10 @@ static int create_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	err = mlx5_cmd_exec(dev, create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
-	if (!err)
+	if (!err) {
 		srq->srqn = MLX5_GET(create_srq_out, create_out, srqn);
+		srq->uid = in->uid;
+	}

 	return err;
 }
@@ -193,6 +196,7 @@ static int destroy_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_srq_in, srq_in, opcode,
 		 MLX5_CMD_OP_DESTROY_SRQ);
 	MLX5_SET(destroy_srq_in, srq_in, srqn, srq->srqn);
+	MLX5_SET(destroy_srq_in, srq_in, uid, srq->uid);

 	return mlx5_cmd_exec(dev, srq_in, sizeof(srq_in),
 			     srq_out, sizeof(srq_out));
@@ -208,6 +212,7 @@ static int arm_srq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_rq_in, srq_in, op_mod, MLX5_ARM_RQ_IN_OP_MOD_SRQ);
 	MLX5_SET(arm_rq_in, srq_in, srq_number, srq->srqn);
 	MLX5_SET(arm_rq_in, srq_in, lwm,      lwm);
+	MLX5_SET(arm_rq_in, srq_in, uid, srq->uid);

 	return  mlx5_cmd_exec(dev, srq_in, sizeof(srq_in),
 			      srq_out, sizeof(srq_out));
@@ -260,6 +265,7 @@ static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	if (!create_in)
 		return -ENOMEM;

+	MLX5_SET(create_xrc_srq_in, create_in, uid, in->uid);
 	xrc_srqc = MLX5_ADDR_OF(create_xrc_srq_in, create_in,
 				xrc_srq_context_entry);
 	pas	 = MLX5_ADDR_OF(create_xrc_srq_in, create_in, pas);
@@ -277,6 +283,7 @@ static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
 		goto out;

 	srq->srqn = MLX5_GET(create_xrc_srq_out, create_out, xrc_srqn);
+	srq->uid = in->uid;
 out:
 	kvfree(create_in);
 	return err;
@@ -291,6 +298,7 @@ static int destroy_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_xrc_srq_in, xrcsrq_in, opcode,
 		 MLX5_CMD_OP_DESTROY_XRC_SRQ);
 	MLX5_SET(destroy_xrc_srq_in, xrcsrq_in, xrc_srqn, srq->srqn);
+	MLX5_SET(destroy_xrc_srq_in, xrcsrq_in, uid, srq->uid);

 	return mlx5_cmd_exec(dev, xrcsrq_in, sizeof(xrcsrq_in),
 			     xrcsrq_out, sizeof(xrcsrq_out));
@@ -306,6 +314,7 @@ static int arm_xrc_srq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, op_mod,   MLX5_ARM_XRC_SRQ_IN_OP_MOD_XRC_SRQ);
 	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, xrc_srqn, srq->srqn);
 	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, lwm,      lwm);
+	MLX5_SET(arm_xrc_srq_in, xrcsrq_in, uid, srq->uid);

 	return  mlx5_cmd_exec(dev, xrcsrq_in, sizeof(xrcsrq_in),
 			      xrcsrq_out, sizeof(xrcsrq_out));
@@ -365,10 +374,13 @@ static int create_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	wq = MLX5_ADDR_OF(rmpc, rmpc, wq);

 	MLX5_SET(rmpc, rmpc, state, MLX5_RMPC_STATE_RDY);
+	MLX5_SET(create_rmp_in, create_in, uid, in->uid);
 	set_wq(wq, in);
 	memcpy(MLX5_ADDR_OF(rmpc, rmpc, wq.pas), in->pas, pas_size);

 	err = mlx5_core_create_rmp(dev, create_in, inlen, &srq->srqn);
+	if (!err)
+		srq->uid = in->uid;

 	kvfree(create_in);
 	return err;
@@ -377,7 +389,13 @@ static int create_rmp_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 static int destroy_rmp_cmd(struct mlx5_core_dev *dev,
 			   struct mlx5_core_srq *srq)
 {
-	return mlx5_core_destroy_rmp(dev, srq->srqn);
+	u32 in[MLX5_ST_SZ_DW(destroy_rmp_in)]   = {};
+	u32 out[MLX5_ST_SZ_DW(destroy_rmp_out)] = {};
+
+	MLX5_SET(destroy_rmp_in, in, opcode, MLX5_CMD_OP_DESTROY_RMP);
+	MLX5_SET(destroy_rmp_in, in, rmpn, srq->srqn);
+	MLX5_SET(destroy_rmp_in, in, uid, srq->uid);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }

 static int arm_rmp_cmd(struct mlx5_core_dev *dev,
@@ -400,6 +418,7 @@ static int arm_rmp_cmd(struct mlx5_core_dev *dev,

 	MLX5_SET(modify_rmp_in, in,	 rmp_state, MLX5_RMPC_STATE_RDY);
 	MLX5_SET(modify_rmp_in, in,	 rmpn,      srq->srqn);
+	MLX5_SET(modify_rmp_in, in, uid, srq->uid);
 	MLX5_SET(wq,		wq,	 lwm,	    lwm);
 	MLX5_SET(rmp_bitmask,	bitmask, lwm,	    1);
 	MLX5_SET(rmpc, rmpc, state, MLX5_RMPC_STATE_RDY);
@@ -469,11 +488,14 @@ static int create_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(xrqc, xrqc, user_index, in->user_index);
 	MLX5_SET(xrqc, xrqc, cqn, in->cqn);
 	MLX5_SET(create_xrq_in, create_in, opcode, MLX5_CMD_OP_CREATE_XRQ);
+	MLX5_SET(create_xrq_in, create_in, uid, in->uid);
 	err = mlx5_cmd_exec(dev, create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
-	if (!err)
+	if (!err) {
 		srq->srqn = MLX5_GET(create_xrq_out, create_out, xrqn);
+		srq->uid = in->uid;
+	}

 	return err;
 }
@@ -485,6 +507,7 @@ static int destroy_xrq_cmd(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)

 	MLX5_SET(destroy_xrq_in, in, opcode, MLX5_CMD_OP_DESTROY_XRQ);
 	MLX5_SET(destroy_xrq_in, in, xrqn,   srq->srqn);
+	MLX5_SET(destroy_xrq_in, in, uid, srq->uid);

 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
@@ -500,6 +523,7 @@ static int arm_xrq_cmd(struct mlx5_core_dev *dev,
 	MLX5_SET(arm_rq_in, in, op_mod,     MLX5_ARM_RQ_IN_OP_MOD_XRQ);
 	MLX5_SET(arm_rq_in, in, srq_number, srq->srqn);
 	MLX5_SET(arm_rq_in, in, lwm,	    lwm);
+	MLX5_SET(arm_rq_in, in, uid, srq->uid);

 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 89caed98ef0b..e2fa59f98ff8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -474,6 +474,7 @@ struct mlx5_core_srq {

 	atomic_t		refcount;
 	struct completion	free;
+	u16		uid;
 };

 struct mlx5_eq_table {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8151488f6570..5a2f0b02483a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5525,7 +5525,7 @@ struct mlx5_ifc_rmp_bitmask_bits {

 struct mlx5_ifc_modify_rmp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5987,7 +5987,7 @@ struct mlx5_ifc_destroy_xrq_out_bits {

 struct mlx5_ifc_destroy_xrq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6009,7 +6009,7 @@ struct mlx5_ifc_destroy_xrc_srq_out_bits {

 struct mlx5_ifc_destroy_xrc_srq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6075,7 +6075,7 @@ struct mlx5_ifc_destroy_srq_out_bits {

 struct mlx5_ifc_destroy_srq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6209,7 +6209,7 @@ struct mlx5_ifc_destroy_rmp_out_bits {

 struct mlx5_ifc_destroy_rmp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6642,7 +6642,7 @@ struct mlx5_ifc_create_xrq_out_bits {

 struct mlx5_ifc_create_xrq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6666,7 +6666,7 @@ struct mlx5_ifc_create_xrc_srq_out_bits {

 struct mlx5_ifc_create_xrc_srq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6742,7 +6742,7 @@ struct mlx5_ifc_create_srq_out_bits {

 struct mlx5_ifc_create_srq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6872,7 +6872,7 @@ struct mlx5_ifc_create_rmp_out_bits {

 struct mlx5_ifc_create_rmp_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7273,7 +7273,7 @@ enum {

 struct mlx5_ifc_arm_xrc_srq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7301,7 +7301,7 @@ enum {

 struct mlx5_ifc_arm_rq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
diff --git a/include/linux/mlx5/srq.h b/include/linux/mlx5/srq.h
index 24ff23e27c8a..1b1f3c20c6a3 100644
--- a/include/linux/mlx5/srq.h
+++ b/include/linux/mlx5/srq.h
@@ -61,6 +61,7 @@ struct mlx5_srq_attr {
 	u32 tm_next_tag;
 	u32 tm_hw_phase_cnt;
 	u32 tm_sw_phase_cnt;
+	u16 uid;
 };

 struct mlx5_core_dev;
