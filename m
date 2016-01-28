From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 3/4] RDMA/ocrdma: Support RoCE-v2 in the RC path
Date: Thu, 28 Jan 2016 08:59:58 -0500
Message-ID: <1453989599-21307-4-git-send-email-devesh.sharma@avagotech.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453989599-21307-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch implements following changes to support RoCE-v2
in the RC path:

* Get the GID-type for a given sgid.
* Based on the GID-type get IPv4/IPv6 L3-address
  and give those to underlying device.
* Resolve and provide network header type to device.

Signed-off-by: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  | 23 +++++++++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h |  2 ++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aea7f17..2cfbf15 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2504,7 +2504,12 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	union ib_gid sgid, zgid;
 	struct ib_gid_attr sgid_attr;
 	u32 vlan_id = 0xFFFF;
-	u8 mac_addr[6];
+	u8 mac_addr[6], hdr_type;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
 	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
@@ -2519,6 +2524,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->params.hop_lmt_rq_psn |=
 	    (ah_attr->grh.hop_limit << OCRDMA_QP_PARAMS_HOP_LMT_SHIFT);
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
+
+	/* GIDs */
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
 
@@ -2541,6 +2548,16 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		return status;
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
+
+	hdr_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
+	if (hdr_type == RDMA_NETWORK_IPV4) {
+		rdma_gid2ip(&sgid_addr._sockaddr, &sgid);
+		rdma_gid2ip(&dgid_addr._sockaddr, &ah_attr->grh.dgid);
+		memcpy(&cmd->params.dgid[0],
+		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+		memcpy(&cmd->params.sgid[0],
+		       &sgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+	}
 	/* convert them to LE format. */
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
@@ -2561,7 +2578,9 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		cmd->params.rnt_rc_sl_fl |=
 			(dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
-
+	cmd->params.max_sge_recv_flags |= ((hdr_type <<
+					OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT) &
+					OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 3d15948..0efc966 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1112,6 +1112,8 @@ enum {
 	OCRDMA_QP_PARAMS_STATE_MASK		= BIT(5) | BIT(6) | BIT(7),
 	OCRDMA_QP_PARAMS_FLAGS_SQD_ASYNC	= BIT(8),
 	OCRDMA_QP_PARAMS_FLAGS_INB_ATEN		= BIT(9),
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT    = 11,
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK     = BIT(11) | BIT(12) | BIT(13),
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT	= 16,
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_MASK	= 0xFFFF <<
 					OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
