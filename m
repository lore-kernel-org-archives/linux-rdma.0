From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] RDMA/ocrdma: get vlan tag from ib_qp_attrs
Date: Fri, 22 Aug 2014 16:57:20 +0530
Message-ID: <70e2b306-24e5-4922-8951-b748c5e5690b@CMEXHTCAS1.ad.emulex.com>
References: <1408706840-21339-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408706840-21339-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

in view of IP based GID changes, now vlan-id
can be obtained from qp_attr->vlan_id.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index dd35ae5..10a261c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2279,7 +2279,8 @@ mbx_err:
 
 static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 				struct ocrdma_modify_qp *cmd,
-				struct ib_qp_attr *attrs)
+				struct ib_qp_attr *attrs,
+				int attr_mask)
 {
 	int status;
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
@@ -2319,8 +2320,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
-	vlan_id = ah_attr->vlan_id;
-	if (vlan_id && (vlan_id < 0x1000)) {
+	if (attr_mask & IB_QP_VID) {
+		vlan_id = attrs->vlan_id;
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
@@ -2347,7 +2348,7 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->flags |= OCRDMA_QP_PARA_QKEY_VALID;
 	}
 	if (attr_mask & IB_QP_AV) {
-		status = ocrdma_set_av_params(qp, cmd, attrs);
+		status = ocrdma_set_av_params(qp, cmd, attrs, attr_mask);
 		if (status)
 			return status;
 	} else if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_UD) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
