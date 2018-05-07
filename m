From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 3/6] net/mlx5: Refactor num of blocks in mailbox calculation
Date: Mon,  7 May 2018 16:53:01 -0700
Message-ID: <20180507235304.25085-4-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Get the logic that calculates the number of blocks in a command mailbox
into a dedicated function.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 21cd1703a862..0f7062104ad9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -135,6 +135,14 @@ static struct mlx5_cmd_layout *get_inst(struct mlx5_cmd *cmd, int idx)
 	return cmd->cmd_buf + (idx << cmd->log_stride);
 }
 
+static int mlx5_calc_cmd_blocks(struct mlx5_cmd_msg *msg)
+{
+	int size = msg->len;
+	int blen = size - min_t(int, sizeof(msg->first.data), size);
+
+	return DIV_ROUND_UP(blen, MLX5_CMD_DATA_BLOCK_SIZE);
+}
+
 static u8 xor8_buf(void *buf, size_t offset, int len)
 {
 	u8 *ptr = buf;
@@ -174,10 +182,7 @@ static void calc_block_sig(struct mlx5_cmd_prot_block *block)
 static void calc_chain_sig(struct mlx5_cmd_msg *msg)
 {
 	struct mlx5_cmd_mailbox *next = msg->next;
-	int size = msg->len;
-	int blen = size - min_t(int, sizeof(msg->first.data), size);
-	int n = (blen + MLX5_CMD_DATA_BLOCK_SIZE - 1)
-		/ MLX5_CMD_DATA_BLOCK_SIZE;
+	int n = mlx5_calc_cmd_blocks(msg);
 	int i = 0;
 
 	for (i = 0; i < n && next; i++)  {
@@ -220,12 +225,9 @@ static void free_cmd(struct mlx5_cmd_work_ent *ent)
 static int verify_signature(struct mlx5_cmd_work_ent *ent)
 {
 	struct mlx5_cmd_mailbox *next = ent->out->next;
+	int n = mlx5_calc_cmd_blocks(ent->out);
 	int err;
 	u8 sig;
-	int size = ent->out->len;
-	int blen = size - min_t(int, sizeof(ent->out->first.data), size);
-	int n = (blen + MLX5_CMD_DATA_BLOCK_SIZE - 1)
-		/ MLX5_CMD_DATA_BLOCK_SIZE;
 	int i = 0;
 
 	sig = xor8_buf(ent->lay, 0, sizeof(*ent->lay));
@@ -1137,7 +1139,6 @@ static struct mlx5_cmd_msg *mlx5_alloc_cmd_msg(struct mlx5_core_dev *dev,
 	struct mlx5_cmd_mailbox *tmp, *head = NULL;
 	struct mlx5_cmd_prot_block *block;
 	struct mlx5_cmd_msg *msg;
-	int blen;
 	int err;
 	int n;
 	int i;
@@ -1146,8 +1147,8 @@ static struct mlx5_cmd_msg *mlx5_alloc_cmd_msg(struct mlx5_core_dev *dev,
 	if (!msg)
 		return ERR_PTR(-ENOMEM);
 
-	blen = size - min_t(int, sizeof(msg->first.data), size);
-	n = (blen + MLX5_CMD_DATA_BLOCK_SIZE - 1) / MLX5_CMD_DATA_BLOCK_SIZE;
+	msg->len = size;
+	n = mlx5_calc_cmd_blocks(msg);
 
 	for (i = 0; i < n; i++) {
 		tmp = alloc_cmd_box(dev, flags);
@@ -1165,7 +1166,6 @@ static struct mlx5_cmd_msg *mlx5_alloc_cmd_msg(struct mlx5_core_dev *dev,
 		head = tmp;
 	}
 	msg->next = head;
-	msg->len = size;
 	return msg;
 
 err_alloc:
-- 
2.14.3
