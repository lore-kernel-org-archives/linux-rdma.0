From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 33/43] cxgb4: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:33 +0300
Message-ID: <1437548143-24893-34-git-send-email-sagig@mellanox.com>
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
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  3 ++
 drivers/infiniband/hw/cxgb4/mem.c      | 11 +++++
 drivers/infiniband/hw/cxgb4/provider.c |  1 +
 drivers/infiniband/hw/cxgb4/qp.c       | 75 +++++++++++++++++++++++++++++++++-
 4 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index e529ace..ce2bbf3 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -978,6 +978,9 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
 			    u32 max_entries,
 			    u32 flags);
+int c4iw_map_mr_sg(struct ib_mr *ibmr,
+		   struct scatterlist *sg,
+		   unsigned short sg_nents);
 int c4iw_dealloc_mw(struct ib_mw *mw);
 struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
 struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 91aedce..ea37fc7 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -922,6 +922,17 @@ err:
 	return ERR_PTR(ret);
 }
 
+int c4iw_map_mr_sg(struct ib_mr *ibmr,
+		   struct scatterlist *sg,
+		   unsigned short sg_nents)
+{
+	struct c4iw_mr *mhp = to_c4iw_mr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mhp->max_mpl_len,
+			      mhp->mpl, &mhp->mpl_len,
+			      &ibmr->length, &ibmr->iova);
+}
+
 struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(struct ib_device *device,
 						     int page_list_len)
 {
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 7746113..55dedad 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -557,6 +557,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.bind_mw = c4iw_bind_mw;
 	dev->ibdev.dealloc_mw = c4iw_dealloc_mw;
 	dev->ibdev.alloc_mr = c4iw_alloc_mr;
+	dev->ibdev.map_mr_sg = c4iw_map_mr_sg;
 	dev->ibdev.alloc_fast_reg_page_list = c4iw_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = c4iw_free_fastreg_pbl;
 	dev->ibdev.attach_mcast = c4iw_multicast_attach;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 6517e12..e5d1d99 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -605,10 +605,75 @@ static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 	return 0;
 }
 
-static int build_fastreg(struct t4_sq *sq, union t4_wr *wqe,
+static int build_fastreg2(struct t4_sq *sq, union t4_wr *wqe,
 			 struct ib_send_wr *wr, u8 *len16, u8 t5dev)
 {
+	struct c4iw_mr *mhp = to_c4iw_mr(wr->wr.fastreg.mr);
+	struct fw_ri_immd *imdp;
+	__be64 *p;
+	int i;
+	int pbllen = roundup(mhp->mpl_len * sizeof(u64), 32);
+	int rem;
+
+	if (mhp->mpl_len > t4_max_fr_depth(use_dsgl))
+		return -EINVAL;
+
+	wqe->fr.qpbinde_to_dcacpu = 0;
+	wqe->fr.pgsz_shift = PAGE_SHIFT - 12;
+	wqe->fr.addr_type = FW_RI_VA_BASED_TO;
+	wqe->fr.mem_perms = c4iw_ib_to_tpt_access(mhp->ibmr.access);
+	wqe->fr.len_hi = 0;
+	wqe->fr.len_lo = cpu_to_be32(mhp->ibmr.length);
+	wqe->fr.stag = cpu_to_be32(wr->wr.fastreg.key);
+	wqe->fr.va_hi = cpu_to_be32(mhp->ibmr.iova >> 32);
+	wqe->fr.va_lo_fbo = cpu_to_be32(mhp->ibmr.iova &
+					0xffffffff);
+
+	if (t5dev && use_dsgl && (pbllen > max_fr_immd)) {
+		struct fw_ri_dsgl *sglp;
+
+		for (i = 0; i < mhp->mpl_len; i++) {
+			mhp->mpl[i] = (__force u64)cpu_to_be64((u64)mhp->mpl[i]);
+		}
+
+		sglp = (struct fw_ri_dsgl *)(&wqe->fr + 1);
+		sglp->op = FW_RI_DATA_DSGL;
+		sglp->r1 = 0;
+		sglp->nsge = cpu_to_be16(1);
+		sglp->addr0 = cpu_to_be64(mhp->mpl_addr);
+		sglp->len0 = cpu_to_be32(pbllen);
+
+		*len16 = DIV_ROUND_UP(sizeof(wqe->fr) + sizeof(*sglp), 16);
+	} else {
+		imdp = (struct fw_ri_immd *)(&wqe->fr + 1);
+		imdp->op = FW_RI_DATA_IMMD;
+		imdp->r1 = 0;
+		imdp->r2 = 0;
+		imdp->immdlen = cpu_to_be32(pbllen);
+		p = (__be64 *)(imdp + 1);
+		rem = pbllen;
+		for (i = 0; i < mhp->mpl_len; i++) {
+			*p = cpu_to_be64((u64)mhp->mpl[i]);
+			rem -= sizeof(*p);
+			if (++p == (__be64 *)&sq->queue[sq->size])
+				p = (__be64 *)sq->queue;
+		}
+		BUG_ON(rem < 0);
+		while (rem) {
+			*p = 0;
+			rem -= sizeof(*p);
+			if (++p == (__be64 *)&sq->queue[sq->size])
+				p = (__be64 *)sq->queue;
+		}
+		*len16 = DIV_ROUND_UP(sizeof(wqe->fr) + sizeof(*imdp)
+				      + pbllen, 16);
+	}
+	return 0;
+}
 
+static int build_fastreg(struct t4_sq *sq, union t4_wr *wqe,
+			 struct ib_send_wr *wr, u8 *len16, u8 t5dev)
+{
 	struct fw_ri_immd *imdp;
 	__be64 *p;
 	int i;
@@ -821,6 +886,14 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					    qhp->rhp->rdev.lldi.adapter_type) ?
 					    1 : 0);
 			break;
+		case IB_WR_FASTREG_MR:
+			fw_opcode = FW_RI_FR_NSMR_WR;
+			swsqe->opcode = FW_RI_FAST_REGISTER;
+			err = build_fastreg2(&qhp->wq.sq, wqe, wr, &len16,
+					    is_t5(
+					    qhp->rhp->rdev.lldi.adapter_type) ?
+					    1 : 0);
+			break;
 		case IB_WR_LOCAL_INV:
 			if (wr->send_flags & IB_SEND_FENCE)
 				fw_flags |= FW_RI_LOCAL_FENCE_FLAG;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
