From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/5] libbnxt_re: fix wqe size for the 0-len posting
Date: Fri, 12 May 2017 06:24:23 -0400
Message-ID: <1494584666-11064-3-git-send-email-devesh.sharma@broadcom.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

rstream does not include any SGEs in the traffic it generates
with zero length. In this case wqe preparation logic is
calculating WQE-size=2. This is resulting WQE_FORMAT_ERROR
when h/w is processing the wqe. Our h/w requires host to supply
WQE Size with room for atleast one SGE. Thus, this patch is
increasing the wqe-size by 1 whenever wr->num_sges are zero.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/verbs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 35eb12d..7cf0b86 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1081,6 +1081,11 @@ static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
 	} else {
 		qesize = wr->num_sge;
 	}
+	/* HW requires wqe size has room for atleast one sge even if none was
+	 * supplied by application
+	 */
+	if (!wr->num_sge)
+		qesize++;
 	qesize += (bnxt_re_get_sqe_hdr_sz() >> 4);
 	hdrval |= (qesize & BNXT_RE_HDR_WS_MASK) << BNXT_RE_HDR_WS_SHIFT;
 	hdr->rsv_ws_fl_wt |= htole32(hdrval);
@@ -1259,6 +1264,11 @@ static int bnxt_re_build_rqe(struct bnxt_re_qp *qp, struct ibv_recv_wr *wr,
 
 	len = bnxt_re_build_sge(sge, wr->sg_list, wr->num_sge, false);
 	wqe_sz = wr->num_sge + (bnxt_re_get_rqe_hdr_sz() >> 4); /* 16B align */
+	/* HW requires wqe size has room for atleast one sge even if none was
+	 * supplied by application
+	 */
+	if (!wr->num_sge)
+		wqe_sz++;
 	hdrval = BNXT_RE_WR_OPCD_RECV;
 	hdrval |= ((wqe_sz & BNXT_RE_HDR_WS_MASK) << BNXT_RE_HDR_WS_SHIFT);
 	hdr->rsv_ws_fl_wt = htole32(hdrval);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
