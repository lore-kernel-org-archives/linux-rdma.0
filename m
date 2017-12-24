From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next V2 05/11] net/mlx5: E-Switch, Create a dedicated send to vport rule deletion function
Date: Sun, 24 Dec 2017 15:45:41 +0200
Message-ID: <20171224134547.600-6-saeedm@mellanox.com>
References: <20171224134547.600-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134547.600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order for representors to send packets directly to VFs we use an
E-Switch function which insert special rules into the HW. For symmetry
create an E-Switch function that deletes these rules as well.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
