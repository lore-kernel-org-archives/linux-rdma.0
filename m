From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] RDMA/ocrdma: changes to support RoCE-v2 in RC path
Date: Thu, 25 Dec 2014 06:29:55 +0530
Message-ID: <3d72381c-81f3-49f9-91f4-1af7d9e3832b@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   35 +++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 473c615..43d10bc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2433,11 +2433,19 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
 	union ib_gid sgid, zgid;
 	u32 vlan_id;
-	u8 mac_addr[6];
+	u8 mac_addr[6], sgid_type, hdr_type;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
+
 	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
 		return -EINVAL;
+
+	/* Update SL */
 	if (atomic_cmpxchg(&dev->update_sl, 1, 0))
 		ocrdma_init_service_level(dev);
 	cmd->params.tclass_sq_psn |=
@@ -2448,6 +2456,8 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->params.hop_lmt_rq_psn |=
 	    (ah_attr->grh.hop_limit << OCRDMA_QP_PARAMS_HOP_LMT_SHIFT);
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
+
+	/* GIDs */
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
 	status = ocrdma_query_gid(&dev->ibdev, 1,
@@ -2460,12 +2470,30 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		return -EINVAL;
 
 	qp->sgid_idx = ah_attr->grh.sgid_index;
+	status = ocrdma_query_gid_type(&dev->ibdev, 1,
+				       ah_attr->grh.sgid_index, &sgid_type);
+	if (status)
+		return status;
+
+	hdr_type = ib_gid_to_network_type(sgid_type, &sgid);
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
 	status = ocrdma_resolve_dmac(dev, ah_attr, &mac_addr[0]);
 	if (status)
 		return status;
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
+	if (hdr_type == RDMA_NETWORK_IPv4) {
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
@@ -2478,6 +2506,11 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
