From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 2/2] RDMA/cxgb4: Fastreg NSMR fixes.
Date: Fri, 17 Sep 2010 15:40:15 -0500
Message-ID: <20100917204014.25530.68372.stgit@build.ogc.int>
References: <20100917204004.25530.62611.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100917204004.25530.62611.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

- Remove dsgl support - doesn't work in T4.

- Wrap the immediate PBL as needed when building it in the wr.

- Adjust max pbl depth allowed based on ulptx alignment requirements.

- Bump the slots per SQ to 5 to allow up to 128MB fast registers.

- Advertise fastreg support by default.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/provider.c |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c       |   52 +++++++++++++++-----------------
 drivers/infiniband/hw/cxgb4/t4.h       |    4 +-
 3 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index a49a9c1..81e1277 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -54,9 +54,9 @@
 
 #include "iw_cxgb4.h"
 
-static int fastreg_support;
+static int fastreg_support = 1;
 module_param(fastreg_support, int, 0644);
-MODULE_PARM_DESC(fastreg_support, "Advertise fastreg support (default=0)");
+MODULE_PARM_DESC(fastreg_support, "Advertise fastreg support (default=1)");
 
 static int c4iw_modify_port(struct ib_device *ibdev,
 			    u8 port, int port_modify_mask,
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7097ec4..d2c1d89 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -505,13 +505,15 @@ static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 	return 0;
 }
 
-static int build_fastreg(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
+static int build_fastreg(struct t4_sq *sq, union t4_wr *wqe,
+			 struct ib_send_wr *wr, u8 *len16)
 {
 
 	struct fw_ri_immd *imdp;
 	__be64 *p;
 	int i;
 	int pbllen = roundup(wr->wr.fast_reg.page_list_len * sizeof(u64), 32);
+	int rem;
 
 	if (wr->wr.fast_reg.page_list_len > T4_MAX_FR_DEPTH)
 		return -EINVAL;
@@ -526,32 +528,28 @@ static int build_fastreg(union t4_wr *wqe, struct ib_send_wr *wr, u8 *len16)
 	wqe->fr.va_hi = cpu_to_be32(wr->wr.fast_reg.iova_start >> 32);
 	wqe->fr.va_lo_fbo = cpu_to_be32(wr->wr.fast_reg.iova_start &
 					0xffffffff);
-	if (pbllen > T4_MAX_FR_IMMD) {
-		struct c4iw_fr_page_list *c4pl =
-				to_c4iw_fr_page_list(wr->wr.fast_reg.page_list);
-		struct fw_ri_dsgl *sglp;
-
-		sglp = (struct fw_ri_dsgl *)(&wqe->fr + 1);
-		sglp->op = FW_RI_DATA_DSGL;
-		sglp->r1 = 0;
-		sglp->nsge = cpu_to_be16(1);
-		sglp->addr0 = cpu_to_be64(c4pl->dma_addr);
-		sglp->len0 = cpu_to_be32(pbllen);
-
-		*len16 = DIV_ROUND_UP(sizeof wqe->fr + sizeof *sglp, 16);
-	} else {
-		imdp = (struct fw_ri_immd *)(&wqe->fr + 1);
-		imdp->op = FW_RI_DATA_IMMD;
-		imdp->r1 = 0;
-		imdp->r2 = 0;
-		imdp->immdlen = cpu_to_be32(pbllen);
-		p = (__be64 *)(imdp + 1);
-		for (i = 0; i < wr->wr.fast_reg.page_list_len; i++, p++)
-			*p = cpu_to_be64(
-				(u64)wr->wr.fast_reg.page_list->page_list[i]);
-		*len16 = DIV_ROUND_UP(sizeof wqe->fr + sizeof *imdp + pbllen,
-				      16);
+	WARN_ON(pbllen > T4_MAX_FR_IMMD);
+	imdp = (struct fw_ri_immd *)(&wqe->fr + 1);
+	imdp->op = FW_RI_DATA_IMMD;
+	imdp->r1 = 0;
+	imdp->r2 = 0;
+	imdp->immdlen = cpu_to_be32(pbllen);
+	p = (__be64 *)(imdp + 1);
+	rem = pbllen;
+	for (i = 0; i < wr->wr.fast_reg.page_list_len; i++) {
+		*p = cpu_to_be64((u64)wr->wr.fast_reg.page_list->page_list[i]);
+		rem -= sizeof *p;
+		if (++p == (__be64 *)&sq->queue[sq->size])
+			p = (__be64 *)sq->queue;
+	}
+	BUG_ON(rem < 0);
+	while (rem) {
+		*p = 0;
+		rem -= sizeof *p;
+		if (++p == (__be64 *)&sq->queue[sq->size])
+			p = (__be64 *)sq->queue;
 	}
+	*len16 = DIV_ROUND_UP(sizeof wqe->fr + sizeof *imdp + pbllen, 16);
 	return 0;
 }
 
@@ -652,7 +650,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_FAST_REG_MR:
 			fw_opcode = FW_RI_FR_NSMR_WR;
 			swsqe->opcode = FW_RI_FAST_REGISTER;
-			err = build_fastreg(wqe, wr, &len16);
+			err = build_fastreg(&qhp->wq.sq, wqe, wr, &len16);
 			break;
 		case IB_WR_LOCAL_INV:
 			if (wr->send_flags & IB_SEND_FENCE)
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 17ea5fc..7000442 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -66,7 +66,7 @@ struct t4_status_page {
 
 #define T4_EQ_ENTRY_SIZE 64
 
-#define T4_SQ_NUM_SLOTS 4
+#define T4_SQ_NUM_SLOTS 5
 #define T4_SQ_NUM_BYTES (T4_EQ_ENTRY_SIZE * T4_SQ_NUM_SLOTS)
 #define T4_MAX_SEND_SGE ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_send_wr) - \
 			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
@@ -79,7 +79,7 @@ struct t4_status_page {
 			sizeof(struct fw_ri_rdma_write_wr) - \
 			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
 #define T4_MAX_FR_IMMD ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_fr_nsmr_wr) - \
-			sizeof(struct fw_ri_immd)))
+			sizeof(struct fw_ri_immd)) & ~31UL)
 #define T4_MAX_FR_DEPTH (T4_MAX_FR_IMMD / sizeof(u64))
 
 #define T4_RQ_NUM_SLOTS 2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
