From: Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 1/3] cxgb4: add tcb flags and tcb rpl struct
Date: Wed,  6 Feb 2019 22:54:42 +0530
Message-ID: <20190206172444.21997-2-rajur@chelsio.com>
References: <20190206172444.21997-1-rajur@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190206172444.21997-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org, swise@opengridcomputing.com, rajur@chelsio.com
List-Id: linux-rdma@vger.kernel.org

This patch adds the tcb flags and structures needed for querying tcb
information.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  8 ++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h | 12 ++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index c62a0c830705..38dd41eb959e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -56,6 +56,7 @@ enum {
 	CPL_TX_DATA_ISO	      = 0x1F,
 
 	CPL_CLOSE_LISTSRV_RPL = 0x20,
+	CPL_GET_TCB_RPL       = 0x22,
 	CPL_L2T_WRITE_RPL     = 0x23,
 	CPL_PASS_OPEN_RPL     = 0x24,
 	CPL_ACT_OPEN_RPL      = 0x25,
@@ -688,6 +689,13 @@ struct cpl_get_tcb {
 #define NO_REPLY_V(x) ((x) << NO_REPLY_S)
 #define NO_REPLY_F    NO_REPLY_V(1U)
 
+struct cpl_get_tcb_rpl {
+	union opcode_tid ot;
+	__u8 cookie;
+	__u8 status;
+	__be16 len;
+};
+
 struct cpl_set_tcb_field {
 	WR_HDR;
 	union opcode_tid ot;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
index 3297ce025e8b..1b9afb192f7f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -41,6 +41,14 @@
 #define TCB_SMAC_SEL_V(x)	((x) << TCB_SMAC_SEL_S)
 
 #define TCB_T_FLAGS_W		1
+#define TCB_T_FLAGS_S		0
+#define TCB_T_FLAGS_M		0xffffffffffffffffULL
+#define TCB_T_FLAGS_V(x)	((__u64)(x) << TCB_T_FLAGS_S)
+
+#define TCB_RQ_START_W		30
+#define TCB_RQ_START_S		0
+#define TCB_RQ_START_M		0x3ffffffULL
+#define TCB_RQ_START_V(x)	((x) << TCB_RQ_START_S)
 
 #define TF_CCTRL_ECE_S		60
 #define TF_CCTRL_CWR_S		61
@@ -66,4 +74,8 @@
 #define TCB_RX_FRAG3_LEN_RAW_W	29
 #define TCB_RX_FRAG3_START_IDX_OFFSET_RAW_W	30
 #define TCB_PDU_HDR_LEN_W	31
+
+#define TF_RX_PDU_OUT_S		49
+#define TF_RX_PDU_OUT_V(x)	((__u64)(x) << TF_RX_PDU_OUT_S)
+
 #endif /* __T4_TCB_H */
-- 
2.13.0
