From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 14/27] RDMA/mlx5: Enable attaching modify header to steering flows
Date: Sun, 29 Jul 2018 15:58:52 +0300
Message-ID: <20180729125905.31989-15-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

When creating a flow steering rule, allow the user to attach a modify
header action.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b56ac6614be6..473c8e5d21a5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2466,6 +2466,14 @@ static int parse_flow_flow_action(const union ib_flow_spec *ib_spec,
 			MLX5_FLOW_CONTEXT_ACTION_ENCRYPT :
 			MLX5_FLOW_CONTEXT_ACTION_DECRYPT;
 		return 0;
+	case IB_FLOW_ACTION_UNSPECIFIED:
+		if (maction->flow_action_raw.sub_type ==
+		    MLX5_IB_FLOW_ACTION_MODIFY_HEADER) {
+			action->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+			action->modify_id = maction->flow_action_raw.action_id;
+			return 0;
+		}
+		/* fall through */
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.14.4
