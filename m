From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V3 05/11] net/mlx5: E-Switch, Create a dedicated send to vport rule deletion function
Date: Fri, 29 Dec 2017 01:23:08 +0200
Message-ID: <20171228232314.13678-6-saeedm@mellanox.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171228232314.13678-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

In order for representors to send packets directly to VFs we use an
E-Switch function which insert special rules into the HW. For symmetry
create an E-Switch function that deletes these rules as well.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 19edaa155062..01bf4e3c8afa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -199,7 +199,7 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 		return;
 
 	list_for_each_entry_safe(esw_sq, tmp, &rep->vport_sqs_list, list) {
-		mlx5_del_flow_rules(esw_sq->send_to_vport_rule);
+		mlx5_eswitch_del_send_to_vport_rule(esw_sq->send_to_vport_rule);
 		list_del(&esw_sq->list);
 		kfree(esw_sq);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 21b506fd2b67..9ed401225225 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -225,6 +225,7 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport,
 				    u32 sqn);
+void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule);
 
 struct mlx5_flow_spec;
 struct mlx5_esw_flow_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 90a30c51d92e..121609b823c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -339,6 +339,11 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport, u32 sqn
 	return flow_rule;
 }
 
+void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule)
+{
+	mlx5_del_flow_rules(rule);
+}
+
 static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_act flow_act = {0};
-- 
2.13.0
