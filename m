From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 23/27] RDMA/mlx5: Refactor flow action parsing to be more generic
Date: Sun, 29 Jul 2018 15:59:01 +0300
Message-ID: <20180729125905.31989-24-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Make the parsing of flow actions more generic so it could be used by
DEVX create flow.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 13 +++++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 +++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0af0bdc5804b..81780beeb83c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2452,17 +2452,16 @@ static int check_mpls_supp_fields(u32 field_support, const __be32 *set_mask)
 		   offsetof(typeof(filter), field) -\
 		   sizeof(filter.field))
 
-static int parse_flow_flow_action(const union ib_flow_spec *ib_spec,
-				  const struct ib_flow_attr *flow_attr,
-				  struct mlx5_flow_act *action)
+int parse_flow_flow_action(struct mlx5_ib_flow_action *maction,
+			   bool is_egress,
+			   struct mlx5_flow_act *action)
 {
-	struct mlx5_ib_flow_action *maction = to_mflow_act(ib_spec->action.act);
 
 	switch (maction->ib_action.type) {
 	case IB_FLOW_ACTION_ESP:
 		/* Currently only AES_GCM keymat is supported by the driver */
 		action->esp_id = (uintptr_t)maction->esp_aes_gcm.ctx;
-		action->action |= flow_attr->flags & IB_FLOW_ATTR_FLAGS_EGRESS ?
+		action->action |= is_egress ?
 			MLX5_FLOW_CONTEXT_ACTION_ENCRYPT :
 			MLX5_FLOW_CONTEXT_ACTION_DECRYPT;
 		return 0;
@@ -2822,7 +2821,9 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 		action->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 		break;
 	case IB_FLOW_SPEC_ACTION_HANDLE:
-		ret = parse_flow_flow_action(ib_spec, flow_attr, action);
+		ret = parse_flow_flow_action(to_mflow_act(ib_spec->action.act),
+					     flow_attr->flags & IB_FLOW_ATTR_FLAGS_EGRESS,
+					     action);
 		if (ret)
 			return ret;
 		break;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bb7a902a347f..97fa894deafc 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -870,6 +870,9 @@ to_mcounters(struct ib_counters *ibcntrs)
 	return container_of(ibcntrs, struct mlx5_ib_mcounters, ibcntrs);
 }
 
+int parse_flow_flow_action(struct mlx5_ib_flow_action *maction,
+			   bool is_egress,
+			   struct mlx5_flow_act *action);
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
-- 
2.14.4
