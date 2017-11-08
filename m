From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion
Date: Wed,  8 Nov 2017 00:44:53 -0500
Message-ID: <1510119893-24676-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In a real RoCE v2 network it is possible to have two
Sections of network have same IP hence same gid. However
those may have different vlans. During connection resolution
it is important to report the actual vlan on which the
MAD packet was received instead of relying on other means
to resolve vlan-id. ib_find_gid_index should not be used
to resolve the vlan-id using sgid of the local system
where the packet was received.

Our device has the capability to report the actual VLAN-ID
in the GSI qp completions. Since we have the capability our
driver should move away from resolving the vlan-id with the
help of SGID at the destination port.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 33 ++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ebcdfb4..558d786 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2771,6 +2771,32 @@ static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
 	wc->wc_flags |= IB_WC_GRH;
 }
 
+static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
+				u16 *vid, u8 *sl)
+{
+	u32 metadata;
+	u16 tpid;
+	bool ret = false;
+
+	metadata = orig_cqe->raweth_qp1_metadata;
+	if (orig_cqe->raweth_qp1_flags2 &
+		CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_META_FORMAT_VLAN) {
+		tpid = ((metadata &
+			 CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_MASK) >>
+			 CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_SFT);
+		if (tpid == ETH_P_8021Q) {
+			*vid = metadata &
+			       CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_VID_MASK;
+			*sl = (metadata &
+			       CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_MASK) >>
+			       CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_SFT;
+			ret = true;
+		}
+	}
+
+	return ret;
+}
+
 static void bnxt_re_process_res_rc_wc(struct ib_wc *wc,
 				      struct bnxt_qplib_cqe *cqe)
 {
@@ -2796,6 +2822,8 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
 	struct bnxt_qplib_cqe *orig_cqe = NULL;
 	struct bnxt_re_sqp_entries *sqp_entry = NULL;
 	int nw_type;
+	u16 vlan_id;
+	u8 sl;
 
 	tbl_idx = cqe->wr_id;
 
@@ -2810,6 +2838,11 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
 	wc->ex.imm_data = orig_cqe->immdata;
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
+	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
+		wc->vlan_id = vlan_id;
+		wc->sl = sl;
+		wc->wc_flags |= IB_WC_WITH_VLAN;
+	}
 	wc->port_num = 1;
 	wc->vendor_err = orig_cqe->status;
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index a82044d..8962621 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2236,6 +2236,7 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 
 	cqe->raweth_qp1_flags = le16_to_cpu(hwcqe->raweth_qp1_flags);
 	cqe->raweth_qp1_flags2 = le32_to_cpu(hwcqe->raweth_qp1_flags2);
+	cqe->raweth_qp1_metadata = le32_to_cpu(hwcqe->raweth_qp1_metadata);
 
 	rq = &qp->rq;
 	if (wr_id_idx > rq->hwq.max_elements) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
