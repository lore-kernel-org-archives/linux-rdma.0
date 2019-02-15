From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
Date: Fri, 15 Feb 2019 11:11:02 -0600
Message-ID: <20190215171107.6464-16-shiraz.saleem@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add miscellaneous utility functions and headers.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/osdep.h  |  153 ++
 drivers/infiniband/hw/irdma/protos.h |  118 ++
 drivers/infiniband/hw/irdma/status.h |   70 +
 drivers/infiniband/hw/irdma/utils.c  | 2565 ++++++++++++++++++++++++++++++++++
 4 files changed, 2906 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/osdep.h
 create mode 100644 drivers/infiniband/hw/irdma/protos.h
 create mode 100644 drivers/infiniband/hw/irdma/status.h
 create mode 100644 drivers/infiniband/hw/irdma/utils.c

diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
new file mode 100644
index 0000000..ade5536
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/osdep.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef IRDMA_OSDEP_H
+#define IRDMA_OSDEP_H
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <linux/bitops.h>
+#include <linux/pci.h>
+#include <net/tcp.h>
+#include <crypto/hash.h>
+/* get readq/writeq support for 32 bit kernels, use the low-first version */
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#define STATS_TIMER_DELAY	60000
+#define MAKEMASK(m, s)		((m) << (s))
+
+#define irdma_pr_err(fmt, args ...)				\
+	pr_err("%s: "fmt, __func__, ## args)
+
+#define irdma_pr_info(fmt, args ...)				\
+	pr_info("%s: " fmt, __func__, ## args)
+
+#define irdma_pr_warn(fmt, args ...)				\
+	pr_warn("%s: " fmt, __func__, ## args)
+
+#define irdma_dev_err(dev, fmt, args ...)			\
+	dev_err(to_device(dev), "%s: "fmt, __func__, ## args)
+
+#define irdma_dev_info(dev, fmt, args ...)			\
+	dev_info(to_device(dev), "%s: "fmt, __func__, ## args)
+
+#define irdma_dev_warn(dev, fmt, args ...)			\
+	dev_warn(to_device(dev), "%s: "fmt, __func__, ## args)
+
+#define to_device(ptr)						\
+	(&((struct pci_dev *)((ptr)->hw->dev_context))->dev)
+
+#ifdef CONFIG_DYNAMIC_DEBUG
+#define irdma_debug(dev, prefix, ...)				\
+	dev_dbg(to_device(dev), prefix ": " __VA_ARGS__)
+#define irdma_debug_buf(dev, prefix, desc, buf, size)		\
+	print_hex_dump_debug(prefix ": " desc " ",		\
+			     DUMP_PREFIX_OFFSET,		\
+			     16, 8, buf, size, false)
+#else
+#define irdma_debug(dev, mask, fmt, ...)			\
+do {                                                            \
+	if (((mask) & (dev)->debug_mask))                       \
+		dev_info(to_device(dev),			\
+			 "%s: " fmt, __func__,			\
+			 ##__VA_ARGS__);			\
+} while (0)
+#define irdma_debug_buf(dev, mask, desc, buf, size)		\
+do {                                                            \
+	if (((mask) & (dev)->debug_mask))                       \
+		print_hex_dump_debug(desc " ",			\
+				     DUMP_PREFIX_OFFSET,	\
+				     16, 8, buf, size, false);	\
+} while (0)
+#endif
+
+struct irdma_dma_info {
+	dma_addr_t *dmaaddrs;
+};
+
+struct irdma_dma_mem {
+	void *va;
+	dma_addr_t pa;
+	u32 size;
+} __packed;
+
+struct irdma_virt_mem {
+	void *va;
+	u32 size;
+} __packed;
+
+struct irdma_sc_vsi;
+struct irdma_sc_dev;
+struct irdma_sc_qp;
+struct irdma_puda_buf;
+struct irdma_puda_cmpl_info;
+struct irdma_update_sds_info;
+struct irdma_hmc_fcn_info;
+struct irdma_virtchnl_work_info;
+struct irdma_manage_vf_pble_info;
+struct irdma_hw;
+struct irdma_pci_f;
+
+u8 __iomem *irdma_get_hw_addr(void *dev);
+void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp);
+enum irdma_status_code irdma_vf_wait_vchnl_resp(struct irdma_sc_dev *dev);
+bool irdma_vf_clear_to_send(struct irdma_sc_dev *dev);
+void irdma_add_dev_ref(struct irdma_sc_dev *dev);
+void irdma_put_dev_ref(struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
+					      void *addr,
+					      u32 len, u32 val);
+struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
+				     struct irdma_puda_buf *buf);
+void irdma_send_ieq_ack(struct irdma_sc_qp *qp);
+void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf,
+				 u16 len,
+				 u32 seqnum);
+void irdma_free_hash_desc(struct shash_desc *hash_desc);
+enum irdma_status_code irdma_init_hash_desc(struct shash_desc **hash_desc);
+enum irdma_status_code
+irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			  struct irdma_puda_buf *buf);
+enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_update_sds_info *info);
+enum irdma_status_code
+irdma_cqp_manage_hmc_fcn_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_hmc_fcn_info *hmcfcninfo);
+enum irdma_status_code
+irdma_cqp_query_fpm_val_cmd(struct irdma_sc_dev *dev,
+			    struct irdma_dma_mem *val_mem,
+			    u8 hmc_fn_id);
+enum irdma_status_code
+irdma_cqp_commit_fpm_val_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_dma_mem *val_mem,
+			     u8 hmc_fn_id);
+enum irdma_status_code irdma_alloc_query_fpm_buf(struct irdma_sc_dev *dev,
+						 struct irdma_dma_mem *mem);
+enum irdma_status_code
+irdma_cqp_manage_vf_pble_bp(struct irdma_sc_dev *dev,
+			    struct irdma_manage_vf_pble_info *info);
+void irdma_cqp_spawn_worker(struct irdma_sc_dev *dev,
+			    struct irdma_virtchnl_work_info *work_info,
+			    u32 iw_vf_idx);
+void *irdma_remove_head(struct list_head *list);
+enum irdma_status_code
+irdma_qp_suspend_resume(struct irdma_sc_qp *qp, bool suspend);
+void irdma_term_modify_qp(struct irdma_sc_qp *qp,
+			  u8 next_state,
+			  u8 term,
+			  u8 term_len);
+void irdma_terminate_done(struct irdma_sc_qp *qp, int timeout_occurred);
+void irdma_terminate_start_timer(struct irdma_sc_qp *qp);
+void irdma_terminate_del_timer(struct irdma_sc_qp *qp);
+enum irdma_status_code
+irdma_hw_manage_vf_pble_bp(struct irdma_pci_f *rf,
+			   struct irdma_manage_vf_pble_info *info,
+			   bool wait);
+void irdma_hw_stats_start_timer(struct irdma_sc_vsi *vsi);
+void irdma_hw_stats_stop_timer(struct irdma_sc_vsi *vsi);
+void wr32(struct irdma_hw *hw, u32 reg, u32 val);
+u32  rd32(struct irdma_hw *hw, u32 reg);
+u64  rd64(struct irdma_hw *hw, u32 reg);
+#endif /* _IRDMA_OSDEP_H_ */
diff --git a/drivers/infiniband/hw/irdma/protos.h b/drivers/infiniband/hw/irdma/protos.h
new file mode 100644
index 0000000..d65004b
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/protos.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef IRDMA_PROTOS_H
+#define IRDMA_PROTOS_H
+
+#define PAUSE_TIMER_VAL		0xffff
+#define REFRESH_THRESHOLD	0x7fff
+#define HIGH_THRESHOLD		0x800
+#define LOW_THRESHOLD		0x200
+#define ALL_TC2PFC		0xff
+#define CQP_COMPL_WAIT_TIME_MS	10
+#define CQP_TIMEOUT_THRESHOLD	500
+
+/**
+ * irdma_insert_wqe_hdr - write wqe header
+ * @wqe: cqp wqe for header
+ * @header: header for the cqp wqe
+ */
+static inline void irdma_insert_wqe_hdr(__le64 *wqe, u64 hdr)
+{
+	wmb();   /* make sure WQE is populated before polarity is set */
+	set_64bit_val(wqe, 24, hdr);
+}
+
+/* init operations */
+enum irdma_status_code irdma_sc_ctrl_init(enum irdma_vers ver,
+					  struct irdma_sc_dev *dev,
+					  struct irdma_device_init_info *info);
+void irdma_sc_rt_init(struct irdma_sc_dev *dev);
+void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp);
+__le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch);
+enum irdma_status_code irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
+						 struct irdma_fast_reg_stag_info *info,
+						 bool post_sq);
+/* HMC/FPM functions */
+enum irdma_status_code irdma_sc_init_iw_hmc(struct irdma_sc_dev *dev,
+					    u8 hmc_fn_id);
+/* stats misc */
+enum irdma_status_code irdma_cqp_gather_stats_cmd(struct irdma_sc_dev *dev,
+						  struct irdma_vsi_pestat *pestat,
+						  bool wait);
+enum irdma_status_code irdma_cqp_ws_node_cmd(struct irdma_sc_dev *dev,
+					     u8 cmd,
+					     struct irdma_ws_node_info *node_info);
+enum irdma_status_code irdma_cqp_up_map_cmd(struct irdma_sc_dev *dev,
+					    u8 cmd,
+					    struct irdma_up_info *map_info);
+enum irdma_status_code irdma_cqp_ceq_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_sc_ceq *sc_ceq,
+					 u8 op);
+enum irdma_status_code
+irdma_cqp_stats_inst_cmd(struct irdma_sc_vsi *vsi,
+			 u8 cmd,
+			 struct irdma_stats_inst_info *stats_info);
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
+void irdma_update_stats(struct irdma_dev_hw_stats *hw_stats,
+			struct irdma_gather_stats *gather_stats,
+			struct irdma_gather_stats *last_gather_stats);
+/* vsi functions */
+enum irdma_status_code irdma_vsi_stats_init(struct irdma_sc_vsi *vsi,
+					    struct irdma_vsi_stats_info *info);
+void irdma_vsi_stats_free(struct irdma_sc_vsi *vsi);
+void irdma_sc_vsi_init(struct irdma_sc_vsi *vsi,
+		       struct irdma_vsi_init_info *info);
+enum irdma_status_code irdma_sc_add_cq_ctx(struct irdma_sc_ceq *ceq, struct irdma_sc_cq *cq);
+void irdma_sc_remove_cq_ctx(struct irdma_sc_ceq *ceq, struct irdma_sc_cq *cq);
+/* misc L2 param change functions */
+void irdma_change_l2params(struct irdma_sc_vsi *vsi,
+			   struct irdma_l2params *l2params);
+void irdma_suspend_qps(struct irdma_sc_vsi *vsi);
+void irdma_qp_add_qos(struct irdma_sc_qp *qp);
+void irdma_qp_rem_qos(struct irdma_sc_qp *qp);
+struct irdma_sc_qp *irdma_get_qp_from_list(struct list_head *head,
+					   struct irdma_sc_qp *qp);
+void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi);
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
+enum irdma_status_code irdma_lan_register_qset(struct irdma_sc_vsi *vsi,
+					       struct irdma_ws_node *tc_node);
+void irdma_lan_unregister_qset(struct irdma_sc_vsi *vsi,
+			       struct irdma_ws_node *tc_node);
+/* terminate functions*/
+void irdma_terminate_send_fin(struct irdma_sc_qp *qp);
+
+void irdma_terminate_connection(struct irdma_sc_qp *qp,
+				struct irdma_aeqe_info *info);
+
+void irdma_terminate_received(struct irdma_sc_qp *qp,
+			      struct irdma_aeqe_info *info);
+/* dynamic memory allocation */
+enum irdma_status_code irdma_allocate_dma_mem(struct irdma_hw *hw,
+					      struct irdma_dma_mem *mem,
+					      u64 size,
+					      u32 alignment);
+void irdma_free_dma_mem(struct irdma_hw *hw, struct irdma_dma_mem *mem);
+enum irdma_status_code irdma_allocate_virt_mem(struct irdma_hw *hw,
+					       struct irdma_virt_mem *mem,
+					       u32 size);
+enum irdma_status_code irdma_free_virt_mem(struct irdma_hw *hw,
+					   struct irdma_virt_mem *mem);
+/* misc */
+u8 irdma_get_encoded_wqe_size(u32 wqsize, bool cqpsq);
+void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp);
+enum irdma_status_code irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp,
+							   u64 scratch,
+							   u8 hmc_fn_id,
+							   bool post_sq,
+							   bool poll_registers);
+enum irdma_status_code irdma_cfg_fpm_val(struct irdma_sc_dev *dev,
+					 u32 qp_count);
+enum irdma_status_code irdma_get_rdma_features(struct irdma_sc_dev *dev);
+void free_sd_mem(struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_process_cqp_cmd(struct irdma_sc_dev *dev,
+					     struct cqp_cmds_info *pcmdinfo);
+enum irdma_status_code irdma_process_bh(struct irdma_sc_dev *dev);
+#endif /* IRDMA_PROTOS_H */
diff --git a/drivers/infiniband/hw/irdma/status.h b/drivers/infiniband/hw/irdma/status.h
new file mode 100644
index 0000000..a23e42c
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/status.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef IRDMA_STATUS_H
+#define IRDMA_STATUS_H
+
+/* Error Codes */
+enum irdma_status_code {
+	IRDMA_SUCCESS				= 0,
+	IRDMA_ERR_NVM				= -1,
+	IRDMA_ERR_NVM_CHECKSUM			= -2,
+	IRDMA_ERR_CFG				= -4,
+	IRDMA_ERR_PARAM				= -5,
+	IRDMA_ERR_DEVICE_NOT_SUPPORTED		= -6,
+	IRDMA_ERR_RESET_FAILED			= -7,
+	IRDMA_ERR_SWFW_SYNC			= -8,
+	IRDMA_ERR_NO_MEMORY			= -9,
+	IRDMA_ERR_BAD_PTR			= -10,
+	IRDMA_ERR_INVALID_PD_ID			= -11,
+	IRDMA_ERR_INVALID_QP_ID			= -12,
+	IRDMA_ERR_INVALID_CQ_ID			= -13,
+	IRDMA_ERR_INVALID_CEQ_ID		= -14,
+	IRDMA_ERR_INVALID_AEQ_ID		= -15,
+	IRDMA_ERR_INVALID_SIZE			= -16,
+	IRDMA_ERR_INVALID_ARP_INDEX		= -17,
+	IRDMA_ERR_INVALID_FPM_FUNC_ID		= -18,
+	IRDMA_ERR_QP_INVALID_MSG_SIZE		= -19,
+	IRDMA_ERR_QP_TOOMANY_WRS_POSTED		= -20,
+	IRDMA_ERR_INVALID_FRAG_COUNT		= -21,
+	IRDMA_ERR_Q_EMPTY			= -22,
+	IRDMA_ERR_INVALID_ALIGNMENT		= -23,
+	IRDMA_ERR_FLUSHED_Q			= -24,
+	IRDMA_ERR_INVALID_PUSH_PAGE_INDEX	= -25,
+	IRDMA_ERR_INVALID_INLINE_DATA_SIZE	= -26,
+	IRDMA_ERR_TIMEOUT			= -27,
+	IRDMA_ERR_OPCODE_MISMATCH		= -28,
+	IRDMA_ERR_CQP_COMPL_ERROR		= -29,
+	IRDMA_ERR_INVALID_VF_ID			= -30,
+	IRDMA_ERR_INVALID_HMCFN_ID		= -31,
+	IRDMA_ERR_BACKING_PAGE_ERROR		= -32,
+	IRDMA_ERR_NO_PBLCHUNKS_AVAILABLE	= -33,
+	IRDMA_ERR_INVALID_PBLE_INDEX		= -34,
+	IRDMA_ERR_INVALID_SD_INDEX		= -35,
+	IRDMA_ERR_INVALID_PAGE_DESC_INDEX	= -36,
+	IRDMA_ERR_INVALID_SD_TYPE		= -37,
+	IRDMA_ERR_MEMCPY_FAILED			= -38,
+	IRDMA_ERR_INVALID_HMC_OBJ_INDEX		= -39,
+	IRDMA_ERR_INVALID_HMC_OBJ_COUNT		= -40,
+	IRDMA_ERR_BUF_TOO_SHORT			= -43,
+	IRDMA_ERR_BAD_IWARP_CQE			= -44,
+	IRDMA_ERR_NVM_BLANK_MODE		= -45,
+	IRDMA_ERR_NOT_IMPL			= -46,
+	IRDMA_ERR_PE_DOORBELL_NOT_ENA		= -47,
+	IRDMA_ERR_NOT_READY			= -48,
+	IRDMA_NOT_SUPPORTED			= -49,
+	IRDMA_ERR_FIRMWARE_API_VER		= -50,
+	IRDMA_ERR_RING_FULL			= -51,
+	IRDMA_ERR_MPA_CRC			= -61,
+	IRDMA_ERR_NO_TXBUFS			= -62,
+	IRDMA_ERR_SEQ_NUM			= -63,
+	IRDMA_ERR_list_empty			= -64,
+	IRDMA_ERR_INVALID_MAC_ADDR		= -65,
+	IRDMA_ERR_BAD_STAG			= -66,
+	IRDMA_ERR_CQ_COMPL_ERROR		= -67,
+	IRDMA_ERR_Q_DESTROYED			= -68,
+	IRDMA_ERR_INVALID_FEAT_CNT		= -69,
+	IRDMA_ERR_REG_CQ_FULL			= -70,
+	IRDMA_ERR_VF_MSG_ERROR			= -71,
+};
+#endif /* IRDMA_STATUS_H */
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
new file mode 100644
index 0000000..b2f8788
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -0,0 +1,2565 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include <linux/mii.h>
+#include <linux/in.h>
+#include <linux/init.h>
+#include <asm/irq.h>
+#include <asm/byteorder.h>
+#include <net/neighbour.h>
+#include "main.h"
+
+/**
+ * irdma_arp_table -manage arp table
+ * @rf: RDMA PCI function
+ * @ip_addr: ip address for device
+ * @mac_addr: mac address ptr
+ * @action: modify, delete or add
+ */
+int irdma_arp_table(struct irdma_pci_f *rf,
+		    u32 *ip_addr,
+		    bool ipv4,
+		    u8 *mac_addr,
+		    u32 action)
+{
+	int arp_index;
+	int err;
+	u32 ip[4] = {};
+
+	if (ipv4)
+		ip[0] = *ip_addr;
+	else
+		memcpy(ip, ip_addr, sizeof(ip));
+
+	for (arp_index = 0; (u32)arp_index < rf->arp_table_size; arp_index++)
+		if (!memcmp(rf->arp_table[arp_index].ip_addr, ip, sizeof(ip)))
+			break;
+
+	switch (action) {
+	case IRDMA_ARP_ADD:
+		if (arp_index != rf->arp_table_size)
+			return -1;
+
+		arp_index = 0;
+		err = irdma_alloc_rsrc(rf, rf->allocated_arps,
+				       rf->arp_table_size,
+				       (u32 *)&arp_index,
+				       &rf->next_arp_index);
+		if (err)
+			return err;
+
+		memcpy(rf->arp_table[arp_index].ip_addr, ip,
+		       sizeof(rf->arp_table[arp_index].ip_addr));
+		ether_addr_copy(rf->arp_table[arp_index].mac_addr, mac_addr);
+		break;
+	case IRDMA_ARP_RESOLVE:
+		if (arp_index == rf->arp_table_size)
+			return -1;
+
+		break;
+	case IRDMA_ARP_DELETE:
+		if (arp_index == rf->arp_table_size)
+			return -1;
+
+		memset(rf->arp_table[arp_index].ip_addr, 0,
+		       sizeof(rf->arp_table[arp_index].ip_addr));
+		eth_zero_addr(rf->arp_table[arp_index].mac_addr);
+		irdma_free_rsrc(rf, rf->allocated_arps, arp_index);
+		break;
+	default:
+		return -1;
+	}
+
+	return arp_index;
+}
+
+/**
+ * irdma_add_arp - add a new arp entry if needed
+ * @rf: RDMA function
+ * @ip: IP address
+ * @mac: MAC address
+ */
+int irdma_add_arp(struct irdma_pci_f *rf, u32 *ip, bool ipv4, u8 *mac)
+{
+	int arpidx;
+
+	arpidx = irdma_arp_table(rf, &ip[0], ipv4, NULL, IRDMA_ARP_RESOLVE);
+	if (arpidx >= 0) {
+		if (ether_addr_equal(rf->arp_table[arpidx].mac_addr, mac))
+			return arpidx;
+
+		irdma_manage_arp_cache(rf,
+				       rf->arp_table[arpidx].mac_addr,
+				       ip,
+				       ipv4,
+				       IRDMA_ARP_DELETE);
+	}
+
+	irdma_manage_arp_cache(rf, mac, ip, ipv4, IRDMA_ARP_ADD);
+
+	return irdma_arp_table(rf, ip, ipv4, NULL, IRDMA_ARP_RESOLVE);
+}
+
+/**
+ * wr32 - write 32 bits to hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ * @value: value to write to register
+ */
+inline void wr32(struct irdma_hw *hw, u32 reg, u32 val)
+{
+	writel(val, hw->hw_addr + reg);
+}
+
+/**
+ * rd32 - read a 32 bit hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ *
+ * Return value of register content
+ */
+inline u32 rd32(struct irdma_hw *hw, u32 reg)
+{
+	return readl(hw->hw_addr + reg);
+}
+
+/**
+ * rd64 - read a 64 bit hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ *
+ * Return value of register content
+ */
+inline u64 rd64(struct irdma_hw *hw, u32 reg)
+{
+	return readq(hw->hw_addr + reg);
+}
+
+/**
+ * irdma_inetaddr_event - system notifier for ipv4 addr events
+ * @notfier: not used
+ * @event: event for notifier
+ * @ptr: if address
+ */
+int irdma_inetaddr_event(struct notifier_block *notifier,
+			 unsigned long event,
+			 void *ptr)
+{
+	struct in_ifaddr *ifa = ptr;
+	struct net_device *event_netdev = ifa->ifa_dev->dev;
+	struct net_device *netdev;
+	struct net_device *upper_dev;
+	struct irdma_device *iwdev;
+	u32 local_ipaddr;
+
+	iwdev = irdma_find_netdev(event_netdev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	if (iwdev->init_state < IP_ADDR_REGISTERED || iwdev->closing)
+		return NOTIFY_DONE;
+
+	netdev = iwdev->netdev;
+	upper_dev = netdev_master_upper_dev_get(netdev);
+	if (netdev != event_netdev)
+		return NOTIFY_DONE;
+
+	if (upper_dev) {
+		struct in_device *in;
+
+		rcu_read_lock();
+		in = __in_dev_get_rcu(upper_dev);
+		local_ipaddr = ntohl(in->ifa_list->ifa_address);
+		rcu_read_unlock();
+	} else {
+		local_ipaddr = ntohl(ifa->ifa_address);
+	}
+
+	switch (event) {
+	case NETDEV_DOWN:
+		irdma_manage_arp_cache(iwdev->rf,
+				       netdev->dev_addr,
+				       &local_ipaddr,
+				       true,
+				       IRDMA_ARP_DELETE);
+		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, false);
+		break;
+	case NETDEV_UP:
+		/* Fall through */
+	case NETDEV_CHANGEADDR:
+		irdma_add_arp(iwdev->rf, &local_ipaddr, true, netdev->dev_addr);
+		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, true);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_inet6addr_event - system notifier for ipv6 addr events
+ * @notfier: not used
+ * @event: event for notifier
+ * @ptr: if address
+ */
+int irdma_inet6addr_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr)
+{
+	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
+	struct net_device *event_netdev = ifa->idev->dev;
+	struct net_device *netdev;
+	struct irdma_device *iwdev;
+	u32 local_ipaddr6[4];
+
+	iwdev = irdma_find_netdev(event_netdev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	if (iwdev->init_state < IP_ADDR_REGISTERED || iwdev->closing)
+		return NOTIFY_DONE;
+
+	netdev = iwdev->netdev;
+	if (netdev != event_netdev)
+		return NOTIFY_DONE;
+
+	irdma_copy_ip_ntohl(local_ipaddr6, ifa->addr.in6_u.u6_addr32);
+	switch (event) {
+	case NETDEV_DOWN:
+		irdma_manage_arp_cache(iwdev->rf,
+				       netdev->dev_addr,
+				       local_ipaddr6,
+				       false,
+				       IRDMA_ARP_DELETE);
+		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, false);
+		break;
+	case NETDEV_UP:
+		/* Fall through */
+	case NETDEV_CHANGEADDR:
+		irdma_add_arp(iwdev->rf, local_ipaddr6, false, netdev->dev_addr);
+		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, true);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_net_event - system notifier for net events
+ * @notfier: not used
+ * @event: event for notifier
+ * @ptr: neighbor
+ */
+int irdma_net_event(struct notifier_block *notifier,
+		    unsigned long event,
+		    void *ptr)
+{
+	struct neighbour *neigh = ptr;
+	struct irdma_device *iwdev;
+	__be32 *p;
+	u32 local_ipaddr[4];
+
+	switch (event) {
+	case NETEVENT_NEIGH_UPDATE:
+		iwdev = irdma_find_netdev((struct net_device *)neigh->dev);
+		if (!iwdev)
+			return NOTIFY_DONE;
+
+		if (iwdev->init_state < IP_ADDR_REGISTERED || iwdev->closing)
+			return NOTIFY_DONE;
+
+		p = (__be32 *)neigh->primary_key;
+		irdma_copy_ip_ntohl(local_ipaddr, p);
+		if (neigh->nud_state & NUD_VALID)
+			irdma_add_arp(iwdev->rf, local_ipaddr, false, neigh->ha);
+
+		else
+			irdma_manage_arp_cache(iwdev->rf,
+					       neigh->ha,
+					       local_ipaddr,
+					       false,
+					       IRDMA_ARP_DELETE);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_netdevice_event - system notifier for netdev events
+ * @notfier: not used
+ * @event: event for notifier
+ * @ptr: netdev
+ */
+int irdma_netdevice_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr)
+{
+	struct net_device *event_netdev;
+	struct net_device *netdev;
+	struct irdma_device *iwdev;
+
+	event_netdev = netdev_notifier_info_to_dev(ptr);
+
+	iwdev = irdma_find_netdev(event_netdev);
+	if (!iwdev) {
+		irdma_handle_netdev(event_netdev);
+		return NOTIFY_DONE;
+	}
+
+	if (iwdev->init_state < RDMA_DEV_REGISTERED || iwdev->closing)
+		return NOTIFY_DONE;
+
+	netdev = (struct net_device *)iwdev->netdev;
+	if (netdev != event_netdev)
+		return NOTIFY_DONE;
+
+	iwdev->iw_status = 1;
+
+	switch (event) {
+	case NETDEV_DOWN:
+		iwdev->iw_status = 0;
+		/* Fall through */
+	case NETDEV_UP:
+		irdma_port_ibevent(iwdev);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_get_cqp_request - get cqp struct
+ * @cqp: device cqp ptr
+ * @wait: cqp to be used in wait mode
+ */
+struct irdma_cqp_request *irdma_get_cqp_request(struct irdma_cqp *cqp,
+						bool wait)
+{
+	struct irdma_cqp_request *cqp_request = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cqp->req_lock, flags);
+	if (!list_empty(&cqp->cqp_avail_reqs)) {
+		cqp_request = list_entry(cqp->cqp_avail_reqs.next,
+					 struct irdma_cqp_request, list);
+		list_del_init(&cqp_request->list);
+	}
+	spin_unlock_irqrestore(&cqp->req_lock, flags);
+	if (!cqp_request) {
+		cqp_request = kzalloc(sizeof(*cqp_request), GFP_ATOMIC);
+		if (cqp_request) {
+			cqp_request->dynamic = true;
+			if (wait)
+				init_waitqueue_head(&cqp_request->waitq);
+		}
+	}
+	if (!cqp_request) {
+		irdma_debug(cqp->sc_cqp.dev, IRDMA_DEBUG_ERR,
+			    "CQP Request Fail: No Memory");
+		return NULL;
+	}
+
+	if (wait) {
+		atomic_set(&cqp_request->refcount, 2);
+		cqp_request->waiting = true;
+	} else {
+		atomic_set(&cqp_request->refcount, 1);
+	}
+	memset(&cqp_request->compl_info, 0, sizeof(cqp_request->compl_info));
+
+	return cqp_request;
+}
+
+/**
+ * irdma_free_cqp_request - free cqp request
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+void irdma_free_cqp_request(struct irdma_cqp *cqp,
+			    struct irdma_cqp_request *cqp_request)
+{
+	unsigned long flags;
+
+	if (cqp_request->dynamic) {
+		kfree(cqp_request);
+	} else {
+		cqp_request->request_done = false;
+		cqp_request->callback_fcn = NULL;
+		cqp_request->waiting = false;
+
+		spin_lock_irqsave(&cqp->req_lock, flags);
+		list_add_tail(&cqp_request->list, &cqp->cqp_avail_reqs);
+		spin_unlock_irqrestore(&cqp->req_lock, flags);
+	}
+	wake_up(&cqp->remove_wq);
+}
+
+/**
+ * irdma_put_cqp_request - dec ref count and free if 0
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+void irdma_put_cqp_request(struct irdma_cqp *cqp,
+			   struct irdma_cqp_request *cqp_request)
+{
+	if (atomic_dec_and_test(&cqp_request->refcount))
+		irdma_free_cqp_request(cqp, cqp_request);
+}
+
+/**
+ * irdma_free_pending_cqp_request -free pending cqp request objs
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+static void
+irdma_free_pending_cqp_request(struct irdma_cqp *cqp,
+			       struct irdma_cqp_request *cqp_request)
+{
+	if (cqp_request->waiting) {
+		cqp_request->compl_info.error = true;
+		cqp_request->request_done = true;
+		wake_up(&cqp_request->waitq);
+	}
+	wait_event_timeout(cqp->remove_wq,
+			   atomic_read(&cqp_request->refcount) == 1,
+			   1000);
+	irdma_put_cqp_request(cqp, cqp_request);
+}
+
+/**
+ * irdma_cleanup_pending_cqp_op - clean-up cqp with no
+ * completions
+ * @rf: RDMA PCI function
+ */
+void irdma_cleanup_pending_cqp_op(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cqp *cqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request = NULL;
+	struct cqp_cmds_info *pcmdinfo = NULL;
+	u32 i, pending_work, wqe_idx;
+
+	pending_work = IRDMA_RING_USED_QUANTA(cqp->sc_cqp.sq_ring);
+	wqe_idx = IRDMA_RING_CURRENT_TAIL(cqp->sc_cqp.sq_ring);
+	for (i = 0; i < pending_work; i++) {
+		cqp_request = (struct irdma_cqp_request *)
+			      (unsigned long)cqp->scratch_array[wqe_idx];
+		if (cqp_request)
+			irdma_free_pending_cqp_request(cqp, cqp_request);
+		wqe_idx = (wqe_idx + 1) % IRDMA_RING_SIZE(cqp->sc_cqp.sq_ring);
+	}
+
+	while (!list_empty(&dev->cqp_cmd_head)) {
+		pcmdinfo = (struct cqp_cmds_info *)
+			   irdma_remove_head(&dev->cqp_cmd_head);
+		cqp_request =
+		    container_of(pcmdinfo, struct irdma_cqp_request, info);
+		if (cqp_request)
+			irdma_free_pending_cqp_request(cqp, cqp_request);
+	}
+}
+
+/**
+ * irdma_free_qp_worker - worker for freeing QP resources
+ * @work: ptr to work struct
+ */
+static void irdma_free_qp_worker(struct work_struct *work)
+{
+	struct irdma_qp *iwqp = container_of(work, struct irdma_qp, work);
+
+	irdma_rem_pdusecount(iwqp->iwpd, iwqp->iwdev);
+	irdma_rem_devusecount(iwqp->iwdev);
+	irdma_free_qp_rsrc(iwqp->iwdev, iwqp, iwqp->ibqp.qp_num);
+}
+
+/**
+ * irdma_free_qp - callback after destroy cqp completes
+ * @cqp_request: cqp request for destroy qp
+ * @num: not used
+ */
+static void irdma_free_qp(struct irdma_cqp_request *cqp_request,
+			  u32 num)
+{
+	struct irdma_sc_qp *qp = (struct irdma_sc_qp *)cqp_request->param;
+	struct irdma_qp *iwqp = (struct irdma_qp *)qp->back_qp;
+	struct irdma_device *iwdev = iwqp->iwdev;
+
+	INIT_WORK(&iwqp->work, irdma_free_qp_worker);
+	queue_work(iwdev->rf->free_qp_wq, &iwqp->work);
+}
+
+/**
+ * irdma_wait_event - wait for completion
+ * @rf: RDMA PCI function
+ * @cqp_request: cqp request to wait
+ */
+static int irdma_wait_event(struct irdma_pci_f *rf,
+			    struct irdma_cqp_request *cqp_request)
+{
+	struct cqp_cmds_info *info = &cqp_request->info;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_timeout cqp_timeout = {};
+	bool cqp_error = false;
+	int err_code = 0;
+
+	cqp_timeout.compl_cqp_cmds =
+			rf->sc_dev.cqp_cmd_stats[IRDMA_OP_CMPL_CMDS];
+	do {
+		up(&iwcqp->cqp_compl_sem);
+		if (wait_event_timeout(cqp_request->waitq,
+				       cqp_request->request_done,
+				       msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
+			break;
+
+		rf->sc_dev.cqp_ops->check_cqp_progress(&cqp_timeout,
+						       &rf->sc_dev);
+
+		if (cqp_timeout.count < CQP_TIMEOUT_THRESHOLD)
+			continue;
+
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "error cqp command 0x%x timed out",
+			    info->cqp_cmd);
+		err_code = -ETIME;
+		if (!rf->reset) {
+			rf->reset = true;
+			irdma_request_reset(rf);
+		}
+		goto done;
+	} while (1);
+
+	cqp_error = cqp_request->compl_info.error;
+	if (cqp_error) {
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "error cqp command 0x%x completion maj = 0x%x min=0x%x\n",
+			    info->cqp_cmd,
+			    cqp_request->compl_info.maj_err_code,
+			    cqp_request->compl_info.min_err_code);
+		err_code = -EPROTO;
+		goto done;
+	}
+
+done:
+	irdma_put_cqp_request(iwcqp, cqp_request);
+
+	return err_code;
+}
+
+/**
+ * irdma_handle_cqp_op - process cqp command
+ * @rf: RDMA PCI function
+ * @cqp_request: cqp request to process
+ */
+enum irdma_status_code irdma_handle_cqp_op(struct irdma_pci_f *rf,
+					   struct irdma_cqp_request
+					   *cqp_request)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+	struct cqp_cmds_info *info = &cqp_request->info;
+	int err_code = 0;
+
+	if (rf->reset) {
+		irdma_free_cqp_request(&rf->cqp, cqp_request);
+		return IRDMA_ERR_CQP_COMPL_ERROR;
+	}
+
+	status = irdma_process_cqp_cmd(dev, info);
+	if (status) {
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "error cqp command 0x%x failed\n", info->cqp_cmd);
+		irdma_free_cqp_request(&rf->cqp, cqp_request);
+		return status;
+	}
+
+	if (cqp_request->waiting)
+		err_code = irdma_wait_event(rf, cqp_request);
+	if (err_code)
+		status = IRDMA_ERR_CQP_COMPL_ERROR;
+
+	return status;
+}
+
+/**
+ * irdma_add_devusecount - add dev refcount
+ * @iwdev: dev for refcount
+ */
+void irdma_add_devusecount(struct irdma_device *iwdev)
+{
+	atomic64_inc(&iwdev->use_count);
+}
+
+/**
+ * irdma_rem_devusecount - decrement refcount for dev
+ * @iwdev: device
+ */
+void irdma_rem_devusecount(struct irdma_device *iwdev)
+{
+	if (!atomic64_dec_and_test(&iwdev->use_count))
+		return;
+	wake_up(&iwdev->close_wq);
+}
+
+/**
+ * irdma_add_pdusecount - add pd refcount
+ * @iwpd: pd for refcount
+ */
+void irdma_add_pdusecount(struct irdma_pd *iwpd)
+{
+	atomic_inc(&iwpd->usecount);
+}
+
+/**
+ * irdma_rem_pdusecount - decrement refcount for pd and free if 0
+ * @iwpd: pd for refcount
+ * @iwdev: iwarp device
+ */
+void irdma_rem_pdusecount(struct irdma_pd *iwpd,
+			  struct irdma_device *iwdev)
+{
+	if (!atomic_dec_and_test(&iwpd->usecount))
+		return;
+	irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_pds, iwpd->sc_pd.pd_id);
+}
+
+/**
+ * irdma_add_ref - add refcount for qp
+ * @ibqp: iqarp qp
+ */
+void irdma_add_ref(struct ib_qp *ibqp)
+{
+	struct irdma_qp *iwqp = (struct irdma_qp *)ibqp;
+
+	atomic_inc(&iwqp->refcount);
+}
+
+/**
+ * irdma_rem_ref - rem refcount for qp and free if 0
+ * @ibqp: iqarp qp
+ */
+void irdma_rem_ref(struct ib_qp *ibqp)
+{
+	struct irdma_qp *iwqp;
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_device *iwdev;
+	u32 qp_num;
+	unsigned long flags;
+
+	iwqp = to_iwqp(ibqp);
+	iwdev = iwqp->iwdev;
+	spin_lock_irqsave(&iwdev->rf->qptable_lock, flags);
+	if (!atomic_dec_and_test(&iwqp->refcount)) {
+		spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+		return;
+	}
+
+	qp_num = iwqp->ibqp.qp_num;
+	iwdev->rf->qp_table[qp_num] = NULL;
+	spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+	cqp_request = irdma_get_cqp_request(&iwdev->rf->cqp, false);
+	if (!cqp_request)
+		return;
+
+	cqp_request->callback_fcn = irdma_free_qp;
+	cqp_request->param = (void *)&iwqp->sc_qp;
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_QP_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_destroy.qp = &iwqp->sc_qp;
+	cqp_info->in.u.qp_destroy.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.qp_destroy.remove_hash_idx = true;
+	status = irdma_handle_cqp_op(iwdev->rf, cqp_request);
+	if (!status)
+		return;
+
+	irdma_debug(&iwdev->rf->sc_dev, IRDMA_DEBUG_ERR,
+		    "CQP-OP Destroy QP fail");
+	irdma_rem_pdusecount(iwqp->iwpd, iwdev);
+	irdma_free_qp_rsrc(iwdev, iwqp, qp_num);
+	irdma_rem_devusecount(iwdev);
+}
+
+/**
+ * irdma_get_qp - get qp address
+ * @device: iwarp device
+ * @qpn: qp number
+ */
+struct ib_qp *irdma_get_qp(struct ib_device *device,
+			   int qpn)
+{
+	struct irdma_device *iwdev = to_iwdev(device);
+
+	if (qpn < IW_FIRST_QPN || qpn >= iwdev->rf->max_qp)
+		return NULL;
+
+	return &iwdev->rf->qp_table[qpn]->ibqp;
+}
+
+/**
+ * irdma_get_hw_addr - return hw addr
+ * @par: points to shared dev
+ */
+u8 __iomem *irdma_get_hw_addr(void *par)
+{
+	struct irdma_sc_dev *dev = (struct irdma_sc_dev *)par;
+
+	return dev->hw->hw_addr;
+}
+
+/**
+ * irdma_remove_head - return head entry and remove from list
+ * @list: list for entry
+ */
+void *irdma_remove_head(struct list_head *list)
+{
+	struct list_head *entry;
+
+	if (list_empty(list))
+		return NULL;
+
+	entry = (void *)list->next;
+	list_del(entry);
+
+	return (void *)entry;
+}
+
+/**
+ * irdma_allocate_dma_mem - Memory alloc helper fn
+ * @hw:   pointer to the HW structure
+ * @mem:  ptr to mem struct to fill out
+ * @size: size of memory requested
+ * @alignment: what to align the allocation to
+ */
+enum irdma_status_code irdma_allocate_dma_mem(struct irdma_hw *hw,
+					      struct irdma_dma_mem *mem,
+					      u64 size,
+					      u32 alignment)
+{
+	struct pci_dev *pcidev = (struct pci_dev *)hw->dev_context;
+
+	if (!mem)
+		return IRDMA_ERR_PARAM;
+
+	mem->size = ALIGN(size, alignment);
+	mem->va = dma_alloc_coherent(&pcidev->dev, mem->size,
+				     (dma_addr_t *)&mem->pa, GFP_KERNEL);
+	if (!mem->va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	return 0;
+}
+
+/**
+ * irdma_free_dma_mem - Memory free helper fn
+ * @hw:   pointer to the HW structure
+ * @mem:  ptr to mem struct to free
+ */
+void irdma_free_dma_mem(struct irdma_hw *hw,
+			struct irdma_dma_mem *mem)
+{
+	struct pci_dev *pcidev = (struct pci_dev *)hw->dev_context;
+
+	if (!mem || !mem->va)
+		return;
+
+	dma_free_coherent(&pcidev->dev, mem->size,
+			  mem->va, (dma_addr_t)mem->pa);
+
+	mem->va = NULL;
+}
+
+/**
+ * irdma_allocate_virt_mem - virtual memory alloc helper fn
+ * @hw:   pointer to the HW structure
+ * @mem:  ptr to mem struct to fill out
+ * @size: size of memory requested
+ */
+enum irdma_status_code irdma_allocate_virt_mem(struct irdma_hw *hw,
+					       struct irdma_virt_mem *mem,
+					       u32 size)
+{
+	if (!mem)
+		return IRDMA_ERR_PARAM;
+
+	mem->size = size;
+	mem->va = kzalloc(size, GFP_ATOMIC);
+
+	if (mem->va)
+		return 0;
+	else
+		return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_free_virt_mem - virtual memory free helper fn
+ * @hw:   pointer to the HW structure
+ * @mem:  ptr to mem struct to free
+ */
+enum irdma_status_code irdma_free_virt_mem(struct irdma_hw *hw,
+					   struct irdma_virt_mem *mem)
+{
+	if (!mem)
+		return IRDMA_ERR_PARAM;
+	kfree(mem->va);
+	return 0;
+}
+
+/**
+ * irdma_cqp_sds_cmd - create cqp command for sd
+ * @dev: hardware control device structure
+ * @sd_info: information  for sd cqp
+ *
+ */
+enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_update_sds_info *sdinfo)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memcpy(&cqp_info->in.u.update_pe_sds.info, sdinfo,
+	       sizeof(cqp_info->in.u.update_pe_sds.info));
+	cqp_info->cqp_cmd = IRDMA_OP_UPDATE_PE_SDS;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.update_pe_sds.dev = dev;
+	cqp_info->in.u.update_pe_sds.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP Update SD's fail");
+
+	return status;
+}
+
+/**
+ * irdma_qp_suspend_resume - cqp command for suspend/resume
+ * @qp: hardware control qp
+ * @suspend: flag if suspend or resume
+ */
+enum irdma_status_code irdma_qp_suspend_resume(struct irdma_sc_qp *qp,
+					       bool suspend)
+{
+	struct irdma_sc_dev *dev = qp->dev;
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct irdma_sc_cqp *cqp = dev->cqp;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = (suspend) ? IRDMA_OP_SUSPEND : IRDMA_OP_RESUME;
+	cqp_info->in.u.suspend_resume.cqp = cqp;
+	cqp_info->in.u.suspend_resume.qp = qp;
+	cqp_info->in.u.suspend_resume.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR,
+			    "CQP-OP QP Suspend/Resume fail");
+
+	return status;
+}
+
+/**
+ * irdma_term_modify_qp - modify qp for term message
+ * @qp: hardware control qp
+ * @next_state: qp's next state
+ * @term: terminate code
+ * @term_len: length
+ */
+void irdma_term_modify_qp(struct irdma_sc_qp *qp,
+			  u8 next_state,
+			  u8 term,
+			  u8 term_len)
+{
+	struct irdma_qp *iwqp;
+
+	iwqp = (struct irdma_qp *)qp->back_qp;
+	irdma_next_iw_state(iwqp, next_state, 0, term, term_len);
+};
+
+/**
+ * irdma_terminate_done - after terminate is completed
+ * @qp: hardware control qp
+ * @timeout_occurred: indicates if terminate timer expired
+ */
+void irdma_terminate_done(struct irdma_sc_qp *qp,
+			  int timeout_occurred)
+{
+	struct irdma_qp *iwqp;
+	u32 next_iwarp_state = IRDMA_QP_STATE_ERROR;
+	u8 hte = 0;
+	bool first_time;
+	unsigned long flags;
+
+	iwqp = (struct irdma_qp *)qp->back_qp;
+	spin_lock_irqsave(&iwqp->lock, flags);
+	if (iwqp->hte_added) {
+		iwqp->hte_added = 0;
+		hte = 1;
+	}
+	first_time = !(qp->term_flags & IRDMA_TERM_DONE);
+	qp->term_flags |= IRDMA_TERM_DONE;
+	spin_unlock_irqrestore(&iwqp->lock, flags);
+	if (first_time) {
+		if (!timeout_occurred)
+			irdma_terminate_del_timer(qp);
+		else
+			next_iwarp_state = IRDMA_QP_STATE_CLOSING;
+
+		irdma_next_iw_state(iwqp, next_iwarp_state, hte, 0, 0);
+		irdma_cm_disconn(iwqp);
+	}
+}
+
+static void irdma_terminate_timeout(struct timer_list *t)
+{
+	struct irdma_qp *iwqp = from_timer(iwqp, t, terminate_timer);
+	struct irdma_sc_qp *qp = (struct irdma_sc_qp *)&iwqp->sc_qp;
+
+	irdma_terminate_done(qp, 1);
+	irdma_rem_ref(&iwqp->ibqp);
+}
+
+/**
+ * irdma_terminate_start_timer - start terminate timeout
+ * @qp: hardware control qp
+ */
+void irdma_terminate_start_timer(struct irdma_sc_qp *qp)
+{
+	struct irdma_qp *iwqp;
+
+	iwqp = (struct irdma_qp *)qp->back_qp;
+	irdma_add_ref(&iwqp->ibqp);
+	timer_setup(&iwqp->terminate_timer, irdma_terminate_timeout, 0);
+	iwqp->terminate_timer.expires = jiffies + HZ;
+
+	add_timer(&iwqp->terminate_timer);
+}
+
+/**
+ * irdma_terminate_del_timer - delete terminate timeout
+ * @qp: hardware control qp
+ */
+void irdma_terminate_del_timer(struct irdma_sc_qp *qp)
+{
+	struct irdma_qp *iwqp;
+	int ret;
+
+	iwqp = (struct irdma_qp *)qp->back_qp;
+	ret = del_timer(&iwqp->terminate_timer);
+	if (ret)
+		irdma_rem_ref(&iwqp->ibqp);
+}
+
+/**
+ * irdma_cqp_query_fpm_values_cmd - send cqp command for fpm
+ * @iwdev: function device struct
+ * @val_mem: buffer for fpm
+ * @hmc_fn_id: function id for fpm
+ */
+enum irdma_status_code
+irdma_cqp_query_fpm_val_cmd(struct irdma_sc_dev *dev,
+			    struct irdma_dma_mem *val_mem,
+			    u8 hmc_fn_id)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_request->param = NULL;
+	cqp_info->in.u.query_fpm_val.cqp = dev->cqp;
+	cqp_info->in.u.query_fpm_val.fpm_val_pa = val_mem->pa;
+	cqp_info->in.u.query_fpm_val.fpm_val_va = val_mem->va;
+	cqp_info->in.u.query_fpm_val.hmc_fn_id = hmc_fn_id;
+	cqp_info->cqp_cmd = IRDMA_OP_QUERY_FPM_VAL;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.query_fpm_val.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP Query FPM fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_commit_fpm_values_cmd - commit fpm values in hw
+ * @dev: hardware control device structure
+ * @val_mem: buffer with fpm values
+ * @hmc_fn_id: function id for fpm
+ */
+enum irdma_status_code
+irdma_cqp_commit_fpm_val_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_dma_mem *val_mem,
+			     u8 hmc_fn_id)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_request->param = NULL;
+	cqp_info->in.u.commit_fpm_val.cqp = dev->cqp;
+	cqp_info->in.u.commit_fpm_val.fpm_val_pa = val_mem->pa;
+	cqp_info->in.u.commit_fpm_val.fpm_val_va = val_mem->va;
+	cqp_info->in.u.commit_fpm_val.hmc_fn_id = hmc_fn_id;
+	cqp_info->cqp_cmd = IRDMA_OP_COMMIT_FPM_VAL;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.commit_fpm_val.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP Commit FPM fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_cq_create_cmd - create a cq for the cqp
+ * @dev: device pointer
+ * @cq: pointer to created cq
+ */
+enum irdma_status_code
+irdma_cqp_cq_create_cmd(struct irdma_sc_dev *dev, struct irdma_sc_cq *cq)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_CQ_CREATE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.cq_create.cq = cq;
+	cqp_info->in.u.cq_create.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP Create CQ fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_qp_create_cmd - create a qp for the cqp
+ * @dev: device pointer
+ * @qp: pointer to created qp
+ */
+enum irdma_status_code irdma_cqp_qp_create_cmd(struct irdma_sc_dev *dev,
+					       struct irdma_sc_qp *qp)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_create_qp_info *qp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	qp_info = &cqp_request->info.in.u.qp_create.info;
+	memset(qp_info, 0, sizeof(*qp_info));
+	qp_info->cq_num_valid = true;
+	qp_info->next_iwarp_state = IRDMA_QP_STATE_RTS;
+	cqp_info->cqp_cmd = IRDMA_OP_QP_CREATE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_create.qp = qp;
+	cqp_info->in.u.qp_create.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP QP create fail");
+
+	return status;
+}
+
+/**
+ * irdma_dealloc_push_page - free a push page for qp
+ * @rf: RDMA PCI function
+ * @qp: hardware control qp
+ */
+static void irdma_dealloc_push_page(struct irdma_pci_f *rf,
+				    struct irdma_sc_qp *qp)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX)
+		return;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_MANAGE_PUSH_PAGE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.manage_push_page.info.push_idx = qp->push_idx;
+	cqp_info->in.u.manage_push_page.info.qs_handle = qp->qs_handle;
+	cqp_info->in.u.manage_push_page.info.free_page = 1;
+	cqp_info->in.u.manage_push_page.cqp = &rf->cqp.sc_cqp;
+	cqp_info->in.u.manage_push_page.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (!status)
+		qp->push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
+	else
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "CQP-OP dealloc Push page fail");
+}
+
+/**
+ * irdma_free_qp_resources - free up memory resources for qp
+ * @iwdev: iwarp device
+ * @iwqp: qp ptr (user or kernel)
+ * @qp_num: qp number assigned
+ */
+void irdma_free_qp_rsrc(struct irdma_device *iwdev,
+			struct irdma_qp *iwqp,
+			u32 qp_num)
+{
+	struct irdma_pci_f *rf = iwdev->rf;
+
+	irdma_ieq_cleanup_qp(iwdev->vsi.ieq, &iwqp->sc_qp);
+	irdma_dealloc_push_page(rf, &iwqp->sc_qp);
+	if (iwqp->sc_qp.vsi)
+		iwqp->sc_qp.dev->ws_remove(iwqp->sc_qp.vsi, iwqp->sc_qp.user_pri);
+
+	if (qp_num > 2)
+		irdma_free_rsrc(rf, rf->allocated_qps, qp_num);
+	irdma_free_dma_mem(rf->sc_dev.hw, &iwqp->q2_ctx_mem);
+	irdma_free_dma_mem(rf->sc_dev.hw, &iwqp->kqp.dma_mem);
+	kfree(iwqp->kqp.wrid_mem);
+	iwqp->kqp.wrid_mem = NULL;
+	kfree(iwqp->allocated_buf);
+}
+
+/**
+ * irdma_cq_wq_destroy - send cq destroy cqp
+ * @rf: RDMA PCI function
+ * @cq: hardware control cq
+ */
+void irdma_cq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_cq *cq)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_CQ_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.cq_destroy.cq = cq;
+	cqp_info->in.u.cq_destroy.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "CQP-OP Destroy CQ fail");
+}
+
+/**
+ * irdma_hw_modify_qp_callback - handle state for modifyQPs that don't wait
+ * @cqp_request: modify QP completion
+ * @num: not used
+ */
+static void irdma_hw_modify_qp_callback(struct irdma_cqp_request *cqp_request,
+					u32 num)
+{
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_qp *iwqp;
+
+	cqp_info = &cqp_request->info;
+	iwqp = cqp_info->in.u.qp_modify.qp->back_qp;
+	atomic_dec(&iwqp->hw_mod_qp_pend);
+	wake_up(&iwqp->mod_qp_waitq);
+}
+
+/**
+ * irdma_hw_modify_qp - setup cqp for modify qp
+ * @rf: RDMA PCI function
+ * @iwqp: qp ptr (user or kernel)
+ * @info: info for modify qp
+ * @wait: flag to wait or not for modify qp completion
+ */
+enum irdma_status_code irdma_hw_modify_qp(struct irdma_device *iwdev,
+					  struct irdma_qp *iwqp,
+					  struct irdma_modify_qp_info *info,
+					  bool wait)
+{
+	enum irdma_status_code status;
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_modify_qp_info *m_info;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	if (!wait) {
+		cqp_request->callback_fcn = irdma_hw_modify_qp_callback;
+		atomic_inc(&iwqp->hw_mod_qp_pend);
+	}
+	cqp_info = &cqp_request->info;
+	m_info = &cqp_info->in.u.qp_modify.info;
+	memcpy(m_info, info, sizeof(*m_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_MODIFY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_modify.qp = &iwqp->sc_qp;
+	cqp_info->in.u.qp_modify.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		if (rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1))
+			return status;
+		switch (m_info->next_iwarp_state) {
+			struct irdma_gen_ae_info ae_info;
+
+		case IRDMA_QP_STATE_RTS:
+		case IRDMA_QP_STATE_IDLE:
+		case IRDMA_QP_STATE_TERMINATE:
+		case IRDMA_QP_STATE_CLOSING:
+			if (info->curr_iwarp_state == IRDMA_QP_STATE_IDLE)
+				irdma_send_reset(iwqp->cm_node);
+			else
+				iwqp->sc_qp.term_flags = IRDMA_TERM_DONE;
+			if (!wait) {
+				ae_info.ae_code = IRDMA_AE_BAD_CLOSE;
+				ae_info.ae_src = 0;
+				irdma_gen_ae(rf, &iwqp->sc_qp, &ae_info, false);
+			} else {
+				cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+				if (!cqp_request)
+					return IRDMA_ERR_NO_MEMORY;
+
+				cqp_info = &cqp_request->info;
+				m_info = &cqp_info->in.u.qp_modify.info;
+				memcpy(m_info, info, sizeof(*m_info));
+				cqp_info->cqp_cmd = IRDMA_OP_QP_MODIFY;
+				cqp_info->post_sq = 1;
+				cqp_info->in.u.qp_modify.qp = &iwqp->sc_qp;
+				cqp_info->in.u.qp_modify.scratch = (uintptr_t)cqp_request;
+				m_info->next_iwarp_state = IRDMA_QP_STATE_ERROR;
+				m_info->reset_tcp_conn = true;
+				irdma_handle_cqp_op(rf, cqp_request);
+			}
+			break;
+		case IRDMA_QP_STATE_ERROR:
+		default:
+			break;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * irdma_cqp_cq_destroy_cmd - destroy the cqp cq
+ * @dev: device pointer
+ * @cq: pointer to cq
+ */
+void irdma_cqp_cq_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_cq *cq)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	irdma_cq_wq_destroy(rf, cq);
+}
+
+/**
+ * irdma_cqp_qp_destroy_cmd - destroy the cqp
+ * @dev: device pointer
+ * @qp: pointer to qp
+ */
+void irdma_cqp_qp_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_destroy.qp = qp;
+	cqp_info->in.u.qp_destroy.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.qp_destroy.remove_hash_idx = true;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP QP_DESTROY fail");
+}
+
+/**
+ * irdma_ieq_mpa_crc_ae - generate AE for crc error
+ * @dev: hardware control device structure
+ * @qp: hardware control qp
+ */
+void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev,
+			  struct irdma_sc_qp *qp)
+{
+	struct irdma_gen_ae_info info = {};
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	irdma_debug(dev, IRDMA_DEBUG_AEQ, "Generate MPA CRC AE\n");
+	info.ae_code = IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR;
+	info.ae_src = IRDMA_AE_SOURCE_RQ;
+	irdma_gen_ae(rf, qp, &info, false);
+}
+
+/**
+ * irdma_init_hash_desc - initialize hash for crc calculation
+ * @desc: cryption type
+ */
+enum irdma_status_code irdma_init_hash_desc(struct shash_desc **desc)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *tdesc;
+
+	tfm = crypto_alloc_shash("crc32c", 0, 0);
+	if (IS_ERR(tfm))
+		return IRDMA_ERR_MPA_CRC;
+
+	tdesc = kzalloc(sizeof(*tdesc) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!tdesc) {
+		crypto_free_shash(tfm);
+		return IRDMA_ERR_MPA_CRC;
+	}
+
+	tdesc->tfm = tfm;
+	*desc = tdesc;
+
+	return 0;
+}
+
+/**
+ * irdma_free_hash_desc - free hash desc
+ * @desc: to be freed
+ */
+void irdma_free_hash_desc(struct shash_desc *desc)
+{
+	if (desc) {
+		crypto_free_shash(desc->tfm);
+		kfree(desc);
+	}
+}
+
+/**
+ * irdma_ieq_check_mpacrc - check if mpa crc is OK
+ * @desc: desc for hash
+ * @addr: address of buffer for crc
+ * @length: length of buffer
+ * @value: value to be compared
+ */
+enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
+					      void *addr,
+					      u32 len,
+					      u32 val)
+{
+	u32 crc = 0;
+	int ret;
+	enum irdma_status_code ret_code = 0;
+
+	crypto_shash_init(desc);
+	ret = crypto_shash_update(desc, addr, len);
+	if (!ret)
+		crypto_shash_final(desc, (u8 *)&crc);
+	if (crc != val) {
+		irdma_pr_err("mpa crc check fail");
+		ret_code = IRDMA_ERR_MPA_CRC;
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_ieq_get_qp - get qp based on quad in puda buffer
+ * @dev: hardware control device structure
+ * @buf: receive puda buffer on exception q
+ */
+struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
+				     struct irdma_puda_buf *buf)
+{
+	struct irdma_qp *iwqp;
+	struct irdma_cm_node *cm_node;
+	struct irdma_device *iwdev = buf->vsi->back_vsi;
+	u32 loc_addr[4] = {};
+	u32 rem_addr[4] = {};
+	u16 loc_port, rem_port;
+	struct ipv6hdr *ip6h;
+	struct iphdr *iph = (struct iphdr *)buf->iph;
+	struct tcphdr *tcph = (struct tcphdr *)buf->tcph;
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct udphdr *udph;
+	struct irdma_bth *bth;
+
+	if (iph->protocol == IPPROTO_UDP) {
+		udph = (struct udphdr *)tcph;
+		bth = (struct irdma_bth *)udph + sizeof(*udph);
+		iwqp = rf->qp_table[be32_to_cpu(bth->qpn)];
+		return &iwqp->sc_qp;
+	}
+
+	if (iph->version == 4) {
+		loc_addr[0] = ntohl(iph->daddr);
+		rem_addr[0] = ntohl(iph->saddr);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		irdma_copy_ip_ntohl(loc_addr, ip6h->daddr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(rem_addr, ip6h->saddr.in6_u.u6_addr32);
+	}
+	loc_port = ntohs(tcph->dest);
+	rem_port = ntohs(tcph->source);
+	cm_node = irdma_find_node(&iwdev->cm_core, rem_port, rem_addr, loc_port,
+				  loc_addr, false, true);
+	if (!cm_node)
+		return NULL;
+
+	iwqp = cm_node->iwqp;
+
+	return &iwqp->sc_qp;
+}
+
+/**
+ * irdma_send_ieq_ack - ACKs for duplicate or OOO partials FPDUs
+ * @qp: qp ptr
+ */
+void irdma_send_ieq_ack(struct irdma_sc_qp *qp)
+{
+	struct irdma_cm_node *cm_node = ((struct irdma_qp *)qp->back_qp)->cm_node;
+	struct irdma_puda_buf *buf = qp->pfpdu.lastrcv_buf;
+	struct tcphdr *tcph = (struct tcphdr *)buf->tcph;
+
+	cm_node->tcp_cntxt.rcv_nxt = qp->pfpdu.nextseqnum;
+	cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
+
+	irdma_send_ack(cm_node);
+}
+
+/**
+ * irdma_puda_ieq_get_ah_info - get AH info from IEQ buffer
+ * @qp: qp pointer
+ * @ah_info: AH info pointer
+ */
+void irdma_puda_ieq_get_ah_info(struct irdma_sc_qp *qp,
+				struct irdma_ah_info *ah_info)
+{
+	struct irdma_puda_buf *buf = qp->pfpdu.ah_buf;
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+
+	memset(ah_info, 0, sizeof(*ah_info));
+	ah_info->do_lpbk = true;
+	ah_info->vlan_tag = buf->vlan_id;
+	ah_info->insert_vlan_tag = buf->vlan_valid;
+	ah_info->ipv4_valid = buf->ipv4;
+	ah_info->vsi = qp->vsi;
+
+	if (buf->smac_valid)
+		ether_addr_copy(ah_info->mac_addr, buf->smac);
+
+	if (buf->ipv4) {
+		ah_info->ipv4_valid = true;
+		iph = (struct iphdr *)buf->iph;
+		ah_info->hop_ttl = iph->ttl;
+		ah_info->tc_tos = iph->tos;
+		ah_info->dest_ip_addr[0] = ntohl(iph->daddr);
+		ah_info->src_ip_addr[0] = ntohl(iph->saddr);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		ah_info->hop_ttl = ip6h->hop_limit;
+		ah_info->tc_tos = ip6h->priority;
+		irdma_copy_ip_ntohl(ah_info->dest_ip_addr,
+				    ip6h->daddr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(ah_info->src_ip_addr,
+				    ip6h->saddr.in6_u.u6_addr32);
+	}
+
+	ah_info->dst_arpindex = irdma_arp_table(qp->dev->back_dev,
+						ah_info->dest_ip_addr,
+						ah_info->ipv4_valid,
+						NULL, IRDMA_ARP_RESOLVE);
+}
+
+/**
+ * irdma_gen1_ieq_update_tcpip_info - update tcpip in the buffer
+ * @buf: puda to update
+ * @length: length of buffer
+ * @seqnum: seq number for tcp
+ */
+static void irdma_gen1_ieq_update_tcpip_info(struct irdma_puda_buf *buf,
+					     u16 len,
+					     u32 seqnum)
+{
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	u16 iphlen;
+	u16 pktsize;
+	u8 *addr = (u8 *)buf->mem.va;
+
+	iphlen = (buf->ipv4) ? 20 : 40;
+	iph = (struct iphdr *)(addr + buf->maclen);
+	tcph = (struct tcphdr *)(addr + buf->maclen + iphlen);
+	pktsize = len + buf->tcphlen + iphlen;
+	iph->tot_len = htons(pktsize);
+	tcph->seq = htonl(seqnum);
+}
+
+/**
+ * irdma_ieq_update_tcpip_info - update tcpip in the buffer
+ * @buf: puda to update
+ * @length: length of buffer
+ * @seqnum: seq number for tcp
+ */
+void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf,
+				 u16 len,
+				 u32 seqnum)
+{
+	struct tcphdr *tcph;
+	u16 pktsize;
+	u8 *addr;
+
+	if (buf->vsi->dev->hw_attrs.hw_rev == IRDMA_GEN_1)
+		return irdma_gen1_ieq_update_tcpip_info(buf, len, seqnum);
+
+	addr = (u8 *)buf->mem.va;
+	tcph = (struct tcphdr *)addr;
+	pktsize = len + buf->tcphlen;
+	tcph->seq = htonl(seqnum);
+}
+
+/**
+ * irdma_gen1_puda_get_tcpip_info - get tcpip info from puda
+ * buffer
+ * @info: to get information
+ * @buf: puda buffer
+ */
+static enum irdma_status_code
+irdma_gen1_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			       struct irdma_puda_buf *buf)
+{
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcph;
+	u16 iphlen;
+	u16 pkt_len;
+	u8 *mem = (u8 *)buf->mem.va;
+	struct ethhdr *ethh = (struct ethhdr *)buf->mem.va;
+
+	if (ethh->h_proto == htons(0x8100)) {
+		info->vlan_valid = true;
+		buf->vlan_id = ntohs(((struct vlan_ethhdr *)ethh)->h_vlan_TCI) &
+			       VLAN_VID_MASK;
+	}
+
+	buf->maclen = (info->vlan_valid) ? 18 : 14;
+	iphlen = (info->l3proto) ? 40 : 20;
+	buf->ipv4 = (info->l3proto) ? false : true;
+	buf->iph = mem + buf->maclen;
+	iph = (struct iphdr *)buf->iph;
+	buf->tcph = buf->iph + iphlen;
+	tcph = (struct tcphdr *)buf->tcph;
+
+	if (buf->ipv4) {
+		pkt_len = ntohs(iph->tot_len);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		pkt_len = ntohs(ip6h->payload_len) + iphlen;
+	}
+
+	buf->totallen = pkt_len + buf->maclen;
+
+	if (info->payload_len < buf->totallen) {
+		irdma_debug(buf->vsi->dev, IRDMA_DEBUG_ERR,
+			    "payload_len = 0x%x totallen expected0x%x\n",
+			    info->payload_len, buf->totallen);
+		return IRDMA_ERR_INVALID_SIZE;
+	}
+
+	buf->tcphlen = (tcph->doff) << 2;
+	buf->datalen = pkt_len - iphlen - buf->tcphlen;
+	buf->data = (buf->datalen) ? buf->tcph + buf->tcphlen : NULL;
+	buf->hdrlen = buf->maclen + iphlen + buf->tcphlen;
+	buf->seqnum = ntohl(tcph->seq);
+
+	return 0;
+}
+
+/**
+ * irdma_puda_get_tcpip_info - get tcpip info from puda buffer
+ * @info: to get information
+ * @buf: puda buffer
+ */
+enum irdma_status_code
+irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			  struct irdma_puda_buf *buf)
+{
+	struct tcphdr *tcph;
+	u32 pkt_len;
+	u8 *mem;
+
+	if (buf->vsi->dev->hw_attrs.hw_rev == IRDMA_GEN_1)
+		return irdma_gen1_puda_get_tcpip_info(info, buf);
+
+	mem = (u8 *)buf->mem.va;
+	buf->vlan_valid = info->vlan_valid;
+	if (info->vlan_valid)
+		buf->vlan_id = info->vlan;
+
+	buf->ipv4 = info->ipv4;
+	if (buf->ipv4)
+		buf->iph = mem + 20;
+	else
+		buf->iph = mem;
+
+	buf->tcph = mem + IRDMA_TCP_OFFSET;
+	tcph = (struct tcphdr *)buf->tcph;
+	pkt_len = info->payload_len;
+	buf->totallen = pkt_len;
+	buf->tcphlen = (tcph->doff) << 2;
+	buf->datalen = pkt_len - IRDMA_TCP_OFFSET - buf->tcphlen;
+	buf->data = (buf->datalen) ? buf->tcph + buf->tcphlen : NULL;
+	buf->hdrlen = IRDMA_TCP_OFFSET + buf->tcphlen;
+	buf->seqnum = ntohl(tcph->seq);
+
+	if (info->smac_valid) {
+		ether_addr_copy(buf->smac, info->smac);
+		buf->smac_valid = true;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_process_stats - Checking for wrap and update stats
+ *
+ * @pestat: stats structure pointer
+ */
+static void irdma_process_stats(struct irdma_vsi_pestat *pestat)
+{
+	struct irdma_gather_stats *gather_stats =
+					pestat->gather_info.gather_stats;
+	struct irdma_gather_stats *last_gather_stats =
+					pestat->gather_info.last_gather_stats;
+	irdma_update_stats(&pestat->hw_stats, gather_stats, last_gather_stats);
+}
+
+/**
+ * irdma_cqp_gather_stats_gen1 - Gather stats
+ * @vsi: pointer to vsi structure
+ * @gather_info: pointer to gather stats info
+ */
+static void irdma_cqp_gather_stats_gen1(struct irdma_sc_dev *dev,
+					struct irdma_vsi_pestat *pestat)
+{
+	struct irdma_gather_stats *gather_stats = pestat->gather_info.gather_stats;
+	u32 stats_inst_offset_32;
+	u32 stats_inst_offset_64;
+
+	stats_inst_offset_32 = (pestat->gather_info.use_stats_inst) ?
+		pestat->gather_info.stats_inst_index : pestat->hw->hmc.hmc_fn_id;
+	stats_inst_offset_32 *= 4;
+	stats_inst_offset_64 = stats_inst_offset_32 * 2;
+
+	gather_stats->rxvlanerr =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_RXVLANERR]
+		     + stats_inst_offset_32);
+	gather_stats->ip4rxdiscard =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4RXDISCARD]
+		     + stats_inst_offset_32);
+	gather_stats->ip4rxtrunc =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4RXTRUNC]
+		     + stats_inst_offset_32);
+	gather_stats->ip4txnoroute =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4TXNOROUTE]
+		     + stats_inst_offset_32);
+	gather_stats->ip6rxdiscard =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6RXDISCARD]
+		     + stats_inst_offset_32);
+	gather_stats->ip6rxtrunc =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6RXTRUNC]
+		     + stats_inst_offset_32);
+	gather_stats->ip6txnoroute =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6TXNOROUTE]
+		     + stats_inst_offset_32);
+	gather_stats->tcprtxseg =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_TCPRTXSEG]
+		     + stats_inst_offset_32);
+	gather_stats->tcprxopterr =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_TCPRXOPTERR]
+		     + stats_inst_offset_32);
+
+	gather_stats->ip4rxocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4rxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txfrag =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4rxmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txfrag =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txfrags =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txfrags =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->tcprxsegs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_TCPRXSEGS]
+		     + stats_inst_offset_64);
+	gather_stats->tcptxsegs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_TCPTXSEG]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxrds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXRDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxsnds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXSNDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxwrs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXWRS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxrds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXRDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxsnds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXSNDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxwrs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXWRS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmavbn =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMAVBND]
+		     + stats_inst_offset_64);
+	gather_stats->rdmavinv =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMAVINV]
+		     + stats_inst_offset_64);
+	gather_stats->udprxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_UDPRXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->udptxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_UDPTXPKTS]
+		     + stats_inst_offset_64);
+
+	irdma_process_stats(pestat);
+}
+
+/**
+ * irdma_process_cqp_stats - Checking for wrap and update stats
+ * @cqp_request: cqp_request structure pointer
+ * @unused param of callback
+ */
+static void irdma_process_cqp_stats(struct irdma_cqp_request *cqp_request,
+				    u32 unused)
+{
+	struct irdma_vsi_pestat *pestat = cqp_request->param;
+
+	irdma_process_stats(pestat);
+}
+
+/**
+ * irdma_cqp_gather_stats_cmd - Gather stats
+ * @vsi: pointer to vsi structure
+ * @gather_info: pointer to gather stats info
+ */
+enum irdma_status_code irdma_cqp_gather_stats_cmd(struct irdma_sc_dev *dev,
+						  struct irdma_vsi_pestat *pestat,
+						  bool wait)
+
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = IRDMA_OP_STATS_GATHER;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.stats_gather.info = pestat->gather_info;
+	cqp_info->in.u.stats_gather.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.stats_gather.cqp = &rf->cqp.sc_cqp;
+	cqp_request->param = pestat;
+	if (!wait)
+		cqp_request->callback_fcn = irdma_process_cqp_stats;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP STATS_GATHER fail");
+	else if (wait)
+		irdma_process_stats(pestat);
+
+	return status;
+}
+
+/**
+ * irdma_hw_stats_timeout - Stats timer-handler which updates all HW stats
+ * @t: timer_list pointer
+ */
+static void irdma_hw_stats_timeout(struct timer_list *t)
+{
+	struct irdma_vsi_pestat *pf_devstat =
+				from_timer(pf_devstat, t, stats_timer);
+	struct irdma_sc_vsi *sc_vsi = pf_devstat->vsi;
+	struct irdma_device *iwdev = sc_vsi->back_vsi;
+
+	if (iwdev->closing || iwdev->init_state != RDMA_DEV_REGISTERED)
+		goto exit;
+	if (sc_vsi->dev->hw_attrs.hw_rev == IRDMA_GEN_1)
+		irdma_cqp_gather_stats_gen1(sc_vsi->dev, sc_vsi->pestat);
+	else
+		irdma_cqp_gather_stats_cmd(sc_vsi->dev, sc_vsi->pestat, false);
+
+exit:
+	mod_timer(&pf_devstat->stats_timer,
+		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
+}
+
+/**
+ * irdma_hw_stats_start_timer - Start periodic stats timer
+ * @vsi: vsi structure pointer
+ */
+void irdma_hw_stats_start_timer(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_vsi_pestat *devstat = vsi->pestat;
+
+	timer_setup(&devstat->stats_timer, irdma_hw_stats_timeout, 0);
+	mod_timer(&devstat->stats_timer,
+		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
+}
+
+/**
+ * irdma_hw_stats_del_timer - Delete periodic stats timer
+ * @vsi: pointer to vsi structure
+ */
+void irdma_hw_stats_stop_timer(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_vsi_pestat *devstat = vsi->pestat;
+
+	del_timer_sync(&devstat->stats_timer);
+}
+
+/**
+ * irdma_cqp_stats_inst_cmd - Allocate/free stats instance
+ * @vsi: pointer to vsi structure
+ * @stats_info: pointer to allocate stats info
+ */
+enum irdma_status_code
+irdma_cqp_stats_inst_cmd(struct irdma_sc_vsi *vsi,
+			 u8 cmd,
+			 struct irdma_stats_inst_info *stats_info)
+{
+	struct irdma_pci_f *rf = vsi->dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+	bool wait = false;
+
+	if (cmd == IRDMA_OP_STATS_ALLOCATE)
+		wait = true;
+	cqp_request = irdma_get_cqp_request(iwcqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.stats_manage.info = *stats_info;
+	cqp_info->in.u.stats_manage.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.stats_manage.cqp = &rf->cqp.sc_cqp;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
+			    "CQP MANAGE_STATS fail");
+	else if (wait)
+		stats_info->stats_idx = cqp_request->compl_info.op_ret_val;
+
+	return status;
+}
+
+/**
+ * irdma_cqp_ceq_cmd - Create/Destroy CEQ's after CEQ 0
+ * @iwdev: pointer to device info
+ * @sc_ceq: pointer to ceq structure
+ * @op: Create or Destroy
+ */
+enum irdma_status_code irdma_cqp_ceq_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_sc_ceq *sc_ceq,
+					 u8 op)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->post_sq = 1;
+	cqp_info->cqp_cmd =  op;
+	cqp_info->in.u.ceq_create.ceq = sc_ceq;
+	cqp_info->in.u.ceq_create.scratch = (uintptr_t)cqp_request;
+
+	return irdma_handle_cqp_op(rf, cqp_request);
+}
+
+/**
+ * irdma_cqp_ws_node_cmd - Add/modify/delete ws node
+ * @vsi: pointer to vsi structure
+ * @command: Add, modify or delete
+ * @node_info: pointer to ws node info
+ */
+enum irdma_status_code
+irdma_cqp_ws_node_cmd(struct irdma_sc_dev *dev,
+		      u8 cmd,
+		      struct irdma_ws_node_info *node_info)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_sc_cqp *cqp = &iwcqp->sc_cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+	bool poll;
+
+	if (!rf->sc_dev.ceq_valid)
+		poll = true;
+	else
+		poll = false;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, !poll);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.ws_node.info = *node_info;
+	cqp_info->in.u.ws_node.cqp = cqp;
+	cqp_info->in.u.ws_node.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP WS_NODE fail\n");
+		return status;
+	}
+
+	if (poll) {
+		struct irdma_ccq_cqe_info compl_info;
+
+		status = cqp->dev->cqp_ops->poll_for_cqp_op_done(cqp,
+								 IRDMA_CQP_OP_WORK_SCHED_NODE,
+								 &compl_info);
+		node_info->qs_handle = compl_info.op_ret_val;
+		irdma_debug(cqp->dev, IRDMA_DEBUG_DCB,
+			    "opcode=%d, compl_info.retval=%d\n",
+			    compl_info.op_code, compl_info.op_ret_val);
+	} else {
+		node_info->qs_handle = cqp_request->compl_info.op_ret_val;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_cqp_up_map_cmd - Set the up-up mapping
+ * @vsi: pointer to vsi structure
+ * @map_info: pointer to up map info
+ */
+enum irdma_status_code irdma_cqp_up_map_cmd(struct irdma_sc_dev *dev,
+					    u8 cmd,
+					    struct irdma_up_info *map_info)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_sc_cqp *cqp = &iwcqp->sc_cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, false);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.up_map.info = *map_info;
+	cqp_info->in.u.up_map.cqp = cqp;
+	cqp_info->in.u.up_map.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP UP MAP fail\n");
+		return status;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_ah_cqp_op - perform an AH cqp operation
+ * @rf: RDMA PCI function
+ * @sc_ah: address handle
+ * @cmd: AH operation
+ * @wait: wait if true
+ * @callback_fcn: Callback function on CQP op completion
+ * @cb_param: parameter for callback function
+ *
+ * returns errno
+ */
+int irdma_ah_cqp_op(struct irdma_pci_f *rf,
+		    struct irdma_sc_ah *sc_ah,
+		    u8 cmd,
+		    bool wait,
+		    void (*callback_fcn)(struct irdma_cqp_request*, u32),
+		    void *cb_param)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_device *iwdev;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return -ENOMEM;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	if (cmd == IRDMA_OP_AH_CREATE) {
+		cqp_info->in.u.ah_create.info = sc_ah->ah_info;
+		cqp_info->in.u.ah_create.scratch = (uintptr_t)cqp_request;
+		cqp_info->in.u.ah_create.cqp = &rf->cqp.sc_cqp;
+	} else if (cmd == IRDMA_OP_AH_DESTROY) {
+		cqp_info->in.u.ah_destroy.info = sc_ah->ah_info;
+		cqp_info->in.u.ah_destroy.scratch = (uintptr_t)cqp_request;
+		cqp_info->in.u.ah_destroy.cqp = &rf->cqp.sc_cqp;
+	} else {
+		return -EINVAL;
+	}
+
+	if (!wait) {
+		cqp_request->callback_fcn = callback_fcn;
+		cqp_request->param = cb_param;
+	}
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (!status) {
+		if (wait) {
+			iwdev = sc_ah->ah_info.vsi->back_vsi;
+			if (cmd == IRDMA_OP_AH_CREATE) {
+				irdma_add_devusecount(iwdev);
+				sc_ah->ah_info.ah_valid = true;
+
+			} else {
+				irdma_rem_devusecount(iwdev);
+				sc_ah->ah_info.ah_valid = false;
+			}
+		}
+	} else {
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_ieq_ah_cb - callback after creation of AH for IEQ
+ * @cqp_request: pointer to cqp_request of create AH
+ * @unused: unused param
+ */
+static void irdma_ieq_ah_cb(struct irdma_cqp_request *cqp_request,
+			    u32 unused)
+{
+	struct irdma_sc_qp *qp = cqp_request->param;
+	struct irdma_sc_ah *sc_ah = qp->pfpdu.ah;
+	struct irdma_device *iwdev = qp->vsi->back_vsi;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->pfpdu.lock, flags);
+	if (!cqp_request->compl_info.op_ret_val) {
+		sc_ah->ah_info.ah_valid = true;
+		irdma_add_devusecount(iwdev);
+		irdma_ieq_process_fpdus(qp, qp->vsi->ieq);
+	} else {
+		sc_ah->ah_info.ah_valid = false;
+		irdma_ieq_cleanup_qp(qp->vsi->ieq, qp);
+	}
+	spin_unlock_irqrestore(&qp->pfpdu.lock, flags);
+}
+
+/**
+ * irdma_ilq_ah_cb - callback after creation of AH for ILQ
+ * @cqp_request: pointer to cqp_request of create AH
+ * @unused: unused param
+ */
+static void irdma_ilq_ah_cb(struct irdma_cqp_request *cqp_request,
+			    u32 unused)
+{
+	struct irdma_cm_node *cm_node = cqp_request->param;
+	struct irdma_sc_ah *sc_ah = cm_node->ah;
+	struct irdma_device *iwdev = sc_ah->ah_info.vsi->back_vsi;
+
+	if (!cqp_request->compl_info.op_ret_val) {
+		sc_ah->ah_info.ah_valid = true;
+		irdma_add_devusecount(iwdev);
+	} else {
+		sc_ah->ah_info.ah_valid = false;
+	}
+}
+
+/**
+ * irdma_puda_create_ah - create AH for ILQ/IEQ qp's
+ * @dev: device pointer
+ * @ah_info: Address handle info
+ * @wait: When true will wait for operation to complete
+ * @type: ILQ/IEQ
+ * @cb_param: Callback param when not waiting
+ * @ah_ret: Returned pointer to address handle if created
+ *
+ */
+enum irdma_status_code irdma_puda_create_ah(struct irdma_sc_dev *dev,
+					    struct irdma_ah_info *ah_info,
+					    bool wait,
+					    enum puda_rsrc_type type,
+					    void *cb_param,
+					    struct irdma_sc_ah **ah_ret)
+{
+	struct irdma_sc_ah *ah;
+	struct irdma_pci_f *rf = dev->back_dev;
+	int err;
+
+	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
+	*ah_ret = ah;
+	if (!ah)
+		return IRDMA_ERR_NO_MEMORY;
+
+	err = irdma_alloc_rsrc(rf, rf->allocated_ahs,
+			       rf->max_ah, &ah_info->ah_idx, &rf->next_ah);
+	if (err)
+		goto err_free;
+
+	ah->dev = dev;
+	ah->ah_info = *ah_info;
+
+	if (type == IRDMA_PUDA_RSRC_TYPE_ILQ)
+		err = irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_CREATE, wait,
+				      irdma_ilq_ah_cb, cb_param);
+	else
+		err = irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_CREATE, wait,
+				      irdma_ieq_ah_cb, cb_param);
+
+	if (err)
+		goto error;
+	return 0;
+
+error:
+	irdma_free_rsrc(rf, rf->allocated_ahs, ah->ah_info.ah_idx);
+err_free:
+	kfree(ah);
+	*ah_ret = NULL;
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_puda_free_ah - free a puda address handle
+ * @dev: device pointer
+ * @ah: The address handle to free
+ */
+void irdma_puda_free_ah(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	if (!ah)
+		return;
+
+	if (ah->ah_info.ah_valid) {
+		irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_DESTROY, false, NULL, NULL);
+		irdma_free_rsrc(rf, rf->allocated_ahs, ah->ah_info.ah_idx);
+		irdma_rem_devusecount(ah->ah_info.vsi->back_vsi);
+	}
+
+	kfree(ah);
+}
+
+/**
+ * irdma_gsi_ud_qp_ah_cb - callback after creation of AH for GSI/ID QP
+ * @cqp_request: pointer to cqp_request of create AH
+ * @unused: unused param
+ */
+void irdma_gsi_ud_qp_ah_cb(struct irdma_cqp_request *cqp_request, u32 unused)
+{
+	struct irdma_sc_ah *sc_ah = cqp_request->param;
+
+	if (!cqp_request->compl_info.op_ret_val)
+		sc_ah->ah_info.ah_valid = true;
+	else
+		sc_ah->ah_info.ah_valid = false;
+}
+
+/**
+ * irdma_destroy_ah_cb - callback after destroy of AH
+ * @cqp_request: pointer to cqp_request of destroy AH
+ * @unused: unused param
+ */
+void irdma_destroy_ah_cb(struct irdma_cqp_request *cqp_request, u32 unused)
+{
+	struct irdma_ah *ah = cqp_request->param;
+	struct irdma_device *iwdev = ah->sc_ah.ah_info.vsi->back_vsi;
+
+	if (!cqp_request->compl_info.op_ret_val)
+		irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_ahs,
+				ah->sc_ah.ah_info.ah_idx);
+	irdma_rem_pdusecount(ah->pd, iwdev);
+	kfree(ah);
+}
+
+/**
+ * irdma_prm_add_pble_mem - add moemory to pble resources
+ * @pprm: pble resource manager
+ * @pchunk: chunk of memory to add
+ */
+enum irdma_status_code irdma_prm_add_pble_mem(struct irdma_pble_prm *pprm,
+					      struct irdma_chunk *pchunk)
+{
+	u64 sizeofbitmap;
+	enum irdma_status_code ret_code = 0;
+
+	if (pchunk->size & 0xfff)
+		return IRDMA_ERR_PARAM;
+
+	sizeofbitmap = (u64)pchunk->size >> pprm->pble_shift;
+
+	ret_code = irdma_allocate_virt_mem(pchunk->dev->hw,
+					   &pchunk->bitmapmem,
+					   sizeofbitmap >> 3);
+
+	if (ret_code)
+		return ret_code;
+
+	pchunk->bitmapbuf = pchunk->bitmapmem.va;
+	bitmap_zero(pchunk->bitmapbuf, sizeofbitmap);
+
+	pchunk->sizeofbitmap = sizeofbitmap;
+	/* each pble is 8 bytes hence shift by 3 */
+	pprm->total_pble_alloc += pchunk->size >> 3;
+	pprm->free_pble_cnt += pchunk->size >> 3;
+
+	return 0;
+}
+
+/**
+ * irdma_prm_add_pble_mem - get pble's from prm
+ * @pprm: pble resource manager
+ * @pchunkinfo: return information about chunk where pble's were acquired
+ * @memsize: size of pble memory needed
+ * @vaddr: returns virtual address of pble memory
+ * @fpm_addr: returns fpm address of pble memory
+ */
+enum irdma_status_code irdma_prm_get_pbles(struct irdma_pble_prm *pprm,
+					   struct irdma_pble_chunkinfo *chunkinfo,
+					   u32 mem_size,
+					   u64 *vaddr,
+					   u64 *fpm_addr)
+{
+	u64 bits_needed;
+	u64 bit_idx = PBLE_INVALID_IDX;
+	struct irdma_chunk *pchunk = NULL;
+	struct list_head *chunk_entry = pprm->clist.next;
+	u32 offset;
+	unsigned long flags;
+	*vaddr = 0;
+	*fpm_addr = 0;
+
+	bits_needed = (mem_size + (1 << pprm->pble_shift) - 1) >> pprm->pble_shift;
+
+	spin_lock_irqsave(&pprm->prm_lock, flags);
+	while (chunk_entry != &pprm->clist) {
+		pchunk = (struct irdma_chunk *)chunk_entry;
+		bit_idx = bitmap_find_next_zero_area(pchunk->bitmapbuf,
+						     pchunk->sizeofbitmap,
+						     0,
+						     bits_needed,
+						     0);
+		if (bit_idx < pchunk->sizeofbitmap)
+			break;
+
+		/* list.next used macro */
+		chunk_entry = pchunk->list.next;
+	}
+
+	if (!pchunk || bit_idx >= pchunk->sizeofbitmap) {
+		spin_unlock_irqrestore(&pprm->prm_lock, flags);
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	bitmap_set(pchunk->bitmapbuf, bit_idx, bits_needed);
+	offset = bit_idx << pprm->pble_shift;
+	*vaddr = (u64)((u8 *)pchunk->vaddr + offset);
+	*fpm_addr = pchunk->fpm_addr + offset;
+
+	chunkinfo->pchunk = pchunk;
+	chunkinfo->bit_idx = bit_idx;
+	chunkinfo->bits_used = bits_needed;
+	/* 3 is sizeof pble divide */
+	pprm->free_pble_cnt -= chunkinfo->bits_used << (pprm->pble_shift - 3);
+	spin_unlock_irqrestore(&pprm->prm_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_prm_return pbles - return pbles back to prm
+ * @pprm: pble resource manager
+ * @pchunkinfo: chunk where pble's were acquired and to be freed
+ */
+void irdma_prm_return_pbles(struct irdma_pble_prm *pprm,
+			    struct irdma_pble_chunkinfo *chunkinfo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pprm->prm_lock, flags);
+	pprm->free_pble_cnt += chunkinfo->bits_used << (pprm->pble_shift - 3);
+	bitmap_clear(chunkinfo->pchunk->bitmapbuf,
+		     chunkinfo->bit_idx,
+		     chunkinfo->bits_used);
+	spin_unlock_irqrestore(&pprm->prm_lock, flags);
+}
+
+/**
+ * irdma_free_paged_mem - free virtual paged memory back to system
+ * @chunk: chunk to free with paged memory
+ */
+void irdma_pble_free_paged_mem(struct irdma_chunk *chunk)
+{
+	struct pci_dev *pcidev = (struct pci_dev *)chunk->dev->hw->dev_context;
+	int i;
+
+	if (!chunk->pg_cnt)
+		goto done;
+
+	for (i = 0; i < chunk->pg_cnt; i++)
+		dma_unmap_page(&pcidev->dev,
+			       chunk->dmainfo.dmaaddrs[i],
+			       PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+
+done:
+	kfree(chunk->dmainfo.dmaaddrs);
+	chunk->dmainfo.dmaaddrs = NULL;
+	vfree((void *)chunk->vaddr);
+	chunk->vaddr = 0;
+	chunk->type = 0;
+}
+
+/**
+ * irdma_pble_get_paged_mem -allocate paged memory for pbles
+ * @chunk: chunk to add for paged memory
+ * @pg_cnt: number of pages needed
+ */
+enum irdma_status_code irdma_pble_get_paged_mem(struct irdma_chunk *chunk, int pg_cnt)
+{
+	struct pci_dev *pcidev = (struct pci_dev *)chunk->dev->hw->dev_context;
+	struct page *page;
+	u8 *addr;
+	u32 size;
+	int i;
+
+	chunk->dmainfo.dmaaddrs = kzalloc(pg_cnt << 3, GFP_KERNEL);
+	if (!chunk->dmainfo.dmaaddrs)
+		return IRDMA_ERR_NO_MEMORY;
+
+	size = PAGE_SIZE * pg_cnt;
+	chunk->vaddr = (u64)vmalloc(size);
+	if (!chunk->vaddr) {
+		kfree(chunk->dmainfo.dmaaddrs);
+		chunk->dmainfo.dmaaddrs = NULL;
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	chunk->size = size;
+	addr = (u8 *)chunk->vaddr;
+
+	for (i = 0; i < pg_cnt; i++) {
+		page = vmalloc_to_page((void *)addr);
+		if (!page)
+			break;
+
+		chunk->dmainfo.dmaaddrs[i] = dma_map_page(&pcidev->dev,
+							  page,
+							  0,
+							  PAGE_SIZE,
+							  DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(&pcidev->dev, chunk->dmainfo.dmaaddrs[i]))
+			break;
+
+		addr += PAGE_SIZE;
+	}
+
+	chunk->pg_cnt = i;
+	chunk->type = PBLE_SD_PAGED;
+	if (i == pg_cnt)
+		return 0;
+
+	irdma_pble_free_paged_mem(chunk);
+
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_alloc_ws_node_id - Allocate a tx scheduler node ID
+ * @dev: device pointer
+ */
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	u32 node_id;
+
+	if (irdma_alloc_rsrc(rf, rf->allocated_ws_nodes,
+			     rf->max_ws_node_id,
+			     &node_id, &rf->next_ws_node_id))
+		return IRDMA_WS_NODE_INVALID;
+
+	return (u16)node_id;
+}
+
+/**
+ * irdma_free_ws_node_id - Free a tx scheduler node ID
+ * @dev: device pointer
+ */
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	irdma_free_rsrc(rf, rf->allocated_ws_nodes, (u32)node_id);
+}
+
+/**
+ * irdma_modify_qp_to_err - Modify a QP to error
+ * @sc_qp: qp structure
+ */
+void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
+{
+	struct irdma_qp *qp = sc_qp->back_qp;
+	struct ib_qp_attr attr;
+
+	attr.qp_state = IB_QPS_ERR;
+	irdma_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
+}
-- 
1.8.3.1
