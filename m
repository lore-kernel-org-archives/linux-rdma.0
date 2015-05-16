From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 04/11] RDMA/ocrdma: Use VID 0 if PFC is enabled and vlan is not configured
Date: Sat, 16 May 2015 13:21:42 +0530
Message-ID: <1431762709-20740-5-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

If the adapter ports are in PFC mode and VLAN is not configured,
use vlan tag 0 for RoCE traffic. Also, log an advisory message
in system logs.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  8 +++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 12 +++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index d812904..2a5993b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -56,7 +56,13 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	vlan_tag = attr->vlan_id;
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
-	if (vlan_tag && (vlan_tag < 0x1000)) {
+	if (vlan_tag || dev->pfc_state) {
+		if (!vlan_tag) {
+			pr_err("ocrdma%d:Using VLAN with PFC is recommended\n",
+				dev->id);
+			pr_err("ocrdma%d:Using VLAN 0 for this connection\n",
+				dev->id);
+		}
 		eth.eth_type = cpu_to_be16(0x8100);
 		eth.roce_eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
 		vlan_tag |= (dev->sl & 0x07) << OCRDMA_VID_PCP_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 65759ac..da688d7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2434,7 +2434,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	int status;
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
 	union ib_gid sgid, zgid;
-	u32 vlan_id;
+	u32 vlan_id = 0xFFFF;
 	u8 mac_addr[6];
 	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
@@ -2474,12 +2474,22 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
 	if (attr_mask & IB_QP_VID) {
 		vlan_id = attrs->vlan_id;
+	} else if (dev->pfc_state) {
+		vlan_id = 0;
+		pr_err("ocrdma%d:Using VLAN with PFC is recommended\n",
+			dev->id);
+		pr_err("ocrdma%d:Using VLAN 0 for this connection\n",
+			dev->id);
+	}
+
+	if (vlan_id < 0x1000) {
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
 		cmd->params.rnt_rc_sl_fl |=
 			(dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
+
 	return 0;
 }
 
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
