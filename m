From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 9/9] IB/hfi1,qib: Do not send QKey trap for UD qps
Date: Mon, 29 May 2017 17:22:01 -0700
Message-ID: <20170530002137.534.67981.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

According to IBTA spec a QKey violation should not result in a bad qkey
trap being triggered for UD queue pairs. Also since it is a silent error
we do not increment the q_key violation or the dropped packet counters.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c      |   14 ++++-------
 drivers/infiniband/hw/hfi1/ruc.c      |    8 +++---
 drivers/infiniband/hw/hfi1/ud.c       |   37 +++++++++-------------------
 drivers/infiniband/hw/hfi1/verbs.h    |    4 ++-
 drivers/infiniband/hw/qib/qib_mad.c   |   13 ++++------
 drivers/infiniband/hw/qib/qib_ruc.c   |   20 ++++++++-------
 drivers/infiniband/hw/qib/qib_ud.c    |   43 +++++++++++----------------------
 drivers/infiniband/hw/qib/qib_verbs.h |    4 ++-
 8 files changed, 54 insertions(+), 89 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index c8daf63..a081a98 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -180,10 +180,10 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 }
 
 /*
- * Send a bad [PQ]_Key trap (ch. 14.3.8).
+ * Send a bad P_Key trap (ch. 14.3.8).
  */
-void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		    u32 qp1, u32 qp2, u16 lid1, u16 lid2)
+void hfi1_bad_pkey(struct hfi1_ibport *ibp, u32 key, u32 sl,
+		   u32 qp1, u32 qp2, u16 lid1, u16 lid2)
 {
 	struct opa_mad_notice_attr data;
 	u32 lid = ppd_from_ibp(ibp)->lid;
@@ -191,17 +191,13 @@ void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 	u32 _lid2 = lid2;
 
 	memset(&data, 0, sizeof(data));
-
-	if (trap_num == OPA_TRAP_BAD_P_KEY)
-		ibp->rvp.pkey_violations++;
-	else
-		ibp->rvp.qkey_violations++;
 	ibp->rvp.n_pkt_drops++;
+	ibp->rvp.pkey_violations++;
 
 	/* Send violation trap */
 	data.generic_type = IB_NOTICE_TYPE_SECURITY;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = trap_num;
+	data.trap_num = OPA_TRAP_BAD_P_KEY;
 	data.issuer_lid = cpu_to_be32(lid);
 	data.ntc_257_258.lid1 = cpu_to_be32(_lid1);
 	data.ntc_257_258.lid2 = cpu_to_be32(_lid2);
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 476fe5d..9cf506a 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -254,8 +254,8 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
 					    sc5, slid))) {
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY, (u16)bth0, sl,
-				       0, qp->ibqp.qp_num, slid, dlid);
+			hfi1_bad_pkey(ibp, (u16)bth0, sl,
+				      0, qp->ibqp.qp_num, slid, dlid);
 			return 1;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
@@ -290,8 +290,8 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
 					    sc5, slid))) {
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY, (u16)bth0, sl,
-				       0, qp->ibqp.qp_num, slid, dlid);
+			hfi1_bad_pkey(ibp, (u16)bth0, sl,
+				      0, qp->ibqp.qp_num, slid, dlid);
 			return 1;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index c995aa5..6bf7a1b 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -110,10 +110,10 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 				   ((1 << ppd->lmc) - 1));
 		if (unlikely(ingress_pkey_check(ppd, pkey, sc5,
 						qp->s_pkey_index, slid))) {
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY, pkey,
-				       rdma_ah_get_sl(ah_attr),
-				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				       slid, rdma_ah_get_dlid(ah_attr));
+			hfi1_bad_pkey(ibp, pkey,
+				      rdma_ah_get_sl(ah_attr),
+				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
+				      slid, rdma_ah_get_dlid(ah_attr));
 			goto drop;
 		}
 	}
@@ -128,18 +128,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 		qkey = (int)swqe->ud_wr.remote_qkey < 0 ?
 			sqp->qkey : swqe->ud_wr.remote_qkey;
-		if (unlikely(qkey != qp->qkey)) {
-			u16 lid;
-
-			lid = ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
-					  ((1 << ppd->lmc) - 1));
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey,
-				       rdma_ah_get_sl(ah_attr),
-				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				       lid,
-				       rdma_ah_get_dlid(ah_attr));
-			goto drop;
-		}
+		if (unlikely(qkey != qp->qkey))
+			goto drop; /* silently drop per IBTA spec */
 	}
 
 	/*
@@ -722,10 +712,10 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 				 * for invalid pkeys is optional according to
 				 * IB spec (release 1.3, section 10.9.4)
 				 */
-				hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
-					       pkey, sl,
-					       src_qp, qp->ibqp.qp_num,
-					       slid, dlid);
+				hfi1_bad_pkey(ibp,
+					      pkey, sl,
+					      src_qp, qp->ibqp.qp_num,
+					      slid, dlid);
 				return;
 			}
 		} else {
@@ -734,12 +724,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 			if (mgmt_pkey_idx < 0)
 				goto drop;
 		}
-		if (unlikely(qkey != qp->qkey)) {
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey, sl,
-				       src_qp, qp->ibqp.qp_num,
-				       slid, dlid);
+		if (unlikely(qkey != qp->qkey)) /* Silent drop */
 			return;
-		}
+
 		/* Drop invalid MAD packets (see 13.5.3.1). */
 		if (unlikely(qp->ibqp.qp_num == 1 &&
 			     (tlen > 2048 || (sc5 == 0xF))))
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 17b38cd..fdf1e1f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -236,8 +236,8 @@ static inline int hfi1_send_ok(struct rvt_qp *qp)
 /*
  * This must be called with s_lock held.
  */
-void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		    u32 qp1, u32 qp2, u16 lid1, u16 lid2);
+void hfi1_bad_pkey(struct hfi1_ibport *ibp, u32 key, u32 sl,
+		   u32 qp1, u32 qp2, u16 lid1, u16 lid2);
 void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
 void hfi1_sys_guid_chg(struct hfi1_ibport *ibp);
 void hfi1_node_desc_chg(struct hfi1_ibport *ibp);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index da295e0..a4a7f2a 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -134,24 +134,21 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
 }
 
 /*
- * Send a bad [PQ]_Key trap (ch. 14.3.8).
+ * Send a bad P_Key trap (ch. 14.3.8).
  */
-void qib_bad_pqkey(struct qib_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		   u32 qp1, u32 qp2, __be16 lid1, __be16 lid2)
+void qib_bad_pkey(struct qib_ibport *ibp, u32 key, u32 sl,
+		  u32 qp1, u32 qp2, __be16 lid1, __be16 lid2)
 {
 	struct ib_mad_notice_attr data;
 
-	if (trap_num == IB_NOTICE_TRAP_BAD_PKEY)
-		ibp->rvp.pkey_violations++;
-	else
-		ibp->rvp.qkey_violations++;
 	ibp->rvp.n_pkt_drops++;
+	ibp->rvp.pkey_violations++;
 
 	/* Send violation trap */
 	data.generic_type = IB_NOTICE_TYPE_SECURITY;
 	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = trap_num;
+	data.trap_num = IB_NOTICE_TRAP_BAD_PKEY;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
 	memset(&data.details, 0, sizeof(data.details));
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 88d84cb..2852845 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -256,11 +256,11 @@ int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 		}
 		if (!qib_pkey_ok((u16)bth0,
 				 qib_get_pkey(ibp, qp->s_alt_pkey_index))) {
-			qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
-				      (u16)bth0,
-				      (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
-				      0, qp->ibqp.qp_num,
-				      hdr->lrh[3], hdr->lrh[1]);
+			qib_bad_pkey(ibp,
+				     (u16)bth0,
+				     (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
+				     0, qp->ibqp.qp_num,
+				     hdr->lrh[3], hdr->lrh[1]);
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
@@ -295,11 +295,11 @@ int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 		}
 		if (!qib_pkey_ok((u16)bth0,
 				 qib_get_pkey(ibp, qp->s_pkey_index))) {
-			qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
-				      (u16)bth0,
-				      (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
-				      0, qp->ibqp.qp_num,
-				      hdr->lrh[3], hdr->lrh[1]);
+			qib_bad_pkey(ibp,
+				     (u16)bth0,
+				     (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
+				     0, qp->ibqp.qp_num,
+				     hdr->lrh[3], hdr->lrh[1]);
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 341a123..be49074 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -66,8 +66,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	qp = rvt_lookup_qpn(rdi, &ibp->rvp, swqe->ud_wr.remote_qpn);
 	if (!qp) {
 		ibp->rvp.n_pkt_drops++;
-		rcu_read_unlock();
-		return;
+		goto drop;
 	}
 
 	sqptype = sqp->ibqp.qp_type == IB_QPT_GSI ?
@@ -94,11 +93,11 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		if (unlikely(!qib_pkey_ok(pkey1, pkey2))) {
 			lid = ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
 					  ((1 << ppd->lmc) - 1));
-			qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY, pkey1,
-				      rdma_ah_get_sl(ah_attr),
-				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				      cpu_to_be16(lid),
-				      cpu_to_be16(rdma_ah_get_dlid(ah_attr)));
+			qib_bad_pkey(ibp, pkey1,
+				     rdma_ah_get_sl(ah_attr),
+				     sqp->ibqp.qp_num, qp->ibqp.qp_num,
+				     cpu_to_be16(lid),
+				     cpu_to_be16(rdma_ah_get_dlid(ah_attr)));
 			goto drop;
 		}
 	}
@@ -113,18 +112,8 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 		qkey = (int)swqe->ud_wr.remote_qkey < 0 ?
 			sqp->qkey : swqe->ud_wr.remote_qkey;
-		if (unlikely(qkey != qp->qkey)) {
-			u16 lid;
-
-			lid = ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
-					  ((1 << ppd->lmc) - 1));
-			qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_QKEY, qkey,
-				      rdma_ah_get_sl(ah_attr),
-				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				      cpu_to_be16(lid),
-				      cpu_to_be16(rdma_ah_get_dlid(ah_attr)));
+		if (unlikely(qkey != qp->qkey))
 			goto drop;
-		}
 	}
 
 	/*
@@ -487,22 +476,18 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 			pkey1 = be32_to_cpu(ohdr->bth[0]);
 			pkey2 = qib_get_pkey(ibp, qp->s_pkey_index);
 			if (unlikely(!qib_pkey_ok(pkey1, pkey2))) {
-				qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
-					      pkey1,
-					      (be16_to_cpu(hdr->lrh[0]) >> 4) &
+				qib_bad_pkey(ibp,
+					     pkey1,
+					     (be16_to_cpu(hdr->lrh[0]) >> 4) &
 						0xF,
-					      src_qp, qp->ibqp.qp_num,
-					      hdr->lrh[3], hdr->lrh[1]);
+					     src_qp, qp->ibqp.qp_num,
+					     hdr->lrh[3], hdr->lrh[1]);
 				return;
 			}
 		}
-		if (unlikely(qkey != qp->qkey)) {
-			qib_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_QKEY, qkey,
-				      (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
-				      src_qp, qp->ibqp.qp_num,
-				      hdr->lrh[3], hdr->lrh[1]);
+		if (unlikely(qkey != qp->qkey))
 			return;
-		}
+
 		/* Drop invalid MAD packets (see 13.5.3.1). */
 		if (unlikely(qp->ibqp.qp_num == 1 &&
 			     (tlen != 256 ||
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index da0db54..33d5691 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -241,8 +241,8 @@ static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)
 	return p1 && p1 == p2 && ((__s16)pkey1 < 0 || (__s16)pkey2 < 0);
 }
 
-void qib_bad_pqkey(struct qib_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		   u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
+void qib_bad_pkey(struct qib_ibport *ibp, u32 key, u32 sl,
+		  u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
 void qib_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
 void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
