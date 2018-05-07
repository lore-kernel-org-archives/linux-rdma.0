From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 4/6] net/mlx5: Fix dump_command mailbox length printed
Date: Mon,  7 May 2018 16:53:02 -0700
Message-ID: <20180507235304.25085-5-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Dump command mailbox length printed was correct only if data_only flag
was set. For the case that data_only flag was clear the offset to stop
printing at was wrong and so the buffer printed was too short.
Changed the print loop to stop according to number of buffers in
mailbox.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 0f7062104ad9..487388aed98f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -722,9 +722,11 @@ static void dump_command(struct mlx5_core_dev *dev,
 	struct mlx5_cmd_msg *msg = input ? ent->in : ent->out;
 	u16 op = MLX5_GET(mbox_in, ent->lay->in, opcode);
 	struct mlx5_cmd_mailbox *next = msg->next;
+	int n = mlx5_calc_cmd_blocks(msg);
 	int data_only;
 	u32 offset = 0;
 	int dump_len;
+	int i;
 
 	data_only = !!(mlx5_core_debug_mask & (1 << MLX5_CMD_DATA));
 
@@ -751,7 +753,7 @@ static void dump_command(struct mlx5_core_dev *dev,
 		offset += sizeof(*ent->lay);
 	}
 
-	while (next && offset < msg->len) {
+	for (i = 0; i < n && next; i++)  {
 		if (data_only) {
 			dump_len = min_t(int, MLX5_CMD_DATA_BLOCK_SIZE, msg->len - offset);
 			dump_buf(next->buf, dump_len, 1, offset);
-- 
2.14.3
