From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 08/47] RDMA/bnxt_re: Remove set-but-not-used variables
Date: Fri,  6 Oct 2017 14:32:54 -0700
Message-ID: <20171006213333.6721-9-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 12 +++++-------
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   |  5 -----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 ----
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   |  5 ++---
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0d89621d9fe8..af65f8114379 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1643,7 +1643,7 @@ static int bnxt_re_build_qp1_send_v2(struct bnxt_re_qp *qp,
 	u8 ip_version = 0;
 	u16 vlan_id = 0xFFFF;
 	void *buf;
-	int i, rc = 0, size;
+	int i, rc = 0;
 
 	memset(&qp->qp1_hdr, 0, sizeof(qp->qp1_hdr));
 
@@ -1760,7 +1760,7 @@ static int bnxt_re_build_qp1_send_v2(struct bnxt_re_qp *qp,
 	/* Pack the QP1 to the transmit buffer */
 	buf = bnxt_qplib_get_qp1_sq_buf(&qp->qplib_qp, &sge);
 	if (buf) {
-		size = ib_ud_header_pack(&qp->qp1_hdr, buf);
+		ib_ud_header_pack(&qp->qp1_hdr, buf);
 		for (i = wqe->num_sge; i; i--) {
 			wqe->sg_list[i].addr = wqe->sg_list[i - 1].addr;
 			wqe->sg_list[i].lkey = wqe->sg_list[i - 1].lkey;
@@ -2216,7 +2216,7 @@ static int bnxt_re_post_recv_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct ib_recv_wr *wr)
 {
 	struct bnxt_qplib_swqe wqe;
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
 
 	memset(&wqe, 0, sizeof(wqe));
 	while (wr) {
@@ -2231,8 +2231,7 @@ static int bnxt_re_post_recv_shadow_qp(struct bnxt_re_dev *rdev,
 			rc = -EINVAL;
 			break;
 		}
-		payload_sz = bnxt_re_build_sgl(wr->sg_list, wqe.sg_list,
-					       wr->num_sge);
+		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
 
@@ -2569,7 +2568,7 @@ static void bnxt_re_process_req_wc(struct ib_wc *wc, struct bnxt_qplib_cqe *cqe)
 static int bnxt_re_check_packet_type(u16 raweth_qp1_flags,
 				     u16 raweth_qp1_flags2)
 {
-	bool is_udp = false, is_ipv6 = false, is_ipv4 = false;
+	bool is_ipv6 = false, is_ipv4 = false;
 
 	/* raweth_qp1_flags Bit 9-6 indicates itype */
 	if ((raweth_qp1_flags & CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS_ITYPE_ROCE)
@@ -2580,7 +2579,6 @@ static int bnxt_re_check_packet_type(u16 raweth_qp1_flags,
 	    CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_IP_CS_CALC &&
 	    raweth_qp1_flags2 &
 	    CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_L4_CS_CALC) {
-		is_udp = true;
 		/* raweth_qp1_flags2 Bit 8 indicates ip_type. 0-v4 1 - v6 */
 		(raweth_qp1_flags2 &
 		 CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_IP_TYPE) ?
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index e82644cf1aeb..a82044dacce0 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -160,11 +160,6 @@ void bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp)
 
 static void __bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp)
 {
-	struct bnxt_qplib_cq *scq, *rcq;
-
-	scq = qp->scq;
-	rcq = qp->rcq;
-
 	if (qp->sq.flushed) {
 		qp->sq.flushed = false;
 		list_del(&qp->sq_flush);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 2bdb1562bd21..000e6a1940b9 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -88,7 +88,6 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 	unsigned long flags;
 	u32 size, opcode;
 	u16 cookie, cbit;
-	int pg, idx;
 	u8 *preq;
 
 	opcode = req->opcode;
@@ -149,9 +148,6 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 	preq = (u8 *)req;
 	size = req->cmd_size * BNXT_QPLIB_CMDQE_UNITS;
 	do {
-		pg = 0;
-		idx = 0;
-
 		/* Locate the next cmdq slot */
 		sw_prod = HWQ_CMP(cmdq->prod, cmdq);
 		cmdqe = &cmdq_ptr[get_cmdq_pg(sw_prod)][get_cmdq_idx(sw_prod)];
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index e277e54a05eb..9543ce51a28a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -720,13 +720,12 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
 	struct cmdq_map_tc_to_cos req;
 	struct creq_map_tc_to_cos_resp resp;
 	u16 cmd_flags = 0;
-	int rc = 0;
 
 	RCFW_CMD_PREP(req, MAP_TC_TO_COS, cmd_flags);
 	req.cos0 = cpu_to_le16(cids[0]);
 	req.cos1 = cpu_to_le16(cids[1]);
 
-	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req,
-					  (void *)&resp, NULL, 0);
+	bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp, NULL,
+				     0);
 	return 0;
 }
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
