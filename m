From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 31/43] ocrdma: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:31 +0300
Message-ID: <1437548143-24893-32-git-send-email-sagig@mellanox.com>
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
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 67 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |  3 ++
 3 files changed, 71 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 47d2814..2dd6b06 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -295,6 +295,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.reg_user_mr = ocrdma_reg_user_mr;
 
 	dev->ibdev.alloc_mr = ocrdma_alloc_mr;
+	dev->ibdev.map_mr_sg = ocrdma_map_mr_sg;
 	dev->ibdev.alloc_fast_reg_page_list = ocrdma_alloc_frmr_page_list;
 	dev->ibdev.free_fast_reg_page_list = ocrdma_free_frmr_page_list;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index a764cb9..0f32fc4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2121,6 +2121,59 @@ static int get_encoded_page_size(int pg_sz)
 	return i;
 }
 
+static int ocrdma_build_fr2(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
+			   struct ib_send_wr *wr)
+{
+	u64 fbo;
+	struct ocrdma_ewqe_fr *fast_reg = (struct ocrdma_ewqe_fr *)(hdr + 1);
+	struct ocrdma_mr *mr = get_ocrdma_mr(wr->wr.fastreg.mr);
+	struct ocrdma_pbl *pbl_tbl = mr->hwmr.pbl_table;
+	struct ocrdma_pbe *pbe;
+	u32 wqe_size = sizeof(*fast_reg) + sizeof(*hdr);
+	int num_pbes = 0, i;
+
+	wqe_size = roundup(wqe_size, OCRDMA_WQE_ALIGN_BYTES);
+
+	hdr->cw |= (OCRDMA_FR_MR << OCRDMA_WQE_OPCODE_SHIFT);
+	hdr->cw |= ((wqe_size / OCRDMA_WQE_STRIDE) << OCRDMA_WQE_SIZE_SHIFT);
+
+	if (mr->ibmr.access & IB_ACCESS_LOCAL_WRITE)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_LOCAL_WR;
+	if (mr->ibmr.access & IB_ACCESS_REMOTE_WRITE)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_WR;
+	if (mr->ibmr.access & IB_ACCESS_REMOTE_READ)
+		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_RD;
+	hdr->lkey = wr->wr.fastreg.key;
+	hdr->total_len = mr->ibmr.length;
+
+	fbo = mr->ibmr.iova - mr->pl[0];
+
+	fast_reg->va_hi = upper_32_bits(mr->ibmr.iova);
+	fast_reg->va_lo = (u32) (mr->ibmr.iova & 0xffffffff);
+	fast_reg->fbo_hi = upper_32_bits(fbo);
+	fast_reg->fbo_lo = (u32) fbo & 0xffffffff;
+	fast_reg->num_sges = mr->npages;
+	fast_reg->size_sge = get_encoded_page_size(1 << PAGE_SHIFT);
+
+	pbe = pbl_tbl->va;
+	for (i = 0; i < mr->npages; i++) {
+		u64 buf_addr = mr->pl[i];
+		pbe->pa_lo = cpu_to_le32((u32) (buf_addr & PAGE_MASK));
+		pbe->pa_hi = cpu_to_le32((u32) upper_32_bits(buf_addr));
+		num_pbes += 1;
+		pbe++;
+
+		/* if the pbl is full storing the pbes,
+		 * move to next pbl.
+		*/
+		if (num_pbes == (mr->hwmr.pbl_size/sizeof(u64))) {
+			pbl_tbl++;
+			pbe = (struct ocrdma_pbe *)pbl_tbl->va;
+		}
+	}
+
+	return 0;
+}
 
 static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 			   struct ib_send_wr *wr)
@@ -2248,6 +2301,9 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		case IB_WR_FAST_REG_MR:
 			status = ocrdma_build_fr(qp, hdr, wr);
 			break;
+		case IB_WR_FASTREG_MR:
+			status = ocrdma_build_fr2(qp, hdr, wr);
+			break;
 		default:
 			status = -EINVAL;
 			break;
@@ -3221,3 +3277,14 @@ pbl_err:
 	kfree(mr);
 	return ERR_PTR(status);
 }
+
+int ocrdma_map_mr_sg(struct ib_mr *ibmr,
+		     struct scatterlist *sg,
+		     unsigned short sg_nents)
+{
+	struct ocrdma_mr *mr = get_ocrdma_mr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mr->hwmr.num_pbes,
+			      mr->pl, &mr->npages,
+			      &ibmr->length, &ibmr->iova);
+}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index d09ff8e..4c60eec 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -100,6 +100,9 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
 			      enum ib_mr_type mr_type,
 			      u32 max_entries,
 			      u32 flags);
+int ocrdma_map_mr_sg(struct ib_mr *ibmr,
+		     struct scatterlist *sg,
+		     unsigned short sg_nents);
 struct ib_fast_reg_page_list *ocrdma_alloc_frmr_page_list(struct ib_device
 							*ibdev,
 							int page_list_len);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
