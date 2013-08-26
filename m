From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/14] RDMA/ocrdma: Add support for FRMR.
Date: Mon, 26 Aug 2013 15:27:39 +0530
Message-ID: <2eee7e35-504e-4f2a-a364-527e90669108@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Also get the max_srq value from query_config mailbox response.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   3 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   4 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  19 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 163 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   5 +
 6 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b451166..634c2e1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -56,6 +56,7 @@ struct ocrdma_dev_attr {
 	u16 max_qp;
 	u16 max_wqe;
 	u16 max_rqe;
+	u16 max_srq;
 	u32 max_inline_data;
 	int max_send_sge;
 	int max_recv_sge;
@@ -169,6 +170,7 @@ struct ocrdma_dev {
 	struct list_head entry;
 	struct rcu_head rcu;
 	int id;
+	u64 stag_arr[OCRDMA_MAX_STAG];
 };
 
 struct ocrdma_cq {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 31fd3ff..af3c5f5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -999,6 +999,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_ord_per_qp = (rsp->max_ird_ord_per_qp &
 				OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_ORD_PER_QP_SHIFT;
+	attr->max_srq =
+		(rsp->max_srq_rpir_qps & OCRDMA_MBX_QUERY_CFG_MAX_SRQ_MASK) >>
+		OCRDMA_MBX_QUERY_CFG_MAX_SRQ_OFFSET;
 	attr->max_ird_per_qp = (rsp->max_ird_ord_per_qp &
 				OCRDMA_MBX_QUERY_CFG_MAX_IRD_PER_QP_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_MAX_IRD_PER_QP_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index ded416f..4eeea56 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -329,6 +329,10 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.dereg_mr = ocrdma_dereg_mr;
 	dev->ibdev.reg_user_mr = ocrdma_reg_user_mr;
 
+	dev->ibdev.alloc_fast_reg_mr = ocrdma_alloc_frmr;
+	dev->ibdev.alloc_fast_reg_page_list = ocrdma_alloc_frmr_page_list;
+	dev->ibdev.free_fast_reg_page_list = ocrdma_free_frmr_page_list;
+
 	/* mandatory to support user space verbs consumer. */
 	dev->ibdev.alloc_ucontext = ocrdma_alloc_ucontext;
 	dev->ibdev.dealloc_ucontext = ocrdma_dealloc_ucontext;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 0184009..6cf5a96 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -91,6 +91,7 @@ enum {
 
 #define OCRDMA_MAX_QP    2048
 #define OCRDMA_MAX_CQ    2048
+#define OCRDMA_MAX_STAG  2048
 
 enum {
 	OCRDMA_DB_RQ_OFFSET		= 0xE0,
@@ -1564,6 +1565,7 @@ enum OCRDMA_WQE_OPCODE {
 	OCRDMA_SEND		= 0x00,
 	OCRDMA_CMP_SWP		= 0x14,
 	OCRDMA_BIND_MW		= 0x10,
+	OCRDMA_FR_MR            = 0x11,
 	OCRDMA_RESV1		= 0x0A,
 	OCRDMA_LKEY_INV		= 0x15,
 	OCRDMA_FETCH_ADD	= 0x13,
@@ -1610,6 +1612,23 @@ struct ocrdma_ewqe_ud_hdr {
 	u32 rsvd;
 };
 
+#define OCRDMA_MAX_FR_PBES 11
+struct ocrdma_fr_pbe {
+	u32 pa_hi;
+	u32 pa_lo;
+};
+
+/* extended wqe followed by hdr_wqe for Fast Memory register */
+struct ocrdma_ewqe_fr {
+	u32 va_hi;
+	u32 va_lo;
+	u32 fbo_hi;
+	u32 fbo_lo;
+	u32 size_sge;
+	u32 num_sges;
+	struct ocrdma_fr_pbe pbe[0];
+};
+
 struct ocrdma_eth_basic {
 	u8 dmac[6];
 	u8 smac[6];
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 278b33b..d700946 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -96,7 +96,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->max_qp_rd_atom =
 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
 	attr->max_qp_init_rd_atom = dev->attr.max_ord_per_qp;
-	attr->max_srq = (dev->attr.max_qp - 1);
+	attr->max_srq = dev->attr.max_srq;
 	attr->max_srq_sge = dev->attr.max_srq_sge;
 	attr->max_srq_wr = dev->attr.max_rqe;
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
@@ -1304,7 +1304,6 @@ static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
 
 static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
 {
-	int free_cnt;
 	return ((q->max_wqe_idx - q->head) + q->tail) % q->max_cnt;
 }
 
@@ -1746,6 +1745,96 @@ static void ocrdma_build_read(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 	ext_rw->len = hdr->total_len;
 }
 
+static void build_frmr_pbes(struct ib_send_wr *wr, struct ocrdma_pbl *pbl_tbl,
+			    struct ocrdma_hw_mr *hwmr)
+{
+	int i;
+	u64 buf_addr = 0;
+	int num_pbes;
+	struct ocrdma_pbe *pbe;
+
+	pbe = (struct ocrdma_pbe *)pbl_tbl->va;
+	num_pbes = 0;
+
+	/* go through the OS phy regions & fill hw pbe entries into pbls. */
+	for (i = 0; i < wr->wr.fast_reg.page_list_len; i++) {
+		/* number of pbes can be more for one OS buf, when
+		 * buffers are of different sizes.
+		 * split the ib_buf to one or more pbes.
+		 */
+		buf_addr = wr->wr.fast_reg.page_list->page_list[i];
+		pbe->pa_lo = cpu_to_le32((u32) (buf_addr & PAGE_MASK));
+		pbe->pa_hi = cpu_to_le32((u32) upper_32_bits(buf_addr));
+		num_pbes += 1;
+		pbe++;
+
+		/* if the pbl is full storing the pbes,
+		 * move to next pbl.
+		*/
+		if (num_pbes == (hwmr->pbl_size/sizeof(u64))) {
+			pbl_tbl++;
+			pbe = (struct ocrdma_pbe *)pbl_tbl->va;
+		}
+	}
+	return;
+}
+
+static int get_encoded_page_size(int pg_sz)
+{
+	/* Max size is 256M 4096 << 16 */
+	int i = 0;
+	for (; i < 17; i++)
+		if (pg_sz == (4096 << i))
+			break;
+	return i;
+}
+
+
+static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
+			   struct ib_send_wr *wr)
+{
+	u64 fbo;
+	struct ocrdma_ewqe_fr *fast_reg = (struct ocrdma_ewqe_fr *)(hdr + 1);
+	struct ocrdma_mr *mr;
+	u32 wqe_size = sizeof(*fast_reg) + sizeof(*hdr);
+
+	wqe_size = roundup(wqe_size, OCRDMA_WQE_ALIGN_BYTES);
+
+	if ((wr->wr.fast_reg.page_list_len >
+		qp->dev->attr.max_pages_per_frmr) ||
+		(wr->wr.fast_reg.length > 0xffffffffULL))
+		return -EINVAL;
+
+	hdr->cw |= (OCRDMA_FR_MR << OCRDMA_WQE_OPCODE_SHIFT);
+	hdr->cw |= ((wqe_size / OCRDMA_WQE_STRIDE) << OCRDMA_WQE_SIZE_SHIFT);
+
+	if (wr->wr.fast_reg.page_list_len == 0)
+		BUG();
+	if (wr->wr.fast_reg.access_flags & IB_ACCESS_LOCAL_WRITE)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_LOCAL_WR;
+	if (wr->wr.fast_reg.access_flags & IB_ACCESS_REMOTE_WRITE)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_WR;
+	if (wr->wr.fast_reg.access_flags & IB_ACCESS_REMOTE_READ)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_RD;
+	hdr->lkey = wr->wr.fast_reg.rkey;
+	hdr->total_len = wr->wr.fast_reg.length;
+
+	fbo = wr->wr.fast_reg.iova_start -
+	    (wr->wr.fast_reg.page_list->page_list[0] & PAGE_MASK);
+
+	fast_reg->va_hi = upper_32_bits(wr->wr.fast_reg.iova_start);
+	fast_reg->va_lo = (u32) (wr->wr.fast_reg.iova_start & 0xffffffff);
+	fast_reg->fbo_hi = upper_32_bits(fbo);
+	fast_reg->fbo_lo = (u32) fbo & 0xffffffff;
+	fast_reg->num_sges = wr->wr.fast_reg.page_list_len;
+	fast_reg->size_sge =
+		get_encoded_page_size(1 << wr->wr.fast_reg.page_shift);
+	mr = (struct ocrdma_mr *)qp->dev->stag_arr[(hdr->lkey >> 8) &
+		(OCRDMA_MAX_STAG - 1)];
+	build_frmr_pbes(wr, mr->hwmr.pbl_table, &mr->hwmr);
+	return 0;
+}
+
 static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)
 {
 	u32 val = qp->sq.dbid | (1 << 16);
@@ -1815,10 +1904,14 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_LOCAL_INV:
 			hdr->cw |=
 			    (OCRDMA_LKEY_INV << OCRDMA_WQE_OPCODE_SHIFT);
-			hdr->cw |= (sizeof(struct ocrdma_hdr_wqe) /
+			hdr->cw |= ((sizeof(struct ocrdma_hdr_wqe) +
+					sizeof(struct ocrdma_sge)) /
 				OCRDMA_WQE_STRIDE) << OCRDMA_WQE_SIZE_SHIFT;
 			hdr->lkey = wr->ex.invalidate_rkey;
 			break;
+		case IB_WR_FAST_REG_MR:
+			status = ocrdma_build_fr(qp, hdr, wr);
+			break;
 		default:
 			status = -EINVAL;
 			break;
@@ -2085,6 +2178,9 @@ static void ocrdma_update_wc(struct ocrdma_qp *qp, struct ib_wc *ibwc,
 	case OCRDMA_SEND:
 		ibwc->opcode = IB_WC_SEND;
 		break;
+	case OCRDMA_FR_MR:
+		ibwc->opcode = IB_WC_FAST_REG_MR;
+		break;
 	case OCRDMA_LKEY_INV:
 		ibwc->opcode = IB_WC_LOCAL_INV;
 		break;
@@ -2530,3 +2626,64 @@ int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 	return 0;
 }
+
+struct ib_mr *ocrdma_alloc_frmr(struct ib_pd *ibpd, int max_page_list_len)
+{
+	int status;
+	struct ocrdma_mr *mr;
+	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
+
+	if (max_page_list_len > dev->attr.max_pages_per_frmr)
+		return ERR_PTR(-EINVAL);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	status = ocrdma_get_pbl_info(dev, mr, max_page_list_len);
+	if (status)
+		goto pbl_err;
+	mr->hwmr.fr_mr = 1;
+	mr->hwmr.remote_rd = 0;
+	mr->hwmr.remote_wr = 0;
+	mr->hwmr.local_rd = 0;
+	mr->hwmr.local_wr = 0;
+	mr->hwmr.mw_bind = 0;
+	status = ocrdma_build_pbl_tbl(dev, &mr->hwmr);
+	if (status)
+		goto pbl_err;
+	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, 0);
+	if (status)
+		goto mbx_err;
+	mr->ibmr.rkey = mr->hwmr.lkey;
+	mr->ibmr.lkey = mr->hwmr.lkey;
+	dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] = (u64) mr;
+	return &mr->ibmr;
+mbx_err:
+	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
+pbl_err:
+	kfree(mr);
+	return ERR_PTR(-ENOMEM);
+}
+
+struct ib_fast_reg_page_list *ocrdma_alloc_frmr_page_list(struct ib_device
+							  *ibdev,
+							  int page_list_len)
+{
+	struct ib_fast_reg_page_list *frmr_list;
+	int size;
+
+	size = sizeof(*frmr_list) + (page_list_len * sizeof(u64));
+	frmr_list = kzalloc(size, GFP_KERNEL);
+	if (!frmr_list)
+		return ERR_PTR(-ENOMEM);
+	frmr_list->page_list = (u64 *)(frmr_list + 1);
+	return frmr_list;
+}
+
+void ocrdma_free_frmr_page_list(struct ib_fast_reg_page_list *page_list)
+{
+	kfree(page_list);
+}
+
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 633f03d..7f30567 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -89,5 +89,10 @@ struct ib_mr *ocrdma_reg_kernel_mr(struct ib_pd *,
 				   int num_phys_buf, int acc, u64 *iova_start);
 struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *, u64 start, u64 length,
 				 u64 virt, int acc, struct ib_udata *);
+struct ib_mr *ocrdma_alloc_frmr(struct ib_pd *pd, int max_page_list_len);
+struct ib_fast_reg_page_list *ocrdma_alloc_frmr_page_list(struct ib_device
+							*ibdev,
+							int page_list_len);
+void ocrdma_free_frmr_page_list(struct ib_fast_reg_page_list *page_list);
 
 #endif				/* __OCRDMA_VERBS_H__ */
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
