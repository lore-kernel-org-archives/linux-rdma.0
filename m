From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC 09/19] RDMA/irdma: Add QoS definitions
Date: Tue, 12 Feb 2019 15:43:52 -0600
Message-ID: <20190212214402.23284-10-shiraz.saleem@intel.com>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190212214402.23284-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add definitions for managing the RDMA HW work scheduler (WS) tree.

A WS node is created via a control QP operation with the bandwidth
allocation, arbitration scheme, and traffic class of the QP specified.
The Qset handle returned associates the QoS parameters for the QP.
The Qset is registered with the LAN and a equivalent node is created
in the LAN packet scheduler tree.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/ws.c | 449 +++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/ws.h |  40 ++++
 2 files changed, 489 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/ws.c
 create mode 100644 drivers/infiniband/hw/irdma/ws.h

diff --git a/drivers/infiniband/hw/irdma/ws.c b/drivers/infiniband/hw/irdma/ws.c
new file mode 100644
index 0000000..f9c0beb
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ws.c
@@ -0,0 +1,449 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+
+#include "ws.h"
+
+/**
+ * irdma_alloc_node - Allocate a WS node and init
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ * @node_type: Type of node, leaf or parent
+ * @parent: parent node pointer
+ */
+static struct irdma_ws_node *irdma_alloc_node(struct irdma_sc_vsi *vsi,
+					      u8 user_pri,
+					      enum irdma_ws_node_type node_type,
+					      struct irdma_ws_node *parent)
+{
+	struct irdma_virt_mem ws_mem;
+	struct irdma_ws_node *node;
+	u16 node_index = 0;
+
+	if (irdma_allocate_virt_mem(vsi->dev->hw, &ws_mem,
+				    sizeof(struct irdma_ws_node)))
+		return NULL;
+
+	if (parent || vsi->vm_vf_type == IRDMA_VF_TYPE) {
+		node_index = irdma_alloc_ws_node_id(vsi->dev);
+		if (node_index == IRDMA_WS_NODE_INVALID) {
+			irdma_free_virt_mem(vsi->dev->hw, &ws_mem);
+			return NULL;
+		}
+	}
+
+	node = (struct irdma_ws_node *)ws_mem.va;
+	node->index = node_index;
+	node->vsi_index = vsi->vsi_idx;
+	INIT_LIST_HEAD(&node->siblings);
+	node->first_child = NULL;
+	if (node_type == WS_NODE_TYPE_LEAF) {
+		node->type_leaf = true;
+		node->traffic_class = vsi->qos[user_pri].traffic_class;
+		node->user_pri = user_pri;
+		node->rel_bw =
+			vsi->qos[user_pri].rel_bw;
+		node->lan_qs_handle =
+			vsi->qos[user_pri].lan_qos_handle;
+		node->prio_type = IRDMA_PRIO_WEIGHTED_RR;
+	} else {
+		node->rel_bw = 1;
+		node->prio_type = IRDMA_PRIO_WEIGHTED_RR;
+	}
+
+	node->parent = parent;
+
+	return node;
+}
+
+/**
+ * irdma_free_node - Free a WS node
+ * @node: Pointer to node to free
+ */
+static void irdma_free_node(struct irdma_sc_vsi *vsi,
+			    struct irdma_ws_node *node)
+{
+	struct irdma_virt_mem ws_mem;
+
+	if (node->index)
+		irdma_free_ws_node_id(vsi->dev, node->index);
+
+	ws_mem.va = node;
+	ws_mem.size = sizeof(struct irdma_ws_node);
+	irdma_free_virt_mem(vsi->dev->hw, &ws_mem);
+}
+
+/**
+ * irdma_ws_cqp_cmd - Post CQP work scheduler node cmd
+ * @vsi: vsi pointer
+ * @node: pointer to node
+ * @cmd: add, remove or modify
+ * @user_pri: User priority for a leaf node
+ */
+static enum irdma_status_code
+irdma_ws_cqp_cmd(struct irdma_sc_vsi *vsi,
+		 struct irdma_ws_node *node,
+		 u8 cmd)
+{
+	struct irdma_ws_node_info node_info = {};
+
+	node_info.id = node->index;
+	node_info.vsi = node->vsi_index;
+	if (node->parent)
+		node_info.parent_id = node->parent->index;
+	else
+		node_info.parent_id = node_info.id;
+
+	node_info.weight = node->rel_bw;
+	node_info.tc = node->traffic_class;
+	node_info.prio_type = node->prio_type;
+	node_info.type_leaf = node->type_leaf;
+	node_info.enable = node->enable;
+	if (irdma_cqp_ws_node_cmd(vsi->dev, cmd, &node_info)) {
+		irdma_debug(vsi->dev, IRDMA_DEBUG_WS, "CQP WS CMD failed\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	if (node->type_leaf && cmd == IRDMA_OP_WS_ADD_NODE) {
+		node->qs_handle = node_info.qs_handle;
+		vsi->qos[node->user_pri].qs_handle = node_info.qs_handle;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_node_from_entry - Given entry, get pointer to ws node struct
+ * @entry: Points to sibling list of a node
+ */
+static struct irdma_ws_node *irdma_node_from_entry(struct list_head *entry)
+{
+	if (entry)
+		return (struct irdma_ws_node *)((char *)entry
+				- offsetof(struct irdma_ws_node, siblings));
+
+	return NULL;
+}
+
+/**
+ * ws_find_node - Find SC WS node based on VSI id or TC
+ * @node: pointer to first node in level corresponding to VSI/TC
+ */
+static struct irdma_ws_node *ws_find_node(struct irdma_ws_node *root,
+					  u16 match_val,
+					  enum irdma_ws_match_type type)
+{
+	struct irdma_ws_node *node = root;
+	struct list_head *entry;
+
+	if (!root)
+		return NULL;
+
+	switch (type) {
+	case WS_MATCH_TYPE_VSI:
+		while (node && node->vsi_index != match_val) {
+			entry = node->siblings.next;
+			node = irdma_node_from_entry(entry);
+			if (node == root)
+				return NULL;
+		}
+		break;
+	case WS_MATCH_TYPE_TC:
+		while (node && node->traffic_class != match_val) {
+			entry = node->siblings.next;
+			node = irdma_node_from_entry(entry);
+			if (node == root)
+				return NULL;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return node;
+}
+
+/**
+ * ws_tree_del_node - Delete node from SW WS tree structure
+ * @node: shared code node pointer
+ */
+static void ws_tree_del_node(struct irdma_ws_node *node)
+{
+	struct irdma_ws_node *parent = node->parent;
+	struct irdma_ws_node *next_entry;
+
+	if (parent) {
+		if (parent->first_child == node && list_empty(&node->siblings)) {
+			parent->first_child = NULL;
+		} else if (parent->first_child == node) {
+			next_entry = irdma_node_from_entry(node->siblings.next);
+			list_del(&node->siblings);
+			parent->first_child = next_entry;
+		} else {
+			list_del(&node->siblings);
+		}
+	}
+}
+
+/**
+ * irdma_tc_in_use - Checks to see if a leaf node is in use
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+static bool irdma_tc_in_use(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&vsi->qos[user_pri].lock, flags);
+	if (!list_empty(&vsi->qos[user_pri].qplist)) {
+		spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+		return true;
+	}
+
+	/* Check if the traffic class associated with the given user priority
+	 * is in use by any other user priority. If so, nothing left to do
+	 */
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		if (vsi->qos[i].traffic_class == vsi->qos[user_pri].traffic_class &&
+		    !list_empty(&vsi->qos[i].qplist)) {
+			spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+			return true;
+		}
+	}
+	spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+
+	return false;
+}
+
+/**
+ * irdma_remove_leaf - Remove leaf node unconditionally
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+static void irdma_remove_leaf(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	struct irdma_ws_node *ws_tree_root, *vsi_node, *tc_node;
+
+	ws_tree_root = vsi->dev->ws_tree_root;
+	if (!ws_tree_root)
+		return;
+
+	vsi_node = ws_find_node(ws_tree_root->first_child, vsi->vsi_idx,
+				WS_MATCH_TYPE_VSI);
+	if (!vsi_node)
+		return;
+
+	tc_node = ws_find_node(vsi_node->first_child,
+			       vsi->qos[user_pri].traffic_class,
+			       WS_MATCH_TYPE_TC);
+	if (!tc_node)
+		return;
+
+	irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_DELETE_NODE);
+	irdma_lan_unregister_qset(vsi, tc_node);
+	ws_tree_del_node(tc_node);
+	irdma_free_node(vsi, tc_node);
+	/* Check if VSI node can be freed */
+	if (!vsi_node->first_child) {
+		irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_DELETE_NODE);
+		ws_tree_del_node(vsi_node);
+		irdma_free_node(vsi, vsi_node);
+		/* Free head node there are no remaining VSI nodes */
+		if (!ws_tree_root->first_child) {
+			irdma_ws_cqp_cmd(vsi, ws_tree_root,
+					 IRDMA_OP_WS_DELETE_NODE);
+			irdma_free_node(vsi, ws_tree_root);
+			vsi->dev->ws_tree_root = NULL;
+		}
+	}
+}
+
+/**
+ * irdma_ws_add - Build work scheduler tree, set RDMA qs_handle
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	struct irdma_ws_node *ws_tree_root;
+	struct irdma_ws_node *vsi_node;
+	struct irdma_ws_node *tc_node;
+	u16 traffic_class;
+	enum irdma_status_code ret = 0;
+	int i;
+
+	mutex_lock(&vsi->dev->ws_mutex);
+	if (vsi->tc_change_pending) {
+		mutex_unlock(&vsi->dev->ws_mutex);
+		return IRDMA_ERR_NOT_READY;
+	}
+
+	ws_tree_root = vsi->dev->ws_tree_root;
+	if (!ws_tree_root) {
+		irdma_debug(vsi->dev, IRDMA_DEBUG_WS, "Creating root node\n");
+		ws_tree_root = irdma_alloc_node(vsi, user_pri,
+						WS_NODE_TYPE_PARENT, NULL);
+		if (!ws_tree_root) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto exit;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, ws_tree_root, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, ws_tree_root);
+			goto exit;
+		}
+
+		vsi->dev->ws_tree_root = ws_tree_root;
+	}
+
+	/* Find a second tier node that matches the VSI */
+	vsi_node = ws_find_node(ws_tree_root->first_child, vsi->vsi_idx,
+				WS_MATCH_TYPE_VSI);
+
+	/* If VSI node doesn't exist, add one */
+	if (!vsi_node) {
+		irdma_debug(vsi->dev, IRDMA_DEBUG_WS,
+			    "Node not found matching VSI %d\n", vsi->vsi_idx);
+		vsi_node = irdma_alloc_node(vsi, user_pri, WS_NODE_TYPE_PARENT,
+					    ws_tree_root);
+		if (!vsi_node) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto vsi_add_err;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, vsi_node);
+			goto vsi_add_err;
+		}
+
+		if (ws_tree_root->first_child)
+			list_add(&vsi_node->siblings,
+				 &ws_tree_root->first_child->siblings);
+		else /* Connect to head node if this is the first VSI node */
+			ws_tree_root->first_child = vsi_node;
+	}
+
+	irdma_debug(vsi->dev, IRDMA_DEBUG_WS,
+		    "Using node %d which represents VSI %d\n",
+		    vsi_node->index, vsi->vsi_idx);
+	traffic_class = vsi->qos[user_pri].traffic_class;
+	tc_node = ws_find_node(vsi_node->first_child, traffic_class,
+			       WS_MATCH_TYPE_TC);
+	if (!tc_node) {
+		/* Add leaf node */
+		irdma_debug(vsi->dev, IRDMA_DEBUG_WS,
+			    "Node not found matching VSI %d and TC %d\n",
+			    vsi->vsi_idx, traffic_class);
+		tc_node = irdma_alloc_node(vsi, user_pri, WS_NODE_TYPE_LEAF,
+					   vsi_node);
+		if (!tc_node) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto leaf_add_err;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, tc_node);
+			goto leaf_add_err;
+		}
+
+		if (vsi_node->first_child)
+			list_add(&tc_node->siblings,
+				 &vsi_node->first_child->siblings);
+		else
+			vsi_node->first_child = tc_node;
+
+		/*
+		 * callback to LAN to update the LAN tree with our node
+		 */
+		ret = irdma_lan_register_qset(vsi, tc_node);
+		if (ret)
+			goto reg_err;
+
+		tc_node->enable = true;
+		ret = irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_MODIFY_NODE);
+		if (ret)
+			goto reg_err;
+	}
+	irdma_debug(vsi->dev, IRDMA_DEBUG_WS,
+		    "Using node %d which represents VSI %d TC %d\n",
+		    tc_node->index, vsi->vsi_idx, traffic_class);
+	/*
+	 * Iterate through other UPs and update the QS handle if they have
+	 * a matching traffic class.
+	 */
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		if (vsi->qos[i].traffic_class == traffic_class) {
+			vsi->qos[i].qs_handle = tc_node->qs_handle;
+			vsi->qos[i].lan_qos_handle = tc_node->lan_qs_handle;
+			vsi->qos[i].l2_sched_node_id = tc_node->l2_sched_node_id;
+		}
+	}
+	goto exit;
+
+leaf_add_err:
+	if (!vsi_node->first_child) {
+		if (irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_DELETE_NODE))
+			goto exit;
+		ws_tree_del_node(vsi_node);
+		irdma_free_node(vsi, vsi_node);
+	}
+
+vsi_add_err:
+	/* Free head node there are no remaining VSI nodes */
+	if (!ws_tree_root->first_child) {
+		irdma_ws_cqp_cmd(vsi, ws_tree_root,
+				 IRDMA_OP_WS_DELETE_NODE);
+		vsi->dev->ws_tree_root = NULL;
+		ws_tree_del_node(ws_tree_root);
+		irdma_free_node(vsi, ws_tree_root);
+	}
+
+exit:
+	mutex_unlock(&vsi->dev->ws_mutex);
+	return ret;
+
+reg_err:
+	mutex_unlock(&vsi->dev->ws_mutex);
+	irdma_ws_remove(vsi, user_pri);
+	return ret;
+}
+
+/**
+ * irdma_ws_remove - Free WS scheduler node, update WS tree
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+void irdma_ws_remove(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	mutex_lock(&vsi->dev->ws_mutex);
+	if (irdma_tc_in_use(vsi, user_pri))
+		goto exit;
+
+	irdma_remove_leaf(vsi, user_pri);
+exit:
+	mutex_unlock(&vsi->dev->ws_mutex);
+}
+
+/**
+ * irdma_ws_reset - Reset entire WS tree
+ * @vsi: vsi pointer
+ */
+void irdma_ws_reset(struct irdma_sc_vsi *vsi)
+{
+	u8 i;
+
+	mutex_lock(&vsi->dev->ws_mutex);
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; ++i)
+		irdma_remove_leaf(vsi, i);
+	mutex_unlock(&vsi->dev->ws_mutex);
+}
diff --git a/drivers/infiniband/hw/irdma/ws.h b/drivers/infiniband/hw/irdma/ws.h
new file mode 100644
index 0000000..fe0474d
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ws.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef IRDMA_WS_H
+#define IRDMA_WS_H
+
+#include "osdep.h"
+
+enum irdma_ws_node_type {
+	WS_NODE_TYPE_PARENT,
+	WS_NODE_TYPE_LEAF,
+};
+
+enum irdma_ws_match_type {
+	WS_MATCH_TYPE_VSI,
+	WS_MATCH_TYPE_TC,
+};
+
+struct irdma_ws_node {
+	struct list_head siblings;
+	struct irdma_ws_node *first_child;
+	struct irdma_ws_node *parent;
+	u64 lan_qs_handle;	  /* opaque handle used by LAN */
+	u32 l2_sched_node_id;
+	u16 index;
+	u16 qs_handle;
+	u16 vsi_index;
+	u8 traffic_class;
+	u8 user_pri;
+	u8 rel_bw;
+	u8 abstraction_layer; /* used for splitting a TC */
+	u8 prio_type;
+	bool type_leaf;
+	bool enable;
+};
+
+enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri);
+void irdma_ws_remove(struct irdma_sc_vsi *vsi, u8 user_pri);
+void irdma_ws_reset(struct irdma_sc_vsi *vsi);
+#endif  /* IRDMA_WS_H */
-- 
1.8.3.1
