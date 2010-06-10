From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 15/19 V4] mlx4_core: Adding VEP number in resource
	allocation
Date: Thu, 10 Jun 2010 22:06:45 +0300
Message-ID: <4C1137C5.4050208@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The firmware should be aware of the function a resource is opened on.
The function number is passed in the lower bits of input paramater.
Non multi-function firmware masks these bits.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cmd.c |   58 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index 4cfa407..660d001 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -534,6 +534,32 @@ static int mlx4_RESOURCE_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 	return 0;
 }
 
+static int mlx4_DMA_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox)
+{
+	u64 in_param = inbox ? inbox->dma : vhcr->in_param;
+
+	in_param |= (u64) slave;
+	return mlx4_cmd(dev, in_param, vhcr->in_modifier,
+			vhcr->op_modifier, vhcr->op, MLX4_CMD_TIME_CLASS_C);
+}
+
+static int mlx4_DMA_outbox_wrapper(struct mlx4_dev *dev, int slave,
+				   struct mlx4_vhcr *vhcr,
+				   struct mlx4_cmd_mailbox *inbox,
+				   struct mlx4_cmd_mailbox *outbox)
+{
+	u64 in_param = inbox ? inbox->dma : vhcr->in_param;
+	u64 out_param = outbox ? outbox->dma : vhcr->out_param;
+
+	in_param |= (u64) slave;
+	return mlx4_cmd_box(dev, in_param, out_param,
+			    vhcr->in_modifier, vhcr->op_modifier, vhcr->op,
+			    MLX4_CMD_TIME_CLASS_C);
+}
+
 static struct mlx4_cmd_info {
 	u16 opcode;
 	bool has_inbox;
@@ -608,7 +634,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /*need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_NOP,
@@ -657,7 +683,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL,
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_QUERY_MPT,
@@ -703,10 +729,10 @@ static struct mlx4_cmd_info {
 	{
 		.opcode = MLX4_CMD_HW2SW_EQ,
 		.has_inbox = false,
-		.has_outbox = false,
+		.has_outbox = true,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_outbox_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_QUERY_EQ,
@@ -722,7 +748,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_HW2SW_CQ,
@@ -730,7 +756,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_QUERY_CQ,
@@ -754,7 +780,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_HW2SW_SRQ,
@@ -786,7 +812,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_INIT2RTR_QP,
@@ -794,7 +820,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_RTR2RTS_QP,
@@ -802,7 +828,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_RTS2RTS_QP,
@@ -810,7 +836,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SQERR2RTS_QP,
@@ -818,7 +844,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_2ERR_QP,
@@ -826,7 +852,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_RTS2SQD_QP,
@@ -834,7 +860,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SQD2SQD_QP,
@@ -842,7 +868,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SQD2RTS_QP,
@@ -850,7 +876,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL, /* need verifier */
-		.wrapper = NULL
+		.wrapper = mlx4_DMA_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_2RST_QP,
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
