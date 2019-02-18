From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net 1/2] qed: Fix iWARP buffer size provided for syn packet processing.
Date: Mon, 18 Feb 2019 15:24:02 +0200
Message-ID: <20190218132403.12487-2-michal.kalderon@marvell.com>
References: <20190218132403.12487-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190218132403.12487-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The assumption that the maximum size of a syn packet is 128 bytes
is wrong. Tunneling headers were not accounted for.
Allocate buffers large enough for mtu.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 12 ++++++------
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h |  1 -
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index beb8e5d..e84fb01 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2605,7 +2605,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	struct qed_iwarp_info *iwarp_info;
 	struct qed_ll2_acquire_data data;
 	struct qed_ll2_cbs cbs;
-	u32 mpa_buff_size;
+	u32 buff_size;
 	u16 n_ooo_bufs;
 	int rc = 0;
 	int i;
@@ -2632,7 +2632,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 
 	memset(&data, 0, sizeof(data));
 	data.input.conn_type = QED_LL2_TYPE_IWARP;
-	data.input.mtu = QED_IWARP_MAX_SYN_PKT_SIZE;
+	data.input.mtu = params->max_mtu;
 	data.input.rx_num_desc = QED_IWARP_LL2_SYN_RX_SIZE;
 	data.input.tx_num_desc = QED_IWARP_LL2_SYN_TX_SIZE;
 	data.input.tx_max_bds_per_packet = 1;	/* will never be fragmented */
@@ -2654,9 +2654,10 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 		goto err;
 	}
 
+	buff_size = QED_IWARP_MAX_BUF_SIZE(params->max_mtu);
 	rc = qed_iwarp_ll2_alloc_buffers(p_hwfn,
 					 QED_IWARP_LL2_SYN_RX_SIZE,
-					 QED_IWARP_MAX_SYN_PKT_SIZE,
+					 buff_size,
 					 iwarp_info->ll2_syn_handle);
 	if (rc)
 		goto err;
@@ -2710,10 +2711,9 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	if (rc)
 		goto err;
 
-	mpa_buff_size = QED_IWARP_MAX_BUF_SIZE(params->max_mtu);
 	rc = qed_iwarp_ll2_alloc_buffers(p_hwfn,
 					 data.input.rx_num_desc,
-					 mpa_buff_size,
+					 buff_size,
 					 iwarp_info->ll2_mpa_handle);
 	if (rc)
 		goto err;
@@ -2726,7 +2726,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 
 	iwarp_info->max_num_partial_fpdus = (u16)p_hwfn->p_rdma_info->num_qps;
 
-	iwarp_info->mpa_intermediate_buf = kzalloc(mpa_buff_size, GFP_KERNEL);
+	iwarp_info->mpa_intermediate_buf = kzalloc(buff_size, GFP_KERNEL);
 	if (!iwarp_info->mpa_intermediate_buf)
 		goto err;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
index b8f612d..7ac95903 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
@@ -46,7 +46,6 @@ enum qed_iwarp_qp_state qed_roce2iwarp_state(enum qed_roce_qp_state state);
 
 #define QED_IWARP_LL2_SYN_TX_SIZE       (128)
 #define QED_IWARP_LL2_SYN_RX_SIZE       (256)
-#define QED_IWARP_MAX_SYN_PKT_SIZE      (128)
 
 #define QED_IWARP_LL2_OOO_DEF_TX_SIZE   (256)
 #define QED_IWARP_MAX_OOO		(16)
-- 
2.9.5
