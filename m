From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 6/8] IB/mlx5: Add support for multi underlay QP
Date: Thu, 17 Aug 2017 15:52:33 +0300
Message-ID: <20170817125235.5107-7-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set underlay QPN as part of flow rule when it's applicable.

There is one root flow table in the NIC RX namespace and all the
underlay QPs steer the traffic to this flow table.
In order to prevent QP to get traffic which is not target to its
underlay QP, we need to set the underlay QP number as part of
the steering matching.

Note:
When multicast traffic is sent the QPN filtering is done by the firmware
as some early step. Adding the QPN match on the flow table entry is
wrong as by that time the target QPN holds the multicast address (e.g.
FF(s)) and it won't match.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 49 +++++++++++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc.h     |  8 +++++--
 2 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 544b0ae5d8dc..438663356982 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2134,7 +2134,7 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
  * it won't fall into the multicast flow steering table and this rule
  * could steal other multicast packets.
  */
-static bool flow_is_multicast_only(struct ib_flow_attr *ib_attr)
+static bool flow_is_multicast_only(const struct ib_flow_attr *ib_attr)
 {
 	union ib_flow_spec *flow_spec;
 
@@ -2346,10 +2346,31 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	return err ? ERR_PTR(err) : prio;
 }
 
-static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
-						     struct mlx5_ib_flow_prio *ft_prio,
-						     const struct ib_flow_attr *flow_attr,
-						     struct mlx5_flow_destination *dst)
+static void set_underlay_qp(struct mlx5_ib_dev *dev,
+			    struct mlx5_flow_spec *spec,
+			    u32 underlay_qpn)
+{
+	void *misc_params_c = MLX5_ADDR_OF(fte_match_param,
+					   spec->match_criteria,
+					   misc_parameters);
+	void *misc_params_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+					   misc_parameters);
+
+	if (underlay_qpn &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+				      ft_field_support.bth_dst_qp)) {
+		MLX5_SET(fte_match_set_misc,
+			 misc_params_v, bth_dst_qp, underlay_qpn);
+		MLX5_SET(fte_match_set_misc,
+			 misc_params_c, bth_dst_qp, 0xffffff);
+	}
+}
+
+static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
+						      struct mlx5_ib_flow_prio *ft_prio,
+						      const struct ib_flow_attr *flow_attr,
+						      struct mlx5_flow_destination *dst,
+						      u32 underlay_qpn)
 {
 	struct mlx5_flow_table	*ft = ft_prio->flow_table;
 	struct mlx5_ib_flow_handler *handler;
@@ -2385,6 +2406,9 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 		ib_flow += ((union ib_flow_spec *)ib_flow)->size;
 	}
 
+	if (!flow_is_multicast_only(flow_attr))
+		set_underlay_qp(dev, spec, underlay_qpn);
+
 	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
 	if (is_drop) {
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
@@ -2424,6 +2448,14 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	return err ? ERR_PTR(err) : handler;
 }
 
+static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
+						     struct mlx5_ib_flow_prio *ft_prio,
+						     const struct ib_flow_attr *flow_attr,
+						     struct mlx5_flow_destination *dst)
+{
+	return _create_flow_rule(dev, ft_prio, flow_attr, dst, 0);
+}
+
 static struct mlx5_ib_flow_handler *create_dont_trap_rule(struct mlx5_ib_dev *dev,
 							  struct mlx5_ib_flow_prio *ft_prio,
 							  struct ib_flow_attr *flow_attr,
@@ -2560,6 +2592,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	struct mlx5_ib_flow_prio *ft_prio_tx = NULL;
 	struct mlx5_ib_flow_prio *ft_prio;
 	int err;
+	int underlay_qpn;
 
 	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
 		return ERR_PTR(-ENOMEM);
@@ -2600,8 +2633,10 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 			handler = create_dont_trap_rule(dev, ft_prio,
 							flow_attr, dst);
 		} else {
-			handler = create_flow_rule(dev, ft_prio, flow_attr,
-						   dst);
+			underlay_qpn = (mqp->flags & MLX5_IB_QP_UNDERLAY) ?
+					mqp->underlay_qpn : 0;
+			handler = _create_flow_rule(dev, ft_prio, flow_attr,
+						    dst, underlay_qpn);
 		}
 	} else if (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8d62c108dd80..640313da25c7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -295,8 +295,10 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         inner_tcp_dport[0x1];
 	u8         inner_tcp_flags[0x1];
 	u8         reserved_at_37[0x9];
+	u8         reserved_at_40[0x1a];
+	u8         bth_dst_qp[0x1];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_5b[0x25];
 };
 
 struct mlx5_ifc_flow_table_prop_layout_bits {
@@ -432,7 +434,9 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 	u8         reserved_at_100[0xc];
 	u8         inner_ipv6_flow_label[0x14];
 
-	u8         reserved_at_120[0xe0];
+	u8         reserved_at_120[0x28];
+	u8         bth_dst_qp[0x18];
+	u8         reserved_at_160[0xa0];
 };
 
 struct mlx5_ifc_cmd_pas_bits {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
