From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC 02/19] net/ice: Create framework for VSI queue context
Date: Tue, 12 Feb 2019 15:43:45 -0600
Message-ID: <20190212214402.23284-3-shiraz.saleem@intel.com>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190212214402.23284-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

This patch introduces a framework to store queue specific information
in VSI queue contexts. Currently VSI queue context (represented by
struct ice_q_ctx) only has q_handle as a member. In future patches,
this structure will be updated to hold queue specific information.

This will be submitted as a patch to the ice driver in the very near
future. It was necessary to make this patch a part of this RFC to
enable functional testing of the i40iw driver.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c  | 177 ++++++++++++++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.h |   9 ++
 drivers/net/ethernet/intel/ice/ice_type.h   |   1 +
 3 files changed, 124 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index a168185..e95bed5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -591,6 +591,94 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 }
 
 /**
+ * ice_alloc_lan_q_ctx - allocate LAN queue contexts for the given VSI and TC
+ * @hw: pointer to the HW struct
+ * @vsi_handle: VSI handle
+ * @tc: TC number
+ * @new_numqs: number of queues
+ */
+static enum ice_status
+ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
+{
+	struct ice_vsi_ctx *vsi_ctx;
+	struct ice_q_ctx *q_ctx;
+
+	vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi_ctx)
+		return ICE_ERR_PARAM;
+	/* allocate LAN queue contexts */
+	if (!vsi_ctx->lan_q_ctx[tc]) {
+		vsi_ctx->lan_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
+						      new_numqs,
+						      sizeof(*q_ctx),
+						      GFP_KERNEL);
+		if (!vsi_ctx->lan_q_ctx[tc])
+			return ICE_ERR_NO_MEMORY;
+		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
+		return 0;
+	}
+	/* num queues are increased, update the queue contexts */
+	if (new_numqs > vsi_ctx->num_lan_q_entries[tc]) {
+		u16 prev_num = vsi_ctx->num_lan_q_entries[tc];
+
+		q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
+				     sizeof(*q_ctx), GFP_KERNEL);
+		if (!q_ctx)
+			return ICE_ERR_NO_MEMORY;
+		memcpy(q_ctx, vsi_ctx->lan_q_ctx[tc],
+		       prev_num * sizeof(*q_ctx));
+		devm_kfree(ice_hw_to_dev(hw), vsi_ctx->lan_q_ctx[tc]);
+		vsi_ctx->lan_q_ctx[tc] = q_ctx;
+		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
+	}
+	return 0;
+}
+
+/**
+ * ice_alloc_rdma_q_ctx - allocate RDMA queue contexts for the given VSI and TC
+ * @hw: pointer to the HW struct
+ * @vsi_handle: VSI handle
+ * @tc: TC number
+ * @new_numqs: number of queues
+ */
+static enum ice_status
+ice_alloc_rdma_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
+{
+	struct ice_vsi_ctx *vsi_ctx;
+	struct ice_q_ctx *q_ctx;
+
+	vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi_ctx)
+		return ICE_ERR_PARAM;
+	/* allocate RDMA queue contexts */
+	if (!vsi_ctx->rdma_q_ctx[tc]) {
+		vsi_ctx->rdma_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
+						       new_numqs,
+						       sizeof(*q_ctx),
+						       GFP_KERNEL);
+		if (!vsi_ctx->rdma_q_ctx[tc])
+			return ICE_ERR_NO_MEMORY;
+		vsi_ctx->num_rdma_q_entries[tc] = new_numqs;
+		return 0;
+	}
+	/* num queues are increased, update the queue contexts */
+	if (new_numqs > vsi_ctx->num_rdma_q_entries[tc]) {
+		u16 prev_num = vsi_ctx->num_rdma_q_entries[tc];
+
+		q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
+				     sizeof(*q_ctx), GFP_KERNEL);
+		if (!q_ctx)
+			return ICE_ERR_NO_MEMORY;
+		memcpy(q_ctx, vsi_ctx->rdma_q_ctx[tc],
+		       prev_num * sizeof(*q_ctx));
+		devm_kfree(ice_hw_to_dev(hw), vsi_ctx->rdma_q_ctx[tc]);
+		vsi_ctx->rdma_q_ctx[tc] = q_ctx;
+		vsi_ctx->num_rdma_q_entries[tc] = new_numqs;
+	}
+	return 0;
+}
+
+/**
  * ice_sched_clear_tx_topo - clears the schduler tree nodes
  * @pi: port information structure
  *
@@ -1295,42 +1383,6 @@ struct ice_sched_node *
 }
 
 /**
- * ice_sched_rm_vsi_child_nodes - remove VSI child nodes from the tree
- * @pi: port information structure
- * @vsi_node: pointer to the VSI node
- * @num_nodes: pointer to the num nodes that needs to be removed per layer
- * @owner: node owner (lan or rdma)
- *
- * This function removes the VSI child nodes from the tree. It gets called for
- * lan and rdma separately.
- */
-static void
-ice_sched_rm_vsi_child_nodes(struct ice_port_info *pi,
-			     struct ice_sched_node *vsi_node, u16 *num_nodes,
-			     u8 owner)
-{
-	struct ice_sched_node *node, *next;
-	u8 i, qgl, vsil;
-	u16 num;
-
-	qgl = ice_sched_get_qgrp_layer(pi->hw);
-	vsil = ice_sched_get_vsi_layer(pi->hw);
-
-	for (i = qgl; i > vsil; i--) {
-		num = num_nodes[i];
-		node = ice_sched_get_first_node(pi->hw, vsi_node, i);
-		while (node && num) {
-			next = node->sibling;
-			if (node->owner == owner && !node->num_children) {
-				ice_free_sched_node(pi, node);
-				num--;
-			}
-			node = next;
-		}
-	}
-}
-
-/**
  * ice_sched_calc_vsi_support_nodes - calculate number of VSI support nodes
  * @hw: pointer to the hw struct
  * @tc_node: pointer to TC node
@@ -1465,7 +1517,6 @@ struct ice_sched_node *
 ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 				 u8 tc, u16 new_numqs, u8 owner)
 {
-	u16 prev_num_nodes[ICE_AQC_TOPO_MAX_LEVEL_NUM] = { 0 };
 	u16 new_num_nodes[ICE_AQC_TOPO_MAX_LEVEL_NUM] = { 0 };
 	struct ice_sched_node *vsi_node;
 	struct ice_sched_node *tc_node;
@@ -1473,7 +1524,6 @@ struct ice_sched_node *
 	enum ice_status status = 0;
 	struct ice_hw *hw = pi->hw;
 	u16 prev_numqs;
-	u8 i;
 
 	tc_node = ice_sched_get_tc_node(pi, tc);
 	if (!tc_node)
@@ -1490,38 +1540,39 @@ struct ice_sched_node *
 	if (owner == ICE_SCHED_NODE_OWNER_LAN)
 		prev_numqs = vsi_ctx->sched.max_lanq[tc];
 	else
-		return ICE_ERR_PARAM;
-
-	/* num queues are not changed */
-	if (prev_numqs == new_numqs)
+		prev_numqs = vsi_ctx->sched.max_rdmaq[tc];
+	/* num queues are not changed or less than the previous number */
+	if (new_numqs <= prev_numqs)
 		return status;
-
-	/* calculate number of nodes based on prev/new number of qs */
-	if (prev_numqs)
-		ice_sched_calc_vsi_child_nodes(hw, prev_numqs, prev_num_nodes);
-
-	if (new_numqs)
-		ice_sched_calc_vsi_child_nodes(hw, new_numqs, new_num_nodes);
-
-	if (prev_numqs > new_numqs) {
-		for (i = 0; i < ICE_AQC_TOPO_MAX_LEVEL_NUM; i++)
-			new_num_nodes[i] = prev_num_nodes[i] - new_num_nodes[i];
-
-		ice_sched_rm_vsi_child_nodes(pi, vsi_node, new_num_nodes,
-					     owner);
+	if (owner == ICE_SCHED_NODE_OWNER_LAN) {
+		status = ice_alloc_lan_q_ctx(hw, vsi_handle, tc, new_numqs);
+		if (status)
+			return status;
 	} else {
-		for (i = 0; i < ICE_AQC_TOPO_MAX_LEVEL_NUM; i++)
-			new_num_nodes[i] -= prev_num_nodes[i];
-
-		status = ice_sched_add_vsi_child_nodes(pi, vsi_handle, tc_node,
-						       new_num_nodes, owner);
+		status = ice_alloc_rdma_q_ctx(hw, vsi_handle, tc, new_numqs);
 		if (status)
 			return status;
 	}
 
-	vsi_ctx->sched.max_lanq[tc] = new_numqs;
+	if (new_numqs)
+		ice_sched_calc_vsi_child_nodes(hw, new_numqs, new_num_nodes);
+	/* Keep the max number of queue configuration all the time. Update the
+	 * tree only if number of queues > previous number of queues. This may
+	 * leave some extra nodes in the tree if number of queues < previous
+	 * number but that wouldn't harm anything. Removing those extra nodes
+	 * may complicate the code if those nodes are part of SRL or
+	 * individually rate limited.
+	 */
+	status = ice_sched_add_vsi_child_nodes(pi, vsi_handle, tc_node,
+					       new_num_nodes, owner);
+	if (status)
+		return status;
+	if (owner == ICE_SCHED_NODE_OWNER_LAN)
+		vsi_ctx->sched.max_lanq[tc] = new_numqs;
+	else
+		vsi_ctx->sched.max_rdmaq[tc] = new_numqs;
 
-	return status;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index d5ef0bd..78040bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -10,6 +10,11 @@
 #define ICE_DFLT_VSI_INVAL 0xff
 #define ICE_VSI_INVAL_ID 0xffff
 
+/* VSI queue context structure */
+struct ice_q_ctx {
+	u16  q_handle;
+};
+
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
 	u16 vsi_num;
@@ -20,6 +25,10 @@ struct ice_vsi_ctx {
 	struct ice_sched_vsi_info sched;
 	u8 alloc_from_pool;
 	u8 vf_num;
+	u16 num_lan_q_entries[ICE_MAX_TRAFFIC_CLASS];
+	struct ice_q_ctx *lan_q_ctx[ICE_MAX_TRAFFIC_CLASS];
+	u16 num_rdma_q_entries[ICE_MAX_TRAFFIC_CLASS];
+	struct ice_q_ctx *rdma_q_ctx[ICE_MAX_TRAFFIC_CLASS];
 };
 
 enum ice_sw_fwd_act_type {
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 0ea4281..6209edc 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -245,6 +245,7 @@ struct ice_sched_vsi_info {
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
 	struct list_head list_entry;
 	u16 max_lanq[ICE_MAX_TRAFFIC_CLASS];
+	u16 max_rdmaq[ICE_MAX_TRAFFIC_CLASS];
 	u16 vsi_id;
 };
 
-- 
1.8.3.1
