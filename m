From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 17/32] RDMA/ocrdma: changes to support RoCE-v2 in RC path
Date: Wed, 11 Mar 2015 10:26:09 +0530
Message-ID: <625768ae-abf0-462d-a97b-78c76314b692@CMEXHTCAS2.ad.emulex.com>
References: <1426049785-30364-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426049785-30364-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

To support RoCE-V2 this patch implements following changes
1. Get the GID-type for a given sgid.
2. Based on the gid type get IPv4 L3 address
   and give those to FW.
3. Provide l3-type to FW.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 20f9e8f..147fccf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2433,7 +2433,13 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	union ib_gid sgid, zgid;
 	struct ib_gid_attr sgid_attr;
 	u32 vlan_id = 0xffff;
-	u8 mac_addr[6];
+	u8 mac_addr[6], hdr_type;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
+
 	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
@@ -2448,6 +2454,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->params.hop_lmt_rq_psn |=
 	    (ah_attr->grh.hop_limit << OCRDMA_QP_PARAMS_HOP_LMT_SHIFT);
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
+
+	/* GIDs */
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
 
@@ -2471,17 +2479,35 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		return status;
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
+	hdr_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
+	if (hdr_type == RDMA_NETWORK_IPV4) {
+		status = rdma_gid2ip(&sgid_addr._sockaddr, &sgid);
+		if (status)
+			return status;
+		status = rdma_gid2ip(&dgid_addr._sockaddr, &ah_attr->grh.dgid);
+		if (status)
+			return status;
+		memcpy(&cmd->params.dgid[0],
+		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+		memcpy(&cmd->params.sgid[0],
+		       &sgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+	}
 	/* convert them to LE format. */
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
-	if (attr_mask & IB_QP_VID) {
+	if (vlan_id < 0x1000) {
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
 		cmd->params.rnt_rc_sl_fl |=
 			(dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
+
+	cmd->params.max_sge_recv_flags |=
+					 ((hdr_type <<
+					 OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT) &
+					 OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK);
 	return 0;
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
