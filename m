From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 32/43] cxgb3: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:32 +0300
Message-ID: <1437548143-24893-33-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just duplicated the functions to take the needed
arguments from the private MR context. The old
fast_reg routines will be dropped later.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 12 ++++++++
 drivers/infiniband/hw/cxgb3/iwch_qp.c       | 48 +++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index c9368e6..b25cb6a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -857,6 +857,17 @@ err:
 	return ERR_PTR(ret);
 }
 
+static int iwch_map_mr_sg(struct ib_mr *ibmr,
+			  struct scatterlist *sg,
+			  unsigned short sg_nents)
+{
+	struct iwch_mr *mhp = to_iwch_mr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mhp->attr.pbl_size,
+			      mhp->pl, &mhp->npages,
+			      &ibmr->length, &ibmr->iova);
+}
+
 static struct ib_fast_reg_page_list *iwch_alloc_fastreg_pbl(
 					struct ib_device *device,
 					int page_list_len)
@@ -1455,6 +1466,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.bind_mw = iwch_bind_mw;
 	dev->ibdev.dealloc_mw = iwch_dealloc_mw;
 	dev->ibdev.alloc_mr = iwch_alloc_mr;
+	dev->ibdev.map_mr_sg = iwch_map_mr_sg;
 	dev->ibdev.alloc_fast_reg_page_list = iwch_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = iwch_free_fastreg_pbl;
 	dev->ibdev.attach_mcast = iwch_multicast_attach;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index b57c0be..2c30326 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -146,6 +146,49 @@ static int build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
 	return 0;
 }
 
+static int build_fastreg2(union t3_wr *wqe, struct ib_send_wr *wr,
+			  u8 *flit_cnt, int *wr_cnt, struct t3_wq *wq)
+{
+	struct iwch_mr *mhp = to_iwch_mr(wr->wr.fastreg.mr);
+	int i;
+	__be64 *p;
+
+	if (mhp->npages > T3_MAX_FASTREG_DEPTH)
+		return -EINVAL;
+	*wr_cnt = 1;
+	wqe->fastreg.stag = cpu_to_be32(wr->wr.fastreg.key);
+	wqe->fastreg.len = cpu_to_be32(mhp->ibmr.length);
+	wqe->fastreg.va_base_hi = cpu_to_be32(mhp->ibmr.iova >> 32);
+	wqe->fastreg.va_base_lo_fbo =
+				cpu_to_be32(mhp->ibmr.iova & 0xffffffff);
+	wqe->fastreg.page_type_perms = cpu_to_be32(
+		V_FR_PAGE_COUNT(mhp->npages) |
+		V_FR_PAGE_SIZE(PAGE_SHIFT - 12) |
+		V_FR_TYPE(TPT_VATO) |
+		V_FR_PERMS(iwch_ib_to_tpt_access(mhp->ibmr.access)));
+	p = &wqe->fastreg.pbl_addrs[0];
+	for (i = 0; i < mhp->npages; i++, p++) {
+
+		/* If we need a 2nd WR, then set it up */
+		if (i == T3_MAX_FASTREG_FRAG) {
+			*wr_cnt = 2;
+			wqe = (union t3_wr *)(wq->queue +
+				Q_PTR2IDX((wq->wptr+1), wq->size_log2));
+			build_fw_riwrh((void *)wqe, T3_WR_FASTREG, 0,
+			       Q_GENBIT(wq->wptr + 1, wq->size_log2),
+			       0, 1 + mhp->npages - T3_MAX_FASTREG_FRAG,
+			       T3_EOP);
+
+			p = &wqe->pbl_frag.pbl_addrs[0];
+		}
+		*p = cpu_to_be64((u64)mhp->pl[i]);
+	}
+	*flit_cnt = 5 + mhp->npages;
+	if (*flit_cnt > 15)
+		*flit_cnt = 15;
+	return 0;
+}
+
 static int build_fastreg(union t3_wr *wqe, struct ib_send_wr *wr,
 				u8 *flit_cnt, int *wr_cnt, struct t3_wq *wq)
 {
@@ -419,6 +462,11 @@ int iwch_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			err = build_fastreg(wqe, wr, &t3_wr_flit_cnt,
 						 &wr_cnt, &qhp->wq);
 			break;
+		case IB_WR_FASTREG_MR:
+			t3_wr_opcode = T3_WR_FASTREG;
+			err = build_fastreg2(wqe, wr, &t3_wr_flit_cnt,
+						 &wr_cnt, &qhp->wq);
+			break;
 		case IB_WR_LOCAL_INV:
 			if (wr->send_flags & IB_SEND_FENCE)
 				t3_wr_flags |= T3_LOCAL_FENCE_FLAG;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
