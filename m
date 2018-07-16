From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 18/18] RDMA/mlx5: Enable attaching packet reformat action to steering flows
Date: Mon, 16 Jul 2018 11:23:05 +0300
Message-ID: <20180716082305.11744-19-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Any matching rules will be mutated based on the packet reformat context
which is attached to that given flow rule.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc0492b7ad19..c0e902bf1de6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2480,6 +2480,13 @@ static int parse_flow_flow_action(const union ib_flow_spec *ib_spec,
 			action->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 			return 0;
 		}
+		if (maction->flow_action_raw.sub_type ==
+		    MLX5_IB_FLOW_ACTION_PACKET_REFORMAT) {
+			action->action |=
+				MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID;
+			action->packet_reformat_id = maction->flow_action_raw.action_id;
+			return 0;
+		}
 		/* fall through */
 	default:
 		return -EOPNOTSUPP;
