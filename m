From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [for-next 2/3] RDMA/bnxt: update bnxt_hsi to hold dscp2pri declaration
Date: Tue, 22 Aug 2017 07:49:46 -0400
Message-ID: <1503402587-24669-3-git-send-email-devesh.sharma@broadcom.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503402587-24669-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds new structure declarations to bnxt_hsi.h
file. The new declarations are related to DSCP to priority
mapping slow patch commands.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 92 +++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 7dc71bb..d45a039 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -3152,6 +3152,95 @@ struct hwrm_queue_cos2bw_cfg_output {
 	u8 valid;
 };
 
+/* hwrm_queue_dscp_qcaps */
+/* Input (24 bytes) */
+struct hwrm_queue_dscp_qcaps_input {
+	__le16 req_type;
+	__le16 cmpl_ring;
+	__le16 seq_id;
+	__le16 target_id;
+	__le64 resp_addr;
+	u8 port_id;
+	u8 unused_0[7];
+};
+
+/* Output (16 bytes) */
+struct hwrm_queue_dscp_qcaps_output {
+	__le16 error_code;
+	__le16 req_type;
+	__le16 seq_id;
+	__le16 resp_len;
+	u8 num_dscp_bits;
+	u8 unused_0;
+	__le16 max_entries;
+	u8 unused_1;
+	u8 unused_2;
+	u8 unused_3;
+	u8 valid;
+};
+
+/* hwrm_queue_dscp2pri_qcfg */
+/* Input (32 bytes) */
+struct hwrm_queue_dscp2pri_qcfg_input {
+	__le16 req_type;
+	__le16 cmpl_ring;
+	__le16 seq_id;
+	__le16 target_id;
+	__le64 resp_addr;
+	__le64 dest_data_addr;
+	u8 port_id;
+	u8 unused_0;
+	__le16 dest_data_buffer_size;
+	__le32 unused_1;
+};
+
+/* Output (16 bytes) */
+struct hwrm_queue_dscp2pri_qcfg_output {
+	__le16 error_code;
+	__le16 req_type;
+	__le16 seq_id;
+	__le16 resp_len;
+	__le16 entry_cnt;
+	u8 default_pri;
+	u8 unused_0;
+	u8 unused_1;
+	u8 unused_2;
+	u8 unused_3;
+	u8 valid;
+};
+
+/* hwrm_queue_dscp2pri_cfg */
+/* Input (40 bytes) */
+struct hwrm_queue_dscp2pri_cfg_input {
+	__le16 req_type;
+	__le16 cmpl_ring;
+	__le16 seq_id;
+	__le16 target_id;
+	__le64 resp_addr;
+	__le64 src_data_addr;
+	__le32 flags;
+	#define QUEUE_DSCP2PRI_CFG_REQ_FLAGS_USE_HW_DEFAULT_PRI    0x1UL
+	__le32 enables;
+	#define QUEUE_DSCP2PRI_CFG_REQ_ENABLES_DEFAULT_PRI          0x1UL
+	u8 port_id;
+	u8 default_pri;
+	__le16 entry_cnt;
+	__le32 unused_0;
+};
+
+/* Output (16 bytes) */
+struct hwrm_queue_dscp2pri_cfg_output {
+	__le16 error_code;
+	__le16 req_type;
+	__le16 seq_id;
+	__le16 resp_len;
+	__le32 unused_0;
+	u8 unused_1;
+	u8 unused_2;
+	u8 unused_3;
+	u8 valid;
+};
+
 /* hwrm_vnic_alloc */
 /* Input (24 bytes) */
 struct hwrm_vnic_alloc_input {
@@ -5429,6 +5518,9 @@ struct cmd_nums {
 	#define HWRM_QUEUE_PRI2COS_CFG				   (0x38UL)
 	#define HWRM_QUEUE_COS2BW_QCFG				   (0x39UL)
 	#define HWRM_QUEUE_COS2BW_CFG				   (0x3aUL)
+	#define HWRM_QUEUE_DSCP_QCAPS				   (0x3bUL)
+	#define HWRM_QUEUE_DSCP2PRI_QCFG			   (0x3cUL)
+	#define HWRM_QUEUE_DSCP2PRI_CFG				   (0x3dUL)
 	#define HWRM_VNIC_ALLOC				   (0x40UL)
 	#define HWRM_VNIC_FREE					   (0x41UL)
 	#define HWRM_VNIC_CFG					   (0x42UL)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
