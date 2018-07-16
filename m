From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH rdma-next 16/18] RDMA/mlx5: Enable attaching DECAP action to steering flows
Date: Mon, 16 Jul 2018 11:23:03 +0300
Message-ID: <20180716082305.11744-17-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
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
index ecbf9f3e12d8..fc0492b7ad19 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2475,6 +2475,11 @@ static int parse_flow_flow_action(const union ib_flow_spec *ib_spec,
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
