From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 18/27] RDMA/mlx5: Enable attaching DECAP action to steering flows
Date: Sun, 29 Jul 2018 15:58:56 +0300
Message-ID: <20180729125905.31989-19-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Any matching flow will be stripped of it's VXLAN tunnel, only the inner
L2 onward is left.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d826d7b21c2e..9c42a1059590 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2473,6 +2473,11 @@ static int parse_flow_flow_action(const union ib_flow_spec *ib_spec,
 			action->modify_id = maction->flow_action_raw.action_id;
 			return 0;
 		}
+		if (maction->flow_action_raw.sub_type ==
+		    MLX5_IB_FLOW_ACTION_DECAP) {
+			action->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+			return 0;
+		}
 		/* fall through */
 	default:
 		return -EOPNOTSUPP;
-- 
2.14.4
