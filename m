From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 24/27] RDMA/mlx5: Refactor DEVX flow creation
Date: Sun, 29 Jul 2018 15:59:02 +0300
Message-ID: <20180729125905.31989-25-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Move struct mlx5_flow_act to be passed from the METHOD entry point,
this will allow to add support for flow action for the DEVX path.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c    |  4 +++-
 drivers/infiniband/hw/mlx5/main.c    | 12 +++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +++-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index a6b4f37a5359..072b8fc7e057 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -44,6 +44,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	struct ib_device *ib_dev, struct ib_uverbs_file *file,
 	struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
 	struct mlx5_ib_flow_handler *flow_handler;
 	struct mlx5_ib_flow_matcher *fs_matcher;
 	void *devx_obj;
@@ -106,7 +107,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 				    MLX5_IB_ATTR_CREATE_FLOW_MATCH_VALUE);
 	fs_matcher = uverbs_attr_get_obj(attrs,
 					 MLX5_IB_ATTR_CREATE_FLOW_MATCHER);
-	flow_handler = mlx5_ib_raw_fs_rule_add(dev, fs_matcher, cmd_in, inlen,
+	flow_handler = mlx5_ib_raw_fs_rule_add(dev, fs_matcher, &flow_act,
+					       cmd_in, inlen,
 					       dest_id, dest_type);
 	if (IS_ERR(flow_handler))
 		return PTR_ERR(flow_handler);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 81780beeb83c..2b2af82dc32e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3729,10 +3729,10 @@ _create_raw_flow_rule(struct mlx5_ib_dev *dev,
 		      struct mlx5_ib_flow_prio *ft_prio,
 		      struct mlx5_flow_destination *dst,
 		      struct mlx5_ib_flow_matcher  *fs_matcher,
+		      struct mlx5_flow_act *flow_act,
 		      void *cmd_in, int inlen)
 {
 	struct mlx5_ib_flow_handler *handler;
-	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
 	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_table *ft = ft_prio->flow_table;
 	int err = 0;
@@ -3751,9 +3751,8 @@ _create_raw_flow_rule(struct mlx5_ib_dev *dev,
 	       fs_matcher->mask_len);
 	spec->match_criteria_enable = fs_matcher->match_criteria_enable;
 
-	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	handler->rule = mlx5_add_flow_rules(ft, spec,
-					    &flow_act, dst, 1);
+					    flow_act, dst, 1);
 
 	if (IS_ERR(handler->rule)) {
 		err = PTR_ERR(handler->rule);
@@ -3815,6 +3814,7 @@ static bool raw_fs_is_multicast(struct mlx5_ib_flow_matcher *fs_matcher,
 struct mlx5_ib_flow_handler *
 mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 			struct mlx5_ib_flow_matcher *fs_matcher,
+			struct mlx5_flow_act *flow_act,
 			void *cmd_in, int inlen, int dest_id,
 			int dest_type)
 {
@@ -3847,13 +3847,15 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 	if (dest_type == MLX5_FLOW_DESTINATION_TYPE_TIR) {
 		dst->type = dest_type;
 		dst->tir_num = dest_id;
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	} else {
 		dst->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM;
 		dst->ft_num = dest_id;
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
-	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher, cmd_in,
-					inlen);
+	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher, flow_act,
+					cmd_in, inlen);
 
 	if (IS_ERR(handler)) {
 		err = PTR_ERR(handler);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 97fa894deafc..76f1c178cef7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -39,6 +39,7 @@
 #include <rdma/ib_smi.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cq.h>
+#include <linux/mlx5/fs.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/srq.h>
 #include <linux/types.h>
@@ -1249,7 +1250,8 @@ void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
 struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
 	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
-	void *cmd_in, int inlen, int dest_id, int dest_type);
+	struct mlx5_flow_act *flow_act, void *cmd_in, int inlen,
+	int dest_id, int dest_type);
 bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id, int *dest_type);
 int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
 void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction);
-- 
2.14.4
