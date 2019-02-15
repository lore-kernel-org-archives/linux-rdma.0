From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC v1 03/19] net/ice: Add support for ice peer devices and drivers
Date: Fri, 15 Feb 2019 11:10:50 -0600
Message-ID: <20190215171107.6464-4-shiraz.saleem@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The E800 series of Ethernet devices has multiple hardware blocks, of
which RDMA is one. The RDMA block isn't interfaced directly to PCI
or any other bus. The RDMA driver (irdma) thus depends on the ice
driver to provide access to the RDMA hardware block.

The ice driver first creates a pseudo bus and then creates and attaches
a new device to the pseudo bus using device_register(). This new device
is referred to as a "peer device" and the associated driver (i.e. irdma)
is a "peer driver" to ice. Once the peer driver loads, it can call
ice driver functions exposed to it via struct ice_ops. Similarly, ice can
call peer driver functions exposed to it via struct ice_peer_ops.

This whole mechanism of creating peer devices and registering peer
drivers, and subsequent interaction between the two is referred to as
Inter-Driver Communication (IDC).

For the purposes of this RFC, this patch is being submitted as a
monolothic patch. It will be broken up into multiple patches for
the final submission.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile          |    1 +
 drivers/net/ethernet/intel/ice/ice.h             |   14 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |   32 +
 drivers/net/ethernet/intel/ice/ice_common.c      |  189 +++
 drivers/net/ethernet/intel/ice/ice_common.h      |    9 +
 drivers/net/ethernet/intel/ice/ice_idc.c         | 1527 ++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.h         |  402 ++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h     |   99 ++
 drivers/net/ethernet/intel/ice/ice_lib.c         |   24 +
 drivers/net/ethernet/intel/ice/ice_lib.h         |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c        |  143 +-
 drivers/net/ethernet/intel/ice/ice_switch.c      |   23 +
 drivers/net/ethernet/intel/ice/ice_switch.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_type.h        |    2 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |   25 -
 15 files changed, 2465 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index e5d6f68..62a8e91 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -15,5 +15,6 @@ ice-y := ice_main.o	\
 	 ice_sched.o	\
 	 ice_lib.o	\
 	 ice_txrx.o	\
+	 ice_idc.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a385575..790881c4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -36,6 +36,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 
@@ -64,6 +65,7 @@
 #define ICE_MAX_SMALL_RSS_QS	8
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 #define ICE_MAX_VF_COUNT	256
@@ -243,6 +245,7 @@ struct ice_vsi {
 	u16 alloc_rxq;			 /* Allocated Rx queues */
 	u16 num_rxq;			 /* Used Rx queues */
 	u16 num_desc;
+	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 } ____cacheline_internodealigned_in_smp;
 
@@ -267,6 +270,7 @@ struct ice_q_vector {
 enum ice_pf_flags {
 	ICE_FLAG_MSIX_ENA,
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_IWARP_ENA,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
 	ICE_FLAG_SRIOV_CAPABLE,
@@ -302,6 +306,10 @@ struct ice_pf {
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	u32 msg_enable;
+	/* Total number of MSIX vectors reserved for base driver */
+	u32 num_rdma_msix;
+	u32 rdma_base_vector;
+	struct ice_peer_dev *rdma_peer;
 	u32 hw_csum_rx_error;
 	u32 sw_oicr_idx;	/* Other interrupt cause SW vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
@@ -330,9 +338,13 @@ struct ice_pf {
 };
 
 struct ice_netdev_priv {
+	struct idc_srv_provider prov_callbacks;
 	struct ice_vsi *vsi;
 };
 
+extern struct bus_type ice_peer_bus;
+extern struct ida ice_peer_index_ida;
+
 /**
  * ice_irq_dynamic_ena - Enable default interrupt generation settings
  * @hw: pointer to hw struct
@@ -370,7 +382,9 @@ static inline void ice_vsi_set_tc_cfg(struct ice_vsi *vsi)
 int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_peer_devices(struct ice_pf *pf);
 void ice_napi_del(struct ice_vsi *vsi);
 
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index fcdcd80..aa01239 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1226,6 +1226,36 @@ struct ice_aqc_dis_txq {
 	struct ice_aqc_dis_txq_item qgrps[1];
 };
 
+/* Add Tx RDMA Queue Set (indirect 0x0C33) */
+struct ice_aqc_add_rdma_qset {
+	u8 num_qset_grps;
+	u8 reserved[7];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* This is the descriptor of each qset entry for the Add Tx RDMA Queue Set
+ * command (0x0C33). Only used within struct ice_aqc_add_rdma_qset.
+ */
+struct ice_aqc_add_tx_rdma_qset_entry {
+	__le16 tx_qset_id;
+	u8 rsvd[2];
+	__le32 qset_teid;
+	struct ice_aqc_txsched_elem info;
+};
+
+/* The format of the command buffer for Add Tx RDMA Queue Set(0x0C33)
+ * is an array of the following structs. Please note that the length of
+ * each struct ice_aqc_add_rdma_qset is variable due to the variable
+ * number of queues in each group!
+ */
+struct ice_aqc_add_rdma_qset_data {
+	__le32 parent_teid;
+	__le16 num_qsets;
+	u8 rsvd[2];
+	struct ice_aqc_add_tx_rdma_qset_entry rdma_qsets[1];
+};
+
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -1353,6 +1383,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
+		struct ice_aqc_add_rdma_qset add_rdma_qset;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
@@ -1459,6 +1490,7 @@ enum ice_adminq_opc {
 	/* TX queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* debug commands */
 	ice_aqc_opc_fw_logging				= 0xFF09,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4c1d35d..16a712c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2381,6 +2381,59 @@ enum ice_status
 	return ice_aq_send_cmd(hw, &desc, qg_list, buf_size, cd);
 }
 
+/**
+ * ice_aq_add_rdma_qsets
+ * @hw: pointer to the hardware structure
+ * @num_qset_grps: Number of RDMA Qset groups
+ * @qset_list: list of qset groups to be added
+ * @buf_size: size of buffer for indirect command
+ * @cd: pointer to command details structure or NULL
+ *
+ * Add Tx RDMA Qsets (0x0C33)
+ */
+static enum ice_status
+ice_aq_add_rdma_qsets(struct ice_hw *hw, u8 num_qset_grps,
+		      struct ice_aqc_add_rdma_qset_data *qset_list,
+		      u16 buf_size, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_add_rdma_qset_data *list;
+	u16 i, sum_header_size, sum_q_size = 0;
+	struct ice_aqc_add_rdma_qset *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.add_rdma_qset;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_add_rdma_qset);
+
+	if (!qset_list)
+		return ICE_ERR_PARAM;
+
+	if (num_qset_grps > ICE_LAN_TXQ_MAX_QGRPS)
+		return ICE_ERR_PARAM;
+
+	sum_header_size = num_qset_grps *
+		(sizeof(*qset_list) - sizeof(*qset_list->rdma_qsets));
+
+	list = qset_list;
+	for (i = 0; i < num_qset_grps; i++) {
+		struct ice_aqc_add_tx_rdma_qset_entry *qset = list->rdma_qsets;
+		u16 num_qsets = le16_to_cpu(list->num_qsets);
+
+		sum_q_size += num_qsets * sizeof(*qset);
+		list = (struct ice_aqc_add_rdma_qset_data *)
+			(qset + num_qsets);
+	}
+
+	if (buf_size != (sum_header_size + sum_q_size))
+		return ICE_ERR_PARAM;
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd->num_qset_grps = num_qset_grps;
+
+	return ice_aq_send_cmd(hw, &desc, qset_list, buf_size, cd);
+}
+
 /* End of FW Admin Queue command wrappers */
 
 /**
@@ -2792,6 +2845,142 @@ enum ice_status
 }
 
 /**
+ * ice_cfg_vsi_rdma - configure the VSI RDMA queues
+ * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ * @tc_bitmap: TC bitmap
+ * @max_rdmaqs: max RDMA queues array per TC
+ *
+ * This function adds/updates the VSI RDMA queues per TC.
+ */
+enum ice_status
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
+		 u16 *max_rdmaqs)
+{
+	return ice_cfg_vsi_qs(pi, vsi_handle, tc_bitmap, max_rdmaqs,
+			      ICE_SCHED_NODE_OWNER_RDMA);
+}
+
+/**
+ * ice_ena_vsi_rdma_qset
+ * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ * @tc: TC number
+ * @rdma_qset: pointer to RDMA qset
+ * @num_qsets: number of RDMA qsets
+ * @qset_teid: pointer to qset node teids
+ *
+ * This function adds RDMA qset
+ */
+enum ice_status
+ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid)
+{
+	struct ice_aqc_txsched_elem_data node = { 0 };
+	struct ice_aqc_add_rdma_qset_data *buf;
+	struct ice_sched_node *parent;
+	enum ice_status status;
+	struct ice_hw *hw;
+	u16 buf_size;
+	u8 i;
+
+	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
+		return ICE_ERR_CFG;
+	hw = pi->hw;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	buf_size = sizeof(*buf) + sizeof(*buf->rdma_qsets) * (num_qsets - 1);
+	buf = devm_kzalloc(ice_hw_to_dev(hw), buf_size, GFP_KERNEL);
+	if (!buf)
+		return ICE_ERR_NO_MEMORY;
+	mutex_lock(&pi->sched_lock);
+
+	parent = ice_sched_get_free_qparent(pi, vsi_handle, tc,
+					    ICE_SCHED_NODE_OWNER_RDMA);
+	if (!parent) {
+		status = ICE_ERR_PARAM;
+		goto rdma_error_exit;
+	}
+	buf->parent_teid = parent->info.node_teid;
+	node.parent_teid = parent->info.node_teid;
+
+	buf->num_qsets = cpu_to_le16(num_qsets);
+	for (i = 0; i < num_qsets; i++) {
+		buf->rdma_qsets[i].tx_qset_id = cpu_to_le16(rdma_qset[i]);
+		buf->rdma_qsets[i].info.valid_sections =
+						ICE_AQC_ELEM_VALID_GENERIC;
+	}
+	status = ice_aq_add_rdma_qsets(hw, 1, buf, buf_size, NULL);
+	if (status) {
+		ice_debug(hw, ICE_DBG_RDMA, "add RDMA qset failed\n");
+		goto rdma_error_exit;
+	}
+	node.data.elem_type = ICE_AQC_ELEM_TYPE_LEAF;
+	for (i = 0; i < num_qsets; i++) {
+		node.node_teid = buf->rdma_qsets[i].qset_teid;
+		status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1,
+					    &node);
+		if (status)
+			break;
+		qset_teid[i] = le32_to_cpu(node.node_teid);
+	}
+rdma_error_exit:
+	mutex_unlock(&pi->sched_lock);
+	devm_kfree(ice_hw_to_dev(hw), buf);
+	return status;
+}
+
+/**
+ * ice_dis_vsi_rdma_qset - free RMDA resources
+ * @pi: port_info struct
+ * @count: number of RDMA qsets to free
+ * @qset_teid: TEID of qset node
+ * @q_id: list of queue IDs being disabled
+ */
+enum ice_status
+ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
+		      u16 *q_id)
+{
+	struct ice_aqc_dis_txq_item qg_list;
+	enum ice_status status = 0;
+	u16 qg_size;
+	int i;
+
+	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
+		return ICE_ERR_CFG;
+
+	qg_size = sizeof(qg_list);
+
+	mutex_lock(&pi->sched_lock);
+
+	for (i = 0; i < count; i++) {
+		struct ice_sched_node *node;
+
+		node = ice_sched_find_node_by_teid(pi->root, qset_teid[i]);
+		if (!node)
+			continue;
+
+		qg_list.parent_teid = node->info.parent_teid;
+		qg_list.num_qs = 1;
+		qg_list.q_id[0] =
+			cpu_to_le16(q_id[i] |
+				    ICE_AQC_Q_DIS_BUF_ELEM_TYPE_RDMA_QSET);
+
+		status = ice_aq_dis_lan_txq(pi->hw, 1, &qg_list, qg_size,
+					    ICE_NO_RESET, 0, NULL);
+		if (status)
+			break;
+
+		ice_free_sched_node(pi, node);
+	}
+
+	mutex_unlock(&pi->sched_lock);
+	return status;
+}
+
+/**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the hw struct
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index cf760c2..c436376 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -86,6 +86,15 @@ enum ice_status
 ice_aq_set_link_restart_an(struct ice_port_info *pi, bool ena_link,
 			   struct ice_sq_cd *cd);
 enum ice_status
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
+		 u16 *max_rdmaqs);
+enum ice_status
+ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid);
+enum ice_status
+ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
+		      u16 *q_id);
+enum ice_status
 ice_dis_vsi_txq(struct ice_port_info *pi, u8 num_queues, u16 *q_ids,
 		u32 *q_teids, enum ice_disq_rst_src rst_src, u16 vmvf_num,
 		struct ice_sq_cd *cmd_details);
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 0000000..42f4c14
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,1527 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+
+DEFINE_IDA(ice_peer_index_ida);
+DEFINE_MUTEX(ice_peer_drv_mutex); /* lock for accessing list of peer drivers */
+LIST_HEAD(ice_peer_drv_list);
+
+#define ICE_PEER_PCI_RES_LEN (BIT_ULL(18) - 1)
+#define ICE_PEER_SW_RES_START 0x02D00000
+#define ICE_PEER_AE_RES_START (ICE_PEER_SW_RES_START | BIT_ULL(18))
+#define ICE_PEER_INLINE_CRYPTO_RES_START (ICE_PEER_SW_RES_START | BIT_ULL(19))
+#define ICE_PEER_AE_NUM_MSIX 2
+#define ICE_PEER_SW_NUM_MSIX 2
+#define ICE_PEER_IPSEC_NUM_MSIX 2
+
+/**
+ * ice_verify_peer - verify peer device it is legit
+ * @dev: ptr to device
+ *
+ * This function verified 'dev' if it is legit (means is it one of the peer
+ * device whose bus matches with the bus exposed by this driver
+ */
+static bool ice_verify_peer(struct device *dev)
+{
+	return dev->bus == &ice_peer_bus;
+}
+
+/**
+ * ice_peer_state_change - manage state machine for peer
+ * @peer_dev: pointer to peer's configuration
+ * @new_state: the state requested to transition into
+ *
+ * This function handles all state transitions for peer devices.
+ * The state machine is as follows:
+ *
+ *     +<------------------------------------------------------+
+ *					 +<----------+	       +
+ *					 +	     +	       +
+ *    INIT  -->  PROBE  --> PROBED --> OPENED --> CLOSED --> REMOVED
+ *     +	  +			 +	     +
+ *     +----------+		      PREP_RST	     +
+ *					 +	     +
+ *				      PREPPED	     +
+ *					 +---------->+
+ */
+static void
+ice_peer_state_change(struct ice_peer_dev_int *peer_dev, long new_state)
+{
+	switch (new_state) {
+	case ICE_PEER_DEV_STATE_INIT:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBE,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			pr_info("state transition from _PROBE to _INIT\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			pr_info("state transition from _REMOVED to _INIT\n");
+		} else {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			pr_info("state set to _INIT\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PROBE:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_INIT,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBE, peer_dev->state);
+			pr_info("state transition from _INIT to _PROBE\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PROBED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBE,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			pr_info("state transition from _PROBE to _PROBED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev->state);
+			pr_info("state transition from _PROBED to _OPENED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev->state);
+			pr_info("state transition from _CLOSED to _OPENED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREP_RST:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev->state);
+			pr_info("state transition from _OPENED to _PREP_RST\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREPPED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev->state);
+			pr_info("state transition _PREP_RST to _PREPPED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			pr_info("state transition from _OPENED to _CLOSED\n");
+		}
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREPPED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			pr_info("state transition from _PREPPED to _CLOSED\n");
+		}
+		/* NOTE - up to peer to handle this situation correctly */
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			pr_warn("WARN: Peer state from PREP_RST to _CLOSED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_REMOVED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state) ||
+		    test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev->state);
+			pr_info("state from _OPENED/_CLOSED to _REMOVED\n");
+			/* Clear registration for events when peer removed */
+			bitmap_zero(peer_dev->events, ICE_PEER_DEV_STATE_NBITS);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * ice_peer_close - close a peer device
+ * @dev: device to close
+ * @data: pointer to opaque data
+ *
+ * This function will also set the state bit for the peer to CLOSED. This
+ * function is meant to be called from a bus_for_each_dev().
+ */
+int ice_peer_close(struct device *dev, void *data)
+{
+	enum ice_close_reason reason = *(enum ice_close_reason *)(data);
+	struct ice_peer_dev *peer_dev = dev_to_ice_peer(dev);
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+	int i;
+
+	/* return 0 so bus_for_each_device will continue closing other peers */
+	if (!peer_dev)
+		return 0;
+	if (!peer_dev->pdev)
+		return 0;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return 0;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!pf)
+		return 0;
+
+	if (test_bit(__ICE_DOWN, pf->state) ||
+	    test_bit(__ICE_SUSPENDED, pf->state) ||
+	    test_bit(__ICE_NEEDS_RESTART, pf->state))
+		return 0;
+
+	/* no peer driver or it's already closed, nothing to do */
+	if (!dev->driver ||
+	    test_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state))
+		return 0;
+
+	/* Set the peer state to CLOSED */
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSED);
+
+	for (i = 0; i < ICE_EVENT_NBITS; i++)
+		bitmap_zero(peer_dev_int->current_events[i].type,
+			    ICE_EVENT_NBITS);
+
+	if (peer_dev->peer_ops && peer_dev->peer_ops->close)
+		peer_dev->peer_ops->close(peer_dev, reason);
+
+	return 0;
+}
+
+/**
+ * ice_bus_match - check for peer match
+ * @dev: pointer to device struct for peer
+ * @drv: pointer to device driver struct for peer
+ *
+ * This function returns > zero in case it found a supported device,
+ * and zero for an unsupported device.
+ */
+static int ice_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct ice_peer_dev *peer_dev = dev_to_ice_peer(dev);
+	struct ice_peer_drv *peer_drv = drv_to_ice_peer(drv);
+
+	/* Make sure peer device and peer driver's vendor and device_id
+	 * matches. If matches, success, otherwise failure
+	 */
+	if (peer_dev->dev_id.vendor == peer_drv->dev_id.vendor &&
+	    peer_dev->dev_id.device == peer_drv->dev_id.device)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * ice_bus_probe - bus probe function
+ * @dev: ptr to peer device
+ *
+ * This function is invoked by OS bus_infrastructure if bus_match function
+ * returns success (1). It performs basic initialization and delays remainder
+ * of initialization (including calling peer driver's probe), which is handled
+ * by service_task. It sets correct device STATE.
+ */
+static int ice_bus_probe(struct device *dev)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv *peer_drv;
+	struct ice_peer_dev *peer_dev;
+
+	if (!dev->driver) {
+		/* no peer driver registered */
+		return 0;
+	}
+
+	if (!ice_verify_peer(dev)) {
+		/* since it is not one of our peer device, cannot trust
+		 * 'data', hence prefer to not use dev_* for err.
+		 */
+		pr_err("%s: failed to verify peer dev %s\n", __func__,
+		       dev->driver->name ? dev->driver->name : "");
+		return 0;
+	}
+
+	peer_drv = drv_to_ice_peer(dev->driver);
+	if (!peer_drv)
+		return 0;
+
+	peer_dev = dev_to_ice_peer(dev);
+	if (!peer_dev)
+		return 0;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return -EINVAL;
+
+	switch (peer_drv->dev_id.device) {
+	case ICE_PEER_RDMA_DEV:
+		break;
+	default:
+		pr_err("unsupported device ID %u\n", peer_drv->dev_id.device);
+		return 0;
+	}
+
+	/* Clear state bitmap on (re)registering devices */
+	bitmap_zero(peer_dev_int->state, ICE_PEER_DEV_STATE_NBITS);
+
+	/* For now , just mark the state of peer device and handle rest of the
+	 * initialization in service_task and then call peer driver "probe"
+	 */
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT);
+
+	return 0;
+}
+
+/**
+ * ice_bus_remove - bus remove function
+ * @dev: ptr to peer device
+ *
+ * This function is invoked as a result of driver_unregister being invoked from
+ * ice_unreg_peer_driver function. This function in turn calls
+ * peer_driver's "close" and then "remove" function.
+ */
+static int ice_bus_remove(struct device *dev)
+{
+	enum ice_close_reason reason = ICE_REASON_PEER_DRV_UNREG;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv *peer_drv;
+	struct ice_peer_dev *peer_dev;
+	struct ice_pf *pf;
+	int i;
+
+	/* no peer driver registered */
+	if (!dev->driver)
+		return 0;
+
+	if (!ice_verify_peer(dev)) {
+		/* since it is not one of our peer device, cannot trust
+		 * 'data', hence prefer to not use dev_* for err.
+		 */
+		pr_err("%s: failed to verify peer dev %s\n", __func__,
+		       dev->driver->name ? dev->driver->name : "");
+		return 0;
+	}
+
+	peer_drv = drv_to_ice_peer(dev->driver);
+	if (!peer_drv)
+		return 0;
+
+	peer_dev = dev_to_ice_peer(dev);
+	if (!peer_dev)
+		return 0;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return 0;
+	/* What action we take here depends on where the peer is in the
+	 * state machine. The return value for ice_bus_remove is largely
+	 * ignored by the kernel, so we need to make the best choice based
+	 * only on what we know about the peer.
+	 */
+
+	/* peer already removed */
+	if (test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state))
+		return 0;
+
+	/* check for reset in progress before proceeding */
+	pf = pci_get_drvdata(peer_dev->pdev);
+	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
+		if (!ice_is_reset_in_progress(pf->state))
+			break;
+		msleep(100);
+	}
+
+	/* peer still in init - nothing done yet */
+	if (test_bit(ICE_PEER_DEV_STATE_INIT, peer_dev_int->state))
+		goto exit_setstate;
+
+	/* is there an active function call out to peer */
+	if (test_bit(ICE_PEER_DEV_STATE_PROBE, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev_int->state))
+		for (i = 0; i < ICE_IDC_MAX_STATE_WAIT; i++) {
+			if (!test_bit(ICE_PEER_DEV_STATE_PROBE,
+				      peer_dev_int->state) &&
+			    !test_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				      peer_dev_int->state))
+				break;
+			msleep(100);
+		}
+
+	/* probe finished but not open yet */
+	if (test_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev_int->state))
+		goto exit_remove;
+
+	/* is peer stuck in probe or in any intermediate state
+	 * no sense in calling any other API entries
+	 */
+	if (test_bit(ICE_PEER_DEV_STATE_PROBE, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev_int->state))
+		goto exit_setstate;
+
+	/* is peer prepped for reset or in nominal open state */
+	if (test_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev_int->state))
+		goto exit_close;
+
+	/* peer is closed */
+	if (test_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev_int->state))
+		goto exit_remove;
+
+	/* peer in unknown state */
+	goto exit_setstate;
+
+exit_close:
+	ice_peer_close(dev, &reason);
+exit_remove:
+	if (peer_drv->remove)
+		peer_drv->remove(peer_dev);
+exit_setstate:
+	pr_info("Setting peer state to _REMOVED for peer device %s\n",
+		dev->driver->name ? dev->driver->name : "");
+	bitmap_zero(peer_dev_int->state, ICE_PEER_DEV_STATE_NBITS);
+	set_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state);
+	peer_dev->peer_ops = NULL;
+
+	return 0;
+}
+
+struct bus_type ice_peer_bus = {
+	.name = "ice_pseudo_bus",
+	.match = ice_bus_match,
+	.probe = ice_bus_probe,
+	.remove = ice_bus_remove,
+};
+
+/**
+ * ice_validate_peer_dev - validate peer device state
+ * @peer: ptr to peer device
+ *
+ * This helper function checks if pf in a minimal state and if the peer device
+ * is valid. This should be called before engaging in peer operations.
+ */
+static int ice_validate_peer_dev(struct ice_peer_dev *peer)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+
+	if (!peer)
+		return -EINVAL;
+
+	if (!peer->pdev)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer->pdev);
+	if (!pf)
+		return -EINVAL;
+
+	peer_dev_int = peer_to_ice_dev_int(peer);
+	if (!peer_dev_int)
+		return -EINVAL;
+
+	if (test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * ice_close_peer_for_reset - queue work to close peer for reset
+ * @dev: pointer peer dev struct
+ * @data: pointer to opaque data used for reset type
+ */
+int ice_close_peer_for_reset(struct device *dev, void *data)
+{
+	enum ice_reset_req reset = *(enum ice_reset_req *)data;
+	struct ice_peer_dev *peer_dev = dev_to_ice_peer(dev);
+	struct ice_peer_dev_int *peer_dev_int;
+
+	if (!peer_dev || !peer_dev->pdev)
+		return 0;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return 0;
+
+	switch (reset) {
+	case ICE_RESET_GLOBR:
+		peer_dev_int->rst_type = ICE_REASON_GLOBR_REQ;
+		break;
+	case ICE_RESET_CORER:
+		peer_dev_int->rst_type = ICE_REASON_CORER_REQ;
+		break;
+	case ICE_RESET_PFR:
+		peer_dev_int->rst_type = ICE_REASON_PFR_REQ;
+		break;
+	default:
+		/* reset type is invalid */
+		return 1;
+	}
+	queue_work(peer_dev_int->ice_peer_wq, &peer_dev_int->peer_close_task);
+	return 0;
+}
+
+/**
+ * ice_check_peer_drv_for_events - check peer_drv for events to report
+ * @peer_dev: peer device to report to
+ */
+static void ice_check_peer_drv_for_events(struct ice_peer_dev *peer_dev)
+{
+	struct ice_peer_drv *peer_drv = drv_to_ice_peer(peer_dev->dev.driver);
+	const struct ice_peer_ops *p_ops = peer_dev->peer_ops;
+	struct ice_peer_drv_int *peer_drv_int;
+	struct ice_peer_dev_int *peer_dev_int;
+	int i;
+
+	peer_drv_int = peer_to_ice_drv_int(peer_drv);
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_drv_int || !peer_dev_int)
+		return;
+
+	for_each_set_bit(i, peer_dev_int->events, ICE_EVENT_NBITS)
+		if (!bitmap_empty(peer_drv_int->current_events[i].type,
+				  ICE_EVENT_NBITS))
+			p_ops->event_handler(peer_dev,
+					     &peer_drv_int->current_events[i]);
+}
+
+/**
+ * ice_check_peer_for_events - check peer_devs for events new peer reg'd for
+ * @dev: peer to check for events
+ * @data: ptr to opaque data, to be used for the peer struct that opened
+ *
+ * This function is to be called when a peer device is opened.
+ *
+ * Since a new peer opening would have missed any events that would
+ * have happened before its opening, we need to walk the peers and see
+ * if any of them have events that the new peer cares about
+ *
+ * This function is meant to be called by a device_for_each_child.
+ */
+static int ice_check_peer_for_events(struct device *dev, void *data)
+{
+	struct ice_peer_dev *new_peer = (struct ice_peer_dev *)data;
+	struct ice_peer_dev *src_peer = dev_to_ice_peer(dev);
+	const struct ice_peer_ops *p_ops = new_peer->peer_ops;
+	struct ice_peer_dev_int *new_peer_int, *src_peer_int;
+	int i;
+
+	if (ice_validate_peer_dev(src_peer))
+		return 0;
+
+	new_peer_int = peer_to_ice_dev_int(new_peer);
+	src_peer_int = peer_to_ice_dev_int(src_peer);
+
+	if (!new_peer_int || !src_peer_int)
+		return 0;
+
+	for_each_set_bit(i, new_peer_int->events, ICE_EVENT_NBITS)
+		if (!bitmap_empty(src_peer_int->current_events[i].type,
+				  ICE_EVENT_NBITS) &&
+		    new_peer->index != src_peer->index)
+			p_ops->event_handler(new_peer,
+					     &src_peer_int->current_events[i]);
+
+	return 0;
+}
+
+/**
+ * ice_finish_init_peer_device - complete peer device initialization
+ * @dev: ptr to peer device
+ * @data: ptr to opaque data
+ *
+ * This function completes remaining initialization of peer_devices and
+ * triggers peer driver's probe (aka open)
+ */
+int ice_finish_init_peer_device(struct device *dev, void __always_unused *data)
+{
+	struct ice_port_info *port_info = NULL;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv *peer_drv;
+	struct ice_peer_dev *peer_dev;
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+	int ret;
+
+	/* unable to verify peer device or no peer driver registered */
+	if (!dev->driver)
+		return 0;
+
+	peer_drv = drv_to_ice_peer(dev->driver);
+	if (!peer_drv)
+		return 0;
+
+	peer_dev = dev_to_ice_peer(dev);
+	/* is it OK to proceed with peer_dev, state check? */
+	ret = ice_validate_peer_dev(peer_dev);
+	if (ret)
+		return ret;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return 0;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!pf->hw.port_info) {
+		dev_warn(&pf->pdev->dev, "pf specific port_info is NULL\n");
+		return 0;
+	}
+
+	peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+	port_info = pf->hw.port_info;
+	vsi = pf->vsi[0];
+	peer_dev->pf_vsi_num = vsi->vsi_num;
+	peer_dev->netdev = vsi->netdev;
+	peer_dev->initial_mtu = vsi->netdev->mtu;
+	ether_addr_copy(peer_dev->lan_addr, port_info->mac.lan_addr);
+
+	/* Call the probe only if peer_dev is in _INIT  state */
+	if (test_bit(ICE_PEER_DEV_STATE_INIT, peer_dev_int->state)) {
+		/* Mark the state as _PROBE */
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_PROBE);
+
+		/* Initiate peer driver probe/open */
+		ret = peer_drv->probe(peer_dev);
+		if (ret) {
+			dev_err(&pf->pdev->dev,
+				"probe failed for peer device (%s), err %d\n",
+				dev->driver->name ? dev->driver->name : "",
+				ret);
+			ice_peer_state_change(peer_dev_int,
+					      ICE_PEER_DEV_STATE_INIT);
+			return ret;
+		}
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_PROBED);
+	}
+
+	if (!peer_dev->peer_ops) {
+		dev_err(&pf->pdev->dev,
+			"peer_ops not defined on peer dev (%s)\n",
+			dev->driver->name ? dev->driver->name : "");
+		return 0;
+	}
+
+	if (!peer_dev->peer_ops->open) {
+		dev_err(&pf->pdev->dev,
+			"peer_ops:open not defined on peer dev (%s)\n",
+			dev->driver->name ? dev->driver->name : "");
+		return 0;
+	}
+
+	if (!peer_dev->peer_ops->close) {
+		dev_err(&pf->pdev->dev,
+			"peer_ops:close not defined on peer dev (%s)\n",
+			dev->driver->name ? dev->driver->name : "");
+		return 0;
+	}
+
+	/* Peer driver expected to set driver_id during registration */
+	if (!peer_drv->driver_id) {
+		dev_err(&pf->pdev->dev,
+			"Peer driver (%s) did not set driver_id\n",
+			dev->driver->name);
+		return 0;
+	}
+
+	if ((test_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev_int->state)) &&
+	    ice_pf_state_is_nominal(pf)) {
+		if (!test_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev_int->state)) {
+			peer_dev->peer_ops->open(peer_dev);
+			ice_peer_state_change(peer_dev_int,
+					      ICE_PEER_DEV_STATE_OPENED);
+			ret = bus_for_each_dev(&ice_peer_bus, NULL, peer_dev,
+					       ice_check_peer_for_events);
+			ice_check_peer_drv_for_events(peer_dev);
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * ice_unreg_peer_device - unregister specified device
+ * @dev: ptr to peer device
+ * @data: ptr to opaque data
+ *
+ * This function invokes device unregistration, removes ID associated with
+ * the specified device.
+ */
+int ice_unreg_peer_device(struct device *dev, void __always_unused *data)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	/* This is the function invoked from ice_remove
+	 * code-path, it eventually comes from device_for_each_child
+	 * No reason to prohibit calling device_unregister because this is the
+	 * last chance to trigger cleanup of devices by unregistering them
+	 * form bus, Actual cleanup of resources such as memory for peer_dev
+	 * is cleaned up from "dev.release function".
+	 */
+	device_unregister(dev);
+
+	peer_dev_int = peer_to_ice_dev_int(dev_to_ice_peer(dev));
+	if (!peer_dev_int)
+		return 0;
+
+	if (peer_dev_int->ice_peer_wq) {
+		if (peer_dev_int->peer_prep_task.func)
+			cancel_work_sync(&peer_dev_int->peer_prep_task);
+
+		if (peer_dev_int->peer_close_task.func)
+			cancel_work_sync(&peer_dev_int->peer_close_task);
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	}
+
+	/* Cleanup the allocated ID for this peer device */
+	ida_simple_remove(&ice_peer_index_ida, peer_dev_int->peer_dev.index);
+
+	return 0;
+}
+
+/**
+ * ice_unroll_peer - destroy peers and peer_wq in case of error
+ * @dev: ptr to peer device
+ * @data: ptr to opaque data
+ *
+ * This function releases resources in the event of a failure in creating
+ * peer devices or their individual work_queues. Meant to be called from
+ * a bus_for_each_device invocation
+ */
+int ice_unroll_peer(struct device *dev, void __always_unused *data)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	peer_dev_int = peer_to_ice_dev_int(dev_to_ice_peer(dev));
+
+	if (!peer_dev_int)
+		return 0;
+	if (peer_dev_int->ice_peer_wq)
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	devm_kfree(dev->parent, peer_dev_int);
+
+	return 0;
+}
+
+/* static initialization of device IDs for different peer devices */
+static const struct ice_peer_device_id peer_device_ids[] = {
+	{.vendor = PCI_VENDOR_ID_INTEL,
+	 .device = ICE_PEER_RDMA_DEV},
+};
+
+/**
+ * ice_peer_dev_release - Release peer device object
+ * @dev: ptr to device object
+ *
+ * This function is invoked from device_unregister codepath. If peer
+ * device doesn't have 'release' function, WARN is trigger due to
+ * 'release' function being NULL. This function to release device
+ * specific resources and release peer device object memory.
+ */
+static void ice_peer_dev_release(struct device *dev)
+{
+	struct ice_peer_dev *peer_dev = dev_to_ice_peer(dev);
+	struct ice_peer_dev_int *peer_dev_int;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return;
+	devm_kfree(dev->parent, peer_dev_int);
+}
+
+/**
+ * ice_find_vsi - Find the VSI from VSI ID
+ * @pf: The PF pointer to search in
+ * @vsi_num: The VSI ID to search for
+ */
+static struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
+{
+	int i;
+
+	ice_for_each_vsi(pf, i)
+		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
+			return  pf->vsi[i];
+	return NULL;
+}
+
+/**
+ * ice_peer_alloc_rdma_qsets - Allocate Leaf Nodes for RDMA Qset
+ * @peer_dev: peer that is requesting the Leaf Nodes
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates Leaf Nodes for given RDMA Qset resources
+ * for the peer device.
+ */
+static int
+ice_peer_alloc_rdma_qsets(struct ice_peer_dev *peer_dev, struct ice_res *res,
+			  int __maybe_unused partial_acceptable)
+{
+	struct ice_pf *pf = pci_get_drvdata(peer_dev->pdev);
+	u16 max_rdmaqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
+	struct ice_rdma_qset_params *qset;
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	u32 qset_teid;
+	int i;
+
+	if (res->cnt_req != 1)
+		return -EINVAL;
+
+	qset = &res->res[0].res.qsets;
+	if (qset->tc != 0 || qset->vsi_id != peer_dev->pf_vsi_num)
+		return -EINVAL;
+
+	/* Find the VSI struct */
+	vsi = ice_find_vsi(pf, qset->vsi_id);
+	if (!vsi)
+		return -EINVAL;
+
+	/* configure VSI nodes based on no. of RDMA qsets and TC's */
+	for (i = 0; i < ICE_MAX_TRAFFIC_CLASS; i++)
+		max_rdmaqs[i] = 1;
+
+	status = ice_cfg_vsi_rdma(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				  max_rdmaqs);
+	if (status) {
+		dev_info(&pf->pdev->dev, "Failed VSI RDMA qset config\n");
+		return -EINVAL;
+	}
+
+	status = ice_ena_vsi_rdma_qset(vsi->port_info, vsi->idx, qset->tc,
+				       &qset->qs_handle, res->cnt_req,
+				       &qset_teid);
+	if (status)
+		return -EINVAL;
+
+	vsi->qset_handle[qset->tc] = qset->qs_handle;
+	qset->teid = qset_teid;
+
+	return 0;
+}
+
+/**
+ * ice_peer_free_rdma_qsets - Free leaf nodes for RDMA Qset
+ * @peer_dev: peer that requested qsets to be freed
+ * @res: Resource to be freed
+ */
+static int
+ice_peer_free_rdma_qsets(struct ice_peer_dev *peer_dev, struct ice_res *res)
+{
+	struct ice_pf *pf = pci_get_drvdata(peer_dev->pdev);
+	struct ice_rdma_qset_params *qset;
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	int count;
+	u16 q_id;
+
+	qset = &res->res[0].res.qsets;
+
+	vsi = ice_find_vsi(pf, qset->vsi_id);
+	if (!vsi)
+		return -EINVAL;
+
+	count = res->res_allocated;
+	if (count > 1)
+		return -EINVAL;
+
+	q_id = qset->qs_handle;
+
+	status = ice_dis_vsi_rdma_qset(vsi->port_info, count, &qset->teid,
+				       &q_id);
+	if (status)
+		return -EINVAL;
+
+	vsi->qset_handle[qset->tc] = 0;
+
+	return 0;
+}
+
+/**
+ * ice_peer_alloc_res - Allocate requested resources for peer device
+ * @peer_dev: peer that is requesting resources
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates requested resources for the peer device.
+ */
+static int
+ice_peer_alloc_res(struct ice_peer_dev *peer_dev, struct ice_res *res,
+		   int partial_acceptable)
+{
+	struct ice_pf *pf;
+	int ret;
+
+	ret = ice_validate_peer_dev(peer_dev);
+	if (ret)
+		return ret;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!ice_pf_state_is_nominal(pf))
+		return -EBUSY;
+
+	switch (res->res_type) {
+	case ICE_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_alloc_rdma_qsets(peer_dev, res,
+						partial_acceptable);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_peer_free_res - Free given resources
+ * @peer_dev: peer that is requesting freeing of resources
+ * @res: Resources to be freed
+ *
+ * Free/Release resources allocated to given peer device.
+ */
+static int
+ice_peer_free_res(struct ice_peer_dev *peer_dev, struct ice_res *res)
+{
+	int ret;
+
+	ret = ice_validate_peer_dev(peer_dev);
+	if (ret)
+		return ret;
+
+	switch (res->res_type) {
+	case ICE_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_free_rdma_qsets(peer_dev, res);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_peer_reg_for_notif - register a peer to receive specific notifications
+ * @peer_dev: peer that is registering for event notifications
+ * @events: mask of event types peer is registering for
+ */
+static void
+ice_peer_reg_for_notif(struct ice_peer_dev *peer_dev, struct ice_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return;
+
+	bitmap_or(peer_dev_int->events, peer_dev_int->events, events->type,
+		  ICE_EVENT_NBITS);
+
+	/* Check to see if any events happened previous to peer registering */
+	bus_for_each_dev(&ice_peer_bus, NULL, peer_dev,
+			 ice_check_peer_for_events);
+	ice_check_peer_drv_for_events(peer_dev);
+}
+
+/**
+ * ice_peer_unreg_for_notif - unreg a peer from receiving certain notifications
+ * @peer_dev: peer that is unregistering from event notifications
+ * @events: mask of event types peer is unregistering for
+ */
+static void
+ice_peer_unreg_for_notif(struct ice_peer_dev *peer_dev,
+			 struct ice_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return;
+
+	bitmap_andnot(peer_dev_int->events, peer_dev_int->events, events->type,
+		      ICE_EVENT_NBITS);
+}
+
+/**
+ * ice_peer_check_for_reg - check to see if any peers are reg'd for event
+ * @dev: ptr to peer device
+ * @data: ptr to opaque data, to be used for ice_event to report
+ *
+ * This function is to be called by device_for_each_child to handle an
+ * event reported by a peer or the ice driver.
+ */
+int ice_peer_check_for_reg(struct device *dev, void *data)
+{
+	struct ice_peer_dev *peer_dev = dev_to_ice_peer(dev);
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_event *event = (struct ice_event *)data;
+	DECLARE_BITMAP(comp_events, ICE_EVENT_NBITS);
+	bool check = true;
+	int ret;
+
+	ret = ice_validate_peer_dev(peer_dev);
+	/* if returned error, in this case return 0 instead of 'ret'
+	 * because caller ignores this return value
+	 */
+	if (ret)
+		return 0;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return 0;
+
+	if (event->reporter)
+		check = event->reporter->index != peer_dev->index;
+
+	if (bitmap_and(comp_events, event->type, peer_dev_int->events,
+		       ICE_EVENT_NBITS) &&
+	    check && test_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev_int->state))
+		peer_dev->peer_ops->event_handler(peer_dev, event);
+
+	return 0;
+}
+
+/**
+ * ice_peer_report_state_change - accept report of a peer state change
+ * @peer_dev: peer that is sending notification about state change
+ * @event: ice_event holding info on what the state change is
+ *
+ * We also need to parse the list of peers to see if anyone is registered
+ * for notifications about this state change event, and if so, notify them.
+ */
+static void
+ice_peer_report_state_change(struct ice_peer_dev *peer_dev,
+			     struct ice_event *event)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	struct ice_peer_drv *peer_drv;
+	int e_type, drv_event = 0;
+
+	if (ice_validate_peer_dev(peer_dev))
+		return;
+
+	peer_drv = drv_to_ice_peer(peer_dev->dev.driver);
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	peer_drv_int = peer_to_ice_drv_int(peer_drv);
+
+	if (!peer_dev_int || !peer_drv_int)
+		return;
+
+	e_type = find_first_bit(event->type, ICE_EVENT_NBITS);
+	if (!e_type)
+		return;
+
+	switch (e_type) {
+	/* Check for peer_drv events */
+	case ICE_EVENT_MBX_CHANGE:
+		drv_event = 1;
+		if (event->info.mbx_rdy)
+			set_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				peer_drv_int->state);
+		else
+			clear_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				  peer_drv_int->state);
+		break;
+
+	/* Check for peer_dev events */
+	case ICE_EVENT_API_CHANGE:
+		if (event->info.api_rdy)
+			set_bit(ICE_PEER_DEV_STATE_API_RDY,
+				peer_dev_int->state);
+		else
+			clear_bit(ICE_PEER_DEV_STATE_API_RDY,
+				  peer_dev_int->state);
+		break;
+
+	default:
+		return;
+	}
+
+	/* store the event and state to notify any new peers opening */
+	if (drv_event)
+		memcpy(&peer_drv_int->current_events[e_type], event,
+		       sizeof(*event));
+	else
+		memcpy(&peer_dev_int->current_events[e_type], event,
+		       sizeof(*event));
+
+	bus_for_each_dev(&ice_peer_bus, NULL, event, ice_peer_check_for_reg);
+}
+
+/**
+ * ice_peer_dev_uninit - request to uninitialize peer
+ * @peer_dev: peer device
+ *
+ * This function triggers close/remove on peer_dev allowing peer
+ * to uninitialize.
+ */
+static int ice_peer_dev_uninit(struct ice_peer_dev *peer_dev)
+{
+	enum ice_close_reason reason = ICE_REASON_PEER_DEV_UNINIT;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv *peer_drv;
+	struct ice_pf *pf;
+	int ret;
+
+	ret = ice_validate_peer_dev(peer_dev);
+	if (ret)
+		return ret;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (ice_is_reset_in_progress(pf->state))
+		return -EBUSY;
+
+	peer_drv = drv_to_ice_peer(peer_dev->dev.driver);
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return -EINVAL;
+
+	ret = ice_peer_close(&peer_dev->dev, &reason);
+	if (ret)
+		return ret;
+
+	ret = peer_drv->remove(peer_dev);
+	if (!ret)
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_REMOVED);
+
+	return ret;
+}
+
+/**
+ * ice_peer_dev_reinit - request to reinitialize peer
+ * @peer_dev: peer device
+ *
+ * This function resets peer_dev state to 'INIT' that causes a
+ * re-probe/open on peer_dev from service task
+ */
+static int ice_peer_dev_reinit(struct ice_peer_dev *peer_dev)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+	int ret;
+
+	ret = ice_validate_peer_dev(peer_dev);
+	if (ret)
+		return ret;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!ice_pf_state_is_nominal(pf))
+		return -EBUSY;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return -EINVAL;
+
+	if (test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state))
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * ice_peer_request_reset - accept request from peer to perform a reset
+ * @peer_dev: peer device that is request a reset
+ * @reset_type: type of reset the peer is requesting
+ */
+static int
+ice_peer_request_reset(struct ice_peer_dev *peer_dev,
+		       enum ice_peer_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+	struct ice_pf *pf;
+
+	if (ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	switch (reset_type) {
+	case ICE_PEER_PFR:
+		reset = ICE_RESET_PFR;
+		break;
+	case ICE_PEER_CORER:
+		reset = ICE_RESET_CORER;
+		break;
+	case ICE_PEER_GLOBR:
+		reset = ICE_RESET_GLOBR;
+		break;
+	default:
+		dev_err(&pf->pdev->dev, "incorrect reset request from peer\n");
+		return -EINVAL;
+	}
+
+	return ice_schedule_reset(pf, reset);
+}
+
+/**
+ * ice_peer_update_vsi_filter - update filters for RDMA VSI
+ * @peer_dev: pointer to RDMA peer device
+ * @filter: selection of filters to enable or disable
+ * @enable: bool whether to enable or disable filters
+ */
+static
+int ice_peer_update_vsi_filter(struct ice_peer_dev *peer_dev,
+			       enum ice_rdma_filter __maybe_unused filter,
+			       bool enable)
+{
+	struct ice_pf *pf;
+	int ret, v;
+	u16 idx;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!pf)
+		return -EINVAL;
+
+	ice_for_each_vsi(pf, v)
+		if (peer_dev->pf_vsi_num == pf->vsi[v]->vsi_num) {
+			idx = pf->vsi[v]->idx;
+			break;
+		}
+	if (v >= pf->num_alloc_vsi)
+		return -EINVAL;
+
+	ret = ice_cfg_iwarp_fltr(&pf->hw, idx, enable);
+
+	if (ret)
+		dev_err(&pf->pdev->dev, "Failed to  %sable iWARP filtering\n",
+			enable ? "en" : "dis");
+
+	return ret;
+}
+
+/**
+ * ice_peer_vc_send - send a virt channel message from RDMA peer
+ * @peer_dev: pointer to RDMA peer dev
+ * @vf_id: the absolute VF ID of recipient of message
+ * @msg: pointer to message contents
+ * @len: len of message
+ */
+static
+int ice_peer_vc_send(struct ice_peer_dev *peer_dev, u32 vf_id, u8 *msg, u16 len)
+{
+	struct ice_pf *pf;
+	int err;
+
+	if (ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	/* VIRTCHNL_OP_IWARP is being used for RoCEv2 msg also */
+	err = ice_aq_send_msg_to_vf(&pf->hw, vf_id, VIRTCHNL_OP_IWARP, 0, msg,
+				    len, NULL);
+	if (err)
+		dev_err(&pf->pdev->dev,
+			"Unable to send RDMA msg to VF, error %d\n", err);
+
+	return err;
+}
+
+/* Initialize the ice_ops struct, which is used in 'ice_init_peer_devices' */
+static const struct ice_ops ops = {
+	.alloc_res			= ice_peer_alloc_res,
+	.free_res			= ice_peer_free_res,
+	.reg_for_notification		= ice_peer_reg_for_notif,
+	.unreg_for_notification		= ice_peer_unreg_for_notif,
+	.notify_state_change		= ice_peer_report_state_change,
+	.request_reset			= ice_peer_request_reset,
+	.request_uninit			= ice_peer_dev_uninit,
+	.request_reinit			= ice_peer_dev_reinit,
+	.update_vsi_filter		= ice_peer_update_vsi_filter,
+	.vc_send			= ice_peer_vc_send,
+
+};
+
+/**
+ * ice_reserve_peer_qvector - Reserve vector resources for peer drivers
+ * @pf: board private structure to initialize
+ */
+static int ice_reserve_peer_qvector(struct ice_pf *pf)
+{
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		int index;
+
+		index = ice_get_res(pf, pf->sw_irq_tracker, pf->num_rdma_msix,
+				    ICE_RES_RDMA_VEC_ID);
+		if (index < 0)
+			return index;
+		pf->num_avail_sw_msix -= pf->num_rdma_msix;
+		pf->rdma_base_vector = index;
+
+		index = ice_get_res(pf, pf->hw_irq_tracker, pf->num_rdma_msix,
+				    ICE_RES_RDMA_VEC_ID);
+		if (index < 0) {
+			ice_free_res(pf->sw_irq_tracker, pf->rdma_base_vector,
+				     ICE_RES_RDMA_VEC_ID);
+			pf->num_avail_sw_msix += pf->num_rdma_msix;
+			return index;
+		}
+		pf->num_avail_hw_msix -= pf->num_rdma_msix;
+	}
+	return 0;
+}
+
+/**
+ * ice_peer_close_task - call peer's close asynchronously
+ * @work: pointer to work_struct contained by the peer_dev_int struct
+ *
+ * This method (asynchronous) of calling a peer's close function is
+ * meant to be used in the reset path.
+ */
+static void ice_peer_close_task(struct work_struct *work)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_dev *peer_dev;
+
+	peer_dev_int = container_of(work, struct ice_peer_dev_int,
+				    peer_close_task);
+
+	peer_dev = &peer_dev_int->peer_dev;
+	if (!peer_dev || !peer_dev->peer_ops)
+		return;
+
+	if (peer_dev->peer_ops->close)
+		peer_dev->peer_ops->close(peer_dev, peer_dev_int->rst_type);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSED);
+}
+
+/**
+ * ice_init_peer_devices - initializes peer devices
+ * @pf: ptr to ice_pf
+ *
+ * This function initializes peer devices and associates them with specified
+ * pci_dev as their parent.
+ */
+int ice_init_peer_devices(struct ice_pf *pf)
+{
+	struct pci_dev *pdev = pf->pdev;
+	struct msix_entry *entry = NULL;
+	int status = 0;
+	int i;
+
+	/* Reserve vector resources */
+	status = ice_reserve_peer_qvector(pf);
+	if (status < 0) {
+		dev_err(&pdev->dev,
+			"failed to reserve vectors for peer drivers\n");
+		return status;
+	}
+	for (i = 0; i < ARRAY_SIZE(peer_device_ids); i++) {
+		struct ice_peer_dev_int *peer_dev_int;
+		struct ice_qos_params *qos_info;
+		int j;
+		struct ice_peer_dev *peer_dev;
+
+		peer_dev_int = devm_kzalloc(&pdev->dev, sizeof(*peer_dev_int),
+					    GFP_KERNEL);
+		if (!peer_dev_int)
+			return -ENOMEM;
+
+		peer_dev = &peer_dev_int->peer_dev;
+		peer_dev->peer_ops = NULL;
+		peer_dev_int->ice_peer_wq =
+			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
+						i);
+		if (!peer_dev_int->ice_peer_wq)
+			return -ENOMEM;
+		INIT_WORK(&peer_dev_int->peer_close_task, ice_peer_close_task);
+
+		/* Assign a unique index and hence name for peer device */
+		status = ida_simple_get(&ice_peer_index_ida, 0, 0, GFP_KERNEL);
+		if (status < 0) {
+			dev_err(&pdev->dev,
+				"failed to get unique index for device (ID: 0x%04x)\n",
+				peer_dev->dev_id.device);
+			devm_kfree(&pdev->dev, peer_dev);
+			return status;
+		}
+		peer_dev->index = status;
+		dev_set_name(&peer_dev->dev, "ice_peer_%u",
+			     peer_dev->index);
+		peer_dev->pdev = pdev;
+		peer_dev->ari_ena = pci_ari_enabled(pdev->bus);
+		peer_dev->bus_num = PCI_BUS_NUM(pdev->devfn);
+		if (!peer_dev->ari_ena) {
+			peer_dev->dev_num = PCI_SLOT(pdev->devfn);
+			peer_dev->fn_num = PCI_FUNC(pdev->devfn);
+		} else {
+			peer_dev->dev_num = 0;
+			peer_dev->fn_num = pdev->devfn & 0xff;
+		}
+
+		qos_info = &peer_dev->initial_qos_info;
+
+		/* setup qos_info fields with defaults */
+		qos_info->num_apps = 0;
+		qos_info->num_tc = 1;
+
+		for (j = 0; j < ICE_IDC_MAX_USER_PRIORITY; j++)
+			qos_info->up2tc[j] = 0;
+
+		qos_info->tc_info[0].rel_bw = 100;
+		for (j = 1; j < IEEE_8021QAZ_MAX_TCS; j++)
+			qos_info->tc_info[j].rel_bw = 0;
+
+		peer_dev->dev_id.vendor = peer_device_ids[i].vendor;
+		peer_dev->dev_id.device = peer_device_ids[i].device;
+		peer_dev->dev.release = ice_peer_dev_release;
+		peer_dev->dev.parent = &pdev->dev;
+		peer_dev->dev.bus = &ice_peer_bus;
+
+		/* Initialize ice_ops */
+		peer_dev->ops = &ops;
+
+		/* make sure peer specific resources such as msix_count and
+		 * msix_entries are initialized
+		 */
+		switch (peer_dev->dev_id.device) {
+		case ICE_PEER_RDMA_DEV:
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				peer_dev->msix_count = pf->num_rdma_msix;
+				entry = &pf->msix_entries[pf->rdma_base_vector];
+			}
+			break;
+		default:
+			break;
+		}
+
+		peer_dev->msix_entries = entry;
+
+		/* device_register() causes the bus infrastructure to look for
+		 * a matching driver
+		 */
+		status = device_register(&peer_dev->dev);
+		if (status) {
+			dev_err(&pdev->dev,
+				"failed to register device (ID: 0x%04x)\n",
+				peer_dev->dev_id.device);
+			ida_simple_remove(&ice_peer_index_ida,
+					  peer_dev->index);
+			put_device(&peer_dev->dev);
+			devm_kfree(&pdev->dev, peer_dev);
+			break;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * ice_reg_peer_driver - register peer driver
+ * @drv: ptr to peer driver
+ *
+ * This is the registration function for peer drivers, which invokes
+ * OS specific driver registration to trigger bus infrastructure. This
+ * exported symbol to be invoked by peer drivers.
+ *
+ * registering peer is expected to populate the ice_peerdrv->name field
+ * before calling this function.
+ */
+int ice_reg_peer_driver(struct ice_peer_drv *drv)
+{
+	struct ice_peer_drv_int *peer_drv_int;
+	int ret, i;
+
+	if (!drv) {
+		pr_err("Failed to reg peer drv: drv ptr NULL\n");
+		return -EINVAL;
+	}
+
+	if (!drv->name) {
+		pr_err("Failed to reg peer drv: peer drv name NULL\n");
+		return -EINVAL;
+	}
+
+	if (!drv->driver.owner || !drv->driver.mod_name) {
+		pr_err("Fail reg peer drv: peer drv owner or mod_name NULL\n");
+		return -EINVAL;
+	}
+
+	if (drv->ver.major != ICE_PEER_MAJOR_VER ||
+	    drv->ver.minor != ICE_PEER_MINOR_VER) {
+		pr_err("failed to register due to version mismatch:\n");
+		pr_err("expected major ver %d, caller specified major ver %d\n",
+		       ICE_PEER_MAJOR_VER, drv->ver.major);
+		pr_err("expected minor ver %d, caller specified minor ver %d\n",
+		       ICE_PEER_MINOR_VER, drv->ver.minor);
+		return -EINVAL;
+	}
+
+	if (!drv->remove) {
+		pr_err("failed to register due to lack of remove API\n");
+		return -EINVAL;
+	}
+
+	if (!drv->probe) {
+		pr_err("failed to register due to lack of probe API\n");
+		return -EINVAL;
+	}
+
+	peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
+	if (!peer_drv_int)
+		return -ENOMEM;
+
+	peer_drv_int->peer_drv = drv;
+	INIT_LIST_HEAD(&peer_drv_int->drv_int_list);
+
+	mutex_lock(&ice_peer_drv_mutex);
+	list_add(&peer_drv_int->drv_int_list, &ice_peer_drv_list);
+	mutex_unlock(&ice_peer_drv_mutex);
+
+	/* Initialize driver values */
+	for (i = 0; i < ICE_EVENT_NBITS; i++)
+		bitmap_zero(peer_drv_int->current_events[i].type,
+			    ICE_EVENT_NBITS);
+
+	drv->driver.bus = &ice_peer_bus;
+
+	ret = driver_register(&drv->driver);
+	if (ret) {
+		pr_err("Failed to register peer driver %d\n", ret);
+		mutex_lock(&ice_peer_drv_mutex);
+		list_del(&peer_drv_int->drv_int_list);
+		mutex_unlock(&ice_peer_drv_mutex);
+		kfree(peer_drv_int);
+	}
+
+	return ret;
+}
+
+/**
+ * ice_unreg_peer_driver - unregister peer driver
+ * @drv: ptr to peer driver
+ *
+ * This is the unregistration function for peer drivers, which invokes
+ * OS specific driver unregistration to trigger bus infrastructure. This
+ * exported symbol to be invoked by peer drivers.
+ */
+int ice_unreg_peer_driver(struct ice_peer_drv *drv)
+{
+	struct ice_peer_drv_int *peer_drv_int;
+
+	if (!drv || !drv->driver.owner) {
+		pr_err("Fail unregister peer driver: driver or mod ptr NULL\n");
+		return -ENODEV;
+	}
+
+	peer_drv_int = peer_to_ice_drv_int(drv);
+	if (!peer_drv_int)
+		return -ENODEV;
+
+	mutex_lock(&ice_peer_drv_mutex);
+	list_del(&peer_drv_int->drv_int_list);
+	mutex_unlock(&ice_peer_drv_mutex);
+
+	kfree(peer_drv_int);
+
+	driver_unregister(&drv->driver);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.h b/drivers/net/ethernet/intel/ice/ice_idc.h
new file mode 100644
index 0000000..b998aa7
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.h
@@ -0,0 +1,402 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018, Intel Corporation. */
+
+#ifndef _ICE_IDC_H_
+#define _ICE_IDC_H_
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/netdevice.h>
+#include <linux/dcbnl.h>
+
+/* This major and minor version represent IDC API version information.
+ * During peer driver registration, peer driver specifies major and minor
+ * version information (via. peer_driver:ver_info). It gets checked against
+ * following defines and if mismatch, then peer driver registration
+ * fails and appropriate message gets logged.
+ */
+#define ICE_PEER_MAJOR_VER		5
+#define ICE_PEER_MINOR_VER		1
+
+enum ice_event_type {
+	ICE_EVENT_LINK_CHANGE = 0x0,
+	ICE_EVENT_MTU_CHANGE,
+	ICE_EVENT_TC_CHANGE,
+	ICE_EVENT_API_CHANGE,
+	ICE_EVENT_MBX_CHANGE,
+	ICE_EVENT_NBITS		/* must be last */
+};
+
+enum ice_res_type {
+	ICE_INVAL_RES = 0x0,
+	ICE_VSI,
+	ICE_VEB,
+	ICE_EVENT_Q,
+	ICE_EGRESS_CMPL_Q,
+	ICE_CMPL_EVENT_Q,
+	ICE_ASYNC_EVENT_Q,
+	ICE_DOORBELL_Q,
+	ICE_RDMA_QSETS_TXSCHED,
+};
+
+enum ice_peer_reset_type {
+	ICE_PEER_PFR = 0,
+	ICE_PEER_CORER,
+	ICE_PEER_CORER_SW_CORE,
+	ICE_PEER_CORER_SW_FULL,
+	ICE_PEER_GLOBR,
+};
+
+/* reason notified to peer driver as part of event handling */
+enum ice_close_reason {
+	ICE_REASON_INVAL = 0x0,
+	ICE_REASON_HW_UNRESPONSIVE,
+	ICE_REASON_INTERFACE_DOWN, /* Administrative down */
+	ICE_REASON_PEER_DRV_UNREG, /* peer driver getting unregistered */
+	ICE_REASON_PEER_DEV_UNINIT,
+	ICE_REASON_GLOBR_REQ,
+	ICE_REASON_CORER_REQ,
+	ICE_REASON_EMPR_REQ,
+	ICE_REASON_PFR_REQ,
+	ICE_REASON_HW_RESET_PENDING,
+	ICE_REASON_PARAM_CHANGE,
+};
+
+enum ice_rdma_filter {
+	ICE_RDMA_FILTER_INVAL = 0x0,
+	ICE_RDMA_FILTER_IWARP,
+	ICE_RDMA_FILTER_ROCEV2,
+	ICE_RDMA_FILTER_BOTH,
+};
+
+/* This information is needed to handle peer driver registration,
+ * instead of adding more params to peer_drv_registration function,
+ * let's get it thru' peer_drv object.
+ */
+struct ice_ver_info {
+	u16 major;
+	u16 minor;
+	u16 support;
+};
+
+/* Struct to hold per DCB APP info */
+struct ice_dcb_app_info {
+	u8  priority;
+	u8  selector;
+	u16 prot_id;
+};
+
+struct ice_peer_dev;
+
+#define ICE_IDC_MAX_USER_PRIORITY        8
+#define ICE_IDC_MAX_APPS        8
+
+/* Struct to hold per RDMA Qset info */
+struct ice_rdma_qset_params {
+	u32 teid;	/* qset TEID */
+	u16 qs_handle; /* RDMA driver provides this */
+	u16 vsi_id; /* VSI index */
+	u8 tc; /* TC branch the QSet should belong to */
+	u8 reserved[3];
+};
+
+struct ice_res_base {
+	/* Union for future provision e.g. other res_type */
+	union {
+		struct ice_rdma_qset_params qsets;
+	} res;
+};
+
+struct ice_res {
+	/* Type of resource. Filled by peer driver */
+	enum ice_res_type res_type;
+	/* Count requested by peer driver */
+	u16 cnt_req;
+
+	/* Number of resources allocated. Filled in by callee.
+	 * Based on this value, caller to fill up "resources"
+	 */
+	u16 res_allocated;
+
+	/* Unique handle to resources allocated. Zero if call fails.
+	 * Allocated by callee and for now used by caller for internal
+	 * tracking purpose.
+	 */
+	u32 res_handle;
+
+	/* Peer driver has to allocate sufficient memory, to accommodate
+	 * cnt_requested before calling this function.
+	 * Memory has to be zero initialized. It is input/output param.
+	 * As a result of alloc_res API, this structures will be populated.
+	 */
+	struct ice_res_base res[1];
+};
+
+struct ice_vector_info {
+	u32 v_idx; /* MSIx vector */
+	u16 itr_idx;
+	/* This is the register address of GLINT_DYN_CTL[idx], not value */
+	u64 itr_dyn_ctl_reg;
+	/* This is the register address of GLINT_RATE[idx], not value */
+	u64 itr_rate_lmt_reg;
+};
+
+struct ice_vector_list {
+	u32 num_vectors;
+	struct ice_vector_info *vector;
+	/* Unique handle to resources allocated.
+	 * Zero if call fails
+	 */
+	u32 res_handle;
+};
+
+struct ice_itr_regs {
+	u16 cnt;
+	u64 *tmr_regs;
+	u32 res_handle;
+};
+
+struct ice_qos_info {
+	u64 tc_ctx;
+	u8 rel_bw;
+	u8 prio_type;
+	u8 egress_virt_up;
+	u8 ingress_virt_up;
+};
+
+/* Struct to hold QoS info */
+struct ice_qos_params {
+	struct ice_qos_info tc_info[IEEE_8021QAZ_MAX_TCS];
+	u8 up2tc[ICE_IDC_MAX_USER_PRIORITY];
+	u8 vsi_relative_bw;
+	u8 vsi_priority_type;
+	u32 num_apps;
+	struct ice_dcb_app_info apps[ICE_IDC_MAX_APPS];
+	u8 num_tc;
+};
+
+union ice_event_info {
+	/* ICE_EVENT_LINK_CHANGE */
+	struct {
+		struct net_device *lwr_nd;
+		u16 vsi_num; /* HW index of VSI corresponding to lwr ndev */
+		u8 new_link_state;
+		u8 lport;
+	} link_info;
+	/* ICE_EVENT_MTU_CHANGE */
+	u16 mtu;
+	/* ICE_EVENT_TC_CHANGE */
+	struct ice_qos_params port_qos;
+	/* ICE_EVENT_API_CHANGE */
+	u8 api_rdy;
+	/* ICE_EVENT_MBX_CHANGE */
+	u8 mbx_rdy;
+};
+
+/* ice_event elements are to be passed back and forth between the ice driver
+ * and the peer drivers. They are to be used to both register/unregister
+ * for event reporting and to report an event (events can be either ice
+ * generated or peer generated).
+ *
+ * For (un)registering for events, the structure needs to be populated with:
+ *   reporter - pointer to the ice_peer_dev struct of the peer (un)registering
+ *   type - bitmap with bits set for event types to (un)register for
+ *
+ * For reporting events, the structure needs to be populated with:
+ *   reporter - pointer to peer that generated the event (NULL for ice)
+ *   type - bitmap with single bit set for this event type
+ *   info - union containing data relevant to this event type
+ */
+struct ice_event {
+	struct ice_peer_dev *reporter;
+	DECLARE_BITMAP(type, ICE_EVENT_NBITS);
+	union ice_event_info info;
+};
+
+/* Following APIs are implemented by ICE driver and invoked by peer drivers */
+struct ice_ops {
+	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
+	 * completion queues, Tx/Rx queues, etc...
+	 */
+	int (*alloc_res)(struct ice_peer_dev *peer_dev,
+			 struct ice_res *res,
+			 int partial_acceptable);
+	int (*free_res)(struct ice_peer_dev *peer_dev,
+			struct ice_res *res);
+
+	/* Interrupt/Vector related APIs */
+	int (*alloc_msix_vector)(struct ice_peer_dev *peer_dev,
+				 int count, struct ice_vector_list *entries);
+	int (*free_msix_vector)(struct ice_peer_dev *peer_dev,
+				int count, struct ice_vector_list *entries);
+	int (*associate_vector_cause)(struct ice_peer_dev *peer_dev,
+				      struct ice_vector_info *qv_info,
+				      enum ice_res_type res_type,
+				      int res_idx);
+	int (*request_uninit)(struct ice_peer_dev *peer_dev);
+	int (*request_reinit)(struct ice_peer_dev *peer_dev);
+	int (*request_reset)(struct ice_peer_dev *dev,
+			     enum ice_peer_reset_type reset_type);
+
+	void (*notify_state_change)(struct ice_peer_dev *dev,
+				    struct ice_event *event);
+
+	/* Notification APIs */
+	void (*reg_for_notification)(struct ice_peer_dev *dev,
+				     struct ice_event *event);
+	void (*unreg_for_notification)(struct ice_peer_dev *dev,
+				       struct ice_event *event);
+	int (*update_vsi_filter)(struct ice_peer_dev *peer_dev,
+				 enum ice_rdma_filter filter, bool enable);
+	int (*vc_send)(struct ice_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+		       u16 len);
+};
+
+/* Following APIs are implemented by peer drivers and invoked by ICE driver */
+struct ice_peer_ops {
+	void (*event_handler)(struct ice_peer_dev *peer_dev,
+			      struct ice_event *event);
+
+	/* Why we have 'open' and when it is expected to be called:
+	 * 1. symmetric set of API w.r.t close
+	 * 2. To be invoked form driver initialization path
+	 *     - call peer_driver:probe as soon as ice driver:probe is done
+	 *     - call peer_driver:open once ice driver is fully initialized
+	 * 3. To be invoked upon RESET complete
+	 *
+	 * Calls to open are performed from ice_finish_init_peer_device
+	 * which is invoked from the service task. This helps keep devices
+	 * from having their open called until the ice driver is ready and
+	 * has scheduled its service task.
+	 */
+	void (*open)(struct ice_peer_dev *peer_dev);
+
+	/* Peer's close function is to be called when the peer needs to be
+	 * quiesced. This can be for a variety of reasons (enumerated in the
+	 * ice_close_reason enum struct). A call to close will only be
+	 * followed by a call to either remove or open. No IDC calls from the
+	 * peer should be accepted until it is re-opened.
+	 *
+	 * The *reason* parameter is the reason for the call to close. This
+	 * can be for any reason enumerated in the ice_close_reason struct.
+	 * It's primary reason is for the peer's bookkeeping and in case the
+	 * peer want to perform any different tasks dictated by the reason.
+	 */
+	void (*close)(struct ice_peer_dev *peer_dev,
+		      enum ice_close_reason reason);
+
+	int (*vc_receive)(struct ice_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+			  u16 len);
+	/* tell RDMA peer to prepare for TC change in a blocking call
+	 * that will directly precede the change event
+	 */
+	void (*prep_tc_change)(struct ice_peer_dev *peer_dev);
+};
+
+struct ice_peer_device_id {
+	u32 vendor;
+
+	u32 device;
+#define ICE_PEER_RDMA_DEV	0x00000010
+};
+
+#define ICE_MAX_NUM_LPORTS		21
+/* structure representing peer device */
+struct ice_peer_dev {
+	struct device dev;
+	struct pci_dev *pdev; /* PCI device of corresponding to main function */
+	struct ice_peer_device_id dev_id;
+	/* KVA / Linear address corresponding to BAR0 of underlying
+	 * pci_device.
+	 */
+	u8 __iomem *hw_addr;
+
+	unsigned int index;
+
+	u8 ftype;	/* PF(false) or VF (true) */
+
+	/* Data VSI created by driver */
+	u16 pf_vsi_num;
+
+	u8 lan_addr[ETH_ALEN]; /* default MAC address of main netdev */
+	u16 initial_mtu; /* Initial MTU of main netdev */
+	struct ice_qos_params initial_qos_info;
+	struct net_device *netdev;
+	/* PCI info */
+	u8 ari_ena;
+	u16 bus_num;
+	u16 dev_num;
+	u16 fn_num;
+
+	/* Based on peer driver type, this shall point to corresponding MSIx
+	 * entries in pf->msix_entries (which were allocated as part of driver
+	 * initialization) e.g. for RDMA driver, msix_entries reserved will be
+	 * num_online_cpus + 1.
+	 */
+	u16 msix_count; /* How many vectors are reserved for this device */
+	struct msix_entry *msix_entries;
+
+	/* Following struct contains function pointers to be initialized
+	 * by ICE driver and called by peer driver
+	 */
+	const struct ice_ops *ops;
+
+	/* Following struct contains function pointers to be initialized
+	 * by peer driver and called by ICE driver
+	 */
+	const struct ice_peer_ops *peer_ops;
+};
+
+static inline struct ice_peer_dev *dev_to_ice_peer(struct device *_dev)
+{
+	return container_of(_dev, struct ice_peer_dev, dev);
+}
+
+/* structure representing peer driver
+ * Peer driver to initialize those function ptrs and
+ * it will be invoked by ICE as part of driver_registration
+ * via bus infrastructure
+ */
+struct ice_peer_drv {
+	u16 driver_id;
+#define ICE_PEER_LAN_DRIVER		0
+#define ICE_PEER_RDMA_DRIVER		4
+#define ICE_PEER_ADK_DRIVER		5
+
+	struct ice_ver_info ver;
+	const char *name;
+
+	struct device_driver driver;
+	struct ice_peer_device_id dev_id;
+
+	/* As part of ice_peer_drv initialization, peer driver is expected
+	 * to initialize driver.probe and driver.remove callbacks to peer
+	 * driver's respective probe and remove.
+	 *
+	 * driver_registration invokes driver->probe and likewise
+	 * driver_unregistration invokes driver->remove
+	 */
+	int (*probe)(struct ice_peer_dev *dev);
+	int (*remove)(struct ice_peer_dev *dev);
+};
+
+#define IDC_SIGNATURE 0x494e54454c494443ULL
+struct idc_srv_provider {
+	u64 signature;
+	u16 maj_ver;
+	u16 min_ver;
+	u8 rsvd[4];
+	int (*reg_peer_driver)(struct ice_peer_drv *drv);
+	int (*unreg_peer_driver)(struct ice_peer_drv *drv);
+};
+
+static inline struct ice_peer_drv *drv_to_ice_peer(struct device_driver *drv)
+{
+	return container_of(drv, struct ice_peer_drv, driver);
+};
+
+/* Exported symbols for driver registration/unregistration */
+int ice_reg_peer_driver(struct ice_peer_drv *peer);
+int ice_unreg_peer_driver(struct ice_peer_drv *peer);
+#endif /* _ICE_IDC_H_*/
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 0000000..bb82e2c
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include "ice_idc.h"
+
+#define ICE_IDC_MAX_STATE_WAIT	12
+extern struct list_head ice_peer_drv_list;
+extern struct mutex ice_peer_drv_mutex; /* control access to list of peer_drv */
+int ice_prep_peer_for_reset(struct device *dev, void *data);
+int ice_close_peer_for_reset(struct device *dev, void *data);
+int ice_unroll_peer(struct device *dev, void *data);
+int ice_unreg_peer_device(struct device *dev, void *data);
+int ice_peer_close(struct device *dev, void *data);
+int ice_peer_check_for_reg(struct device *dev, void *data);
+int ice_finish_init_peer_device(struct device *dev, void *data);
+
+enum ice_peer_dev_state {
+	ICE_PEER_DEV_STATE_INIT,
+	ICE_PEER_DEV_STATE_PROBE,
+	ICE_PEER_DEV_STATE_PROBED,
+	ICE_PEER_DEV_STATE_OPENED,
+	ICE_PEER_DEV_STATE_PREP_RST,
+	ICE_PEER_DEV_STATE_PREPPED,
+	ICE_PEER_DEV_STATE_CLOSED,
+	ICE_PEER_DEV_STATE_REMOVED,
+	ICE_PEER_DEV_STATE_API_RDY,
+	ICE_PEER_DEV_STATE_NBITS,               /* must be last */
+};
+
+enum ice_peer_drv_state {
+	ICE_PEER_DRV_STATE_MBX_RDY,
+	ICE_PEER_DRV_STATE_NBITS,               /* must be last */
+};
+
+struct ice_peer_dev_int {
+	struct ice_peer_dev peer_dev; /* public structure */
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct ice_event current_events[ICE_EVENT_NBITS];
+	/* Events a peer has registered to be notified about */
+	DECLARE_BITMAP(events, ICE_EVENT_NBITS);
+
+	/* States associated with peer device */
+	DECLARE_BITMAP(state, ICE_PEER_DEV_STATE_NBITS);
+
+	/* per peer workqueue */
+	struct workqueue_struct *ice_peer_wq;
+
+	struct work_struct peer_prep_task;
+	struct work_struct peer_close_task;
+
+	enum ice_close_reason rst_type;
+};
+
+struct ice_peer_drv_int {
+	struct ice_peer_drv *peer_drv;
+
+	/* list of peer_drv_int */
+	struct list_head drv_int_list;
+
+	/* States associated with peer driver */
+	DECLARE_BITMAP(state, ICE_PEER_DRV_STATE_NBITS);
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct ice_event current_events[ICE_EVENT_NBITS];
+};
+
+static inline
+struct ice_peer_dev_int *peer_to_ice_dev_int(struct ice_peer_dev *peer_dev)
+{
+	return container_of(peer_dev, struct ice_peer_dev_int, peer_dev);
+}
+
+static inline
+struct ice_peer_drv_int *peer_to_ice_drv_int(struct ice_peer_drv *peer_drv)
+{
+	struct ice_peer_drv_int *drv_int;
+
+	mutex_lock(&ice_peer_drv_mutex);
+	list_for_each_entry(drv_int, &ice_peer_drv_list, drv_int_list) {
+		if (drv_int->peer_drv == peer_drv) {
+			mutex_unlock(&ice_peer_drv_mutex);
+			return drv_int;
+		}
+	}
+
+	mutex_unlock(&ice_peer_drv_mutex);
+
+	return NULL;
+}
+
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 29b1dcf..b0789a12 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1430,6 +1430,30 @@ int ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 }
 
 /**
+ * ice_pf_state_is_nominal - checks the pf for nominal state
+ * @pf: pointer to pf to check
+ *
+ * Check the PF's state for a collection of bits that would indicate
+ * the PF is in a state that would inhibit normal operation for
+ * driver functionality.
+ *
+ * Returns true if PF is in a nominal state, false otherwise
+ */
+bool ice_pf_state_is_nominal(struct ice_pf *pf)
+{
+	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
+
+	if (!pf)
+		return false;
+
+	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
+	if (bitmap_intersects(pf->state, check_bits, __ICE_STATE_NBITS))
+		return false;
+
+	return true;
+}
+
+/**
  * ice_update_eth_stats - Update VSI-specific ethernet statistics counters
  * @vsi: the VSI to be updated
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3831b4f..29aaacc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -11,6 +11,8 @@ int ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 
 void ice_free_fltr_list(struct device *dev, struct list_head *h);
 
+bool ice_pf_state_is_nominal(struct ice_pf *pf);
+
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8725569..7db9148 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -416,8 +416,16 @@ static void ice_reset_subtask(struct ice_pf *pf)
 	 * for the reset now), poll for reset done, rebuild and return.
 	 */
 	if (test_bit(__ICE_RESET_OICR_RECV, pf->state)) {
-		clear_bit(__ICE_GLOBR_RECV, pf->state);
-		clear_bit(__ICE_CORER_RECV, pf->state);
+		/* Perform the largest reset requested */
+		if (test_and_clear_bit(__ICE_CORER_RECV, pf->state))
+			reset_type = ICE_RESET_CORER;
+		if (test_and_clear_bit(__ICE_GLOBR_RECV, pf->state))
+			reset_type = ICE_RESET_GLOBR;
+		/* return if no valid reset type requested */
+		if (reset_type == ICE_RESET_INVAL)
+			return;
+		bus_for_each_dev(&ice_peer_bus, NULL, &reset_type,
+				 ice_close_peer_for_reset);
 		if (!test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
 			ice_prepare_for_reset(pf);
 
@@ -1063,6 +1071,10 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	/* Invoke remaining initialization of peer devices */
+	bus_for_each_dev(&ice_peer_bus, NULL, NULL,
+			 ice_finish_init_peer_device);
+
 	ice_check_for_hang_subtask(pf);
 	ice_sync_fltr_subtask(pf);
 	ice_handle_mdd_event(pf);
@@ -1103,6 +1115,42 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 }
 
 /**
+ * ice_schedule_reset - schedule a reset
+ * @pf: board private structure
+ * @reset: reset being requested
+ */
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
+{
+	/* bail out if earlier reset has failed */
+	if (test_bit(__ICE_RESET_FAILED, pf->state)) {
+		dev_dbg(&pf->pdev->dev, "earlier reset has failed\n");
+		return -EIO;
+	}
+	/* bail if reset/recovery already in progress */
+	if (ice_is_reset_in_progress(pf->state)) {
+		dev_dbg(&pf->pdev->dev, "Reset already in progress\n");
+		return -EBUSY;
+	}
+
+	switch (reset) {
+	case ICE_RESET_PFR:
+		set_bit(__ICE_PFR_REQ, pf->state);
+		break;
+	case ICE_RESET_CORER:
+		set_bit(__ICE_CORER_REQ, pf->state);
+		break;
+	case ICE_RESET_GLOBR:
+		set_bit(__ICE_GLOBR_REQ, pf->state);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ice_service_task_schedule(pf);
+	return 0;
+}
+
+/**
  * ice_irq_affinity_notify - Callback for affinity changes
  * @notify: context as to what irq was changed
  * @mask: the new affinity mask
@@ -1524,6 +1572,12 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	vsi->netdev = netdev;
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
+	np->prov_callbacks.signature = IDC_SIGNATURE;
+	np->prov_callbacks.maj_ver = ICE_PEER_MAJOR_VER;
+	np->prov_callbacks.min_ver = ICE_PEER_MINOR_VER;
+	memset(np->prov_callbacks.rsvd, 0, sizeof(np->prov_callbacks.rsvd));
+	np->prov_callbacks.reg_peer_driver = ice_reg_peer_driver;
+	np->prov_callbacks.unreg_peer_driver = ice_unreg_peer_driver;
 
 	dflt_features = NETIF_F_SG	|
 			NETIF_F_HIGHDMA	|
@@ -1815,6 +1869,7 @@ static void ice_init_pf(struct ice_pf *pf)
 {
 	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
 	set_bit(ICE_FLAG_MSIX_ENA, pf->flags);
+	set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
 #ifdef CONFIG_PCI_IOV
 	if (pf->hw.func_caps.common_cap.sr_iov_1_1) {
 		struct ice_hw *hw = &pf->hw;
@@ -1860,6 +1915,8 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 	/* reserve one vector for miscellaneous handler */
 	needed = 1;
+	if (v_left < needed)
+		goto no_vecs_left_err;
 	v_budget += needed;
 	v_left -= needed;
 
@@ -1868,6 +1925,21 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += pf->num_lan_msix;
 	v_left -= pf->num_lan_msix;
 
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		needed = min_t(int, num_online_cpus(), v_left);
+
+		/* iWARP peer driver needs one extra interrupt, to be used for
+		 * other causes
+		 */
+		needed += 1;
+		/* no vectors left for RDMA */
+		if (v_left < needed)
+			goto no_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(&pf->pdev->dev, v_budget,
 					sizeof(struct msix_entry), GFP_KERNEL);
 
@@ -1894,6 +1966,8 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			 "not enough vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
 		if (v_actual >= (pf->num_lan_msix + 1)) {
+			clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+			pf->num_rdma_msix = 0;
 			pf->num_avail_sw_msix = v_actual -
 						(pf->num_lan_msix + 1);
 		} else if (v_actual >= 2) {
@@ -1912,6 +1986,11 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	devm_kfree(&pf->pdev->dev, pf->msix_entries);
 	goto exit_err;
 
+no_vecs_left_err:
+	dev_err(&pf->pdev->dev,
+		"not enough vectors. requested = %d, available = %d\n",
+		needed, v_left);
+	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
 	clear_bit(ICE_FLAG_MSIX_ENA, pf->flags);
@@ -2162,10 +2241,20 @@ static int ice_probe(struct pci_dev *pdev,
 	/* since everything is good, start the service timer */
 	mod_timer(&pf->serv_tmr, round_jiffies(jiffies + pf->serv_tmr_period));
 
+	err = ice_init_peer_devices(pf);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Failed to initialize peer devices: 0x%x\n", err);
+		err = -EIO;
+		goto err_init_peer_unroll;
+	}
+
 	ice_verify_cacheline_size(pf);
 
 	return 0;
 
+err_init_peer_unroll:
+	bus_for_each_dev(&ice_peer_bus, NULL, NULL, ice_unroll_peer);
 err_alloc_sw_unroll:
 	set_bit(__ICE_SERVICE_DIS, pf->state);
 	set_bit(__ICE_DOWN, pf->state);
@@ -2190,7 +2279,8 @@ static int ice_probe(struct pci_dev *pdev,
 static void ice_remove(struct pci_dev *pdev)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
-	int i;
+	enum ice_close_reason reason;
+	int err, i;
 
 	if (!pf)
 		return;
@@ -2201,12 +2291,21 @@ static void ice_remove(struct pci_dev *pdev)
 		msleep(100);
 	}
 
-	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
+	reason = ICE_REASON_INTERFACE_DOWN;
+	bus_for_each_dev(&ice_peer_bus, NULL, &reason, ice_peer_close);
+	set_bit(__ICE_DOWN, pf->state);
 
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
 		ice_free_vfs(pf);
 	ice_vsi_release_all(pf);
+	err = bus_for_each_dev(&ice_peer_bus, NULL, NULL,
+			       ice_unreg_peer_device);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to remove peer devices: 0x%x\n",
+			err);
+	}
+
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
@@ -2257,9 +2356,16 @@ static int __init ice_module_init(void)
 	pr_info("%s - version %s\n", ice_driver_string, ice_drv_ver);
 	pr_info("%s\n", ice_copyright);
 
+	status = bus_register(&ice_peer_bus);
+	if (status) {
+		pr_err("failed to register pseudo bus\n");
+		return status;
+	}
+
 	ice_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
 	if (!ice_wq) {
 		pr_err("Failed to create workqueue\n");
+		bus_unregister(&ice_peer_bus);
 		return -ENOMEM;
 	}
 
@@ -2267,6 +2373,11 @@ static int __init ice_module_init(void)
 	if (status) {
 		pr_err("failed to register pci driver, err %d\n", status);
 		destroy_workqueue(ice_wq);
+		bus_unregister(&ice_peer_bus);
+		/* release all cached layer within ida tree, associated with
+		 * ice_peer_index_ida object
+		 */
+		ida_destroy(&ice_peer_index_ida);
 	}
 
 	return status;
@@ -2281,8 +2392,24 @@ static int __init ice_module_init(void)
  */
 static void __exit ice_module_exit(void)
 {
+	struct ice_peer_drv_int *peer_drv_int, *tmp;
+
 	pci_unregister_driver(&ice_driver);
 	destroy_workqueue(ice_wq);
+	mutex_lock(&ice_peer_drv_mutex);
+	list_for_each_entry_safe(peer_drv_int, tmp, &ice_peer_drv_list,
+				 drv_int_list) {
+		list_del(&peer_drv_int->drv_int_list);
+		kfree(peer_drv_int);
+	}
+	mutex_unlock(&ice_peer_drv_mutex);
+
+	bus_unregister(&ice_peer_bus);
+
+	/* release all cached layer within ida tree, associated with
+	 * ice_peer_index_ida object
+	 */
+	ida_destroy(&ice_peer_index_ida);
 	pr_info("module unloaded\n");
 }
 module_exit(ice_module_exit);
@@ -3423,6 +3550,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct ice_event *event;
 	u8 count = 0;
 
 	if (new_mtu == netdev->mtu) {
@@ -3474,6 +3602,13 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		}
 	}
 
+	event = devm_kzalloc(&pf->pdev->dev, sizeof(*event), GFP_KERNEL);
+	set_bit(ICE_EVENT_MTU_CHANGE, event->type);
+	event->reporter = NULL;
+	event->info.mtu = new_mtu;
+	bus_for_each_dev(&ice_peer_bus, NULL, event, ice_peer_check_for_reg);
+	devm_kfree(&pf->pdev->dev, event);
+
 	netdev_dbg(netdev, "changed mtu to %d\n", new_mtu);
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 2e56931..360ea49 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -446,6 +446,29 @@ enum ice_status
 }
 
 /**
+ * ice_cfg_iwarp_fltr - enable/disable iwarp filtering on VSI
+ * @hw: pointer to HW struct
+ * @vsi_handle: VSI SW index
+ * @enable: boolean for enable/disable
+ */
+enum ice_status
+ice_cfg_iwarp_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable)
+{
+	struct ice_vsi_ctx *ctx;
+
+	ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!ctx)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	if (enable)
+		ctx->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+	else
+		ctx->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+
+	return ice_update_vsi(hw, vsi_handle, ctx, NULL);
+}
+
+/**
  * ice_aq_alloc_free_vsi_list
  * @hw: pointer to the hw struct
  * @vsi_list_id: VSI list id returned or used for lookup
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 78040bb..f297c86 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -207,6 +207,8 @@ enum ice_status
 enum ice_status ice_update_sw_rule_bridge_mode(struct ice_hw *hw);
 enum ice_status ice_add_mac(struct ice_hw *hw, struct list_head *m_lst);
 enum ice_status ice_remove_mac(struct ice_hw *hw, struct list_head *m_lst);
+enum ice_status
+ice_cfg_iwarp_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable);
 void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_add_vlan(struct ice_hw *hw, struct list_head *m_list);
 enum ice_status ice_remove_vlan(struct ice_hw *hw, struct list_head *v_list);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6209edc..e5b7c90 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -29,6 +29,7 @@ static inline bool ice_is_tc_ena(u8 bitmap, u8 tc)
 #define ICE_DBG_LAN		BIT_ULL(8)
 #define ICE_DBG_SW		BIT_ULL(13)
 #define ICE_DBG_SCHED		BIT_ULL(14)
+#define ICE_DBG_RDMA		BIT_ULL(15)
 #define ICE_DBG_RES		BIT_ULL(17)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
 #define ICE_DBG_AQ_CMD		BIT_ULL(27)
@@ -220,6 +221,7 @@ struct ice_sched_node {
 	u8 tc_num;
 	u8 owner;
 #define ICE_SCHED_NODE_OWNER_LAN	0
+#define ICE_SCHED_NODE_OWNER_RDMA	2
 };
 
 /* Access Macros for Tx Sched Elements data */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 05ff4f9..4a1faf9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1007,31 +1007,6 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 }
 
 /**
- * ice_pf_state_is_nominal - checks the pf for nominal state
- * @pf: pointer to pf to check
- *
- * Check the PF's state for a collection of bits that would indicate
- * the PF is in a state that would inhibit normal operation for
- * driver functionality.
- *
- * Returns true if PF is in a nominal state.
- * Returns false otherwise
- */
-static bool ice_pf_state_is_nominal(struct ice_pf *pf)
-{
-	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
-
-	if (!pf)
-		return false;
-
-	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
-	if (bitmap_intersects(pf->state, check_bits, __ICE_STATE_NBITS))
-		return false;
-
-	return true;
-}
-
-/**
  * ice_pci_sriov_ena - Enable or change number of VFs
  * @pf: pointer to the PF structure
  * @num_vfs: number of VFs to allocate
-- 
1.8.3.1
