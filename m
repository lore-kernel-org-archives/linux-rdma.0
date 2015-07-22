From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 34/43] nes: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:34 +0300
Message-ID: <1437548143-24893-35-git-send-email-sagig@mellanox.com>
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
 drivers/infiniband/hw/nes/nes_verbs.c | 85 +++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 532496d..d5d8b01 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -465,6 +465,17 @@ err:
 	return ERR_PTR(-ENOMEM);
 }
 
+static int nes_map_mr_sg(struct ib_mr *ibmr,
+			 struct scatterlist *sg,
+			 unsigned short sg_nents)
+{
+	struct nes_mr *nesmr = to_nesmr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, nesmr->max_pages,
+			      nesmr->pl, &nesmr->npages,
+			      &ibmr->length, &ibmr->iova);
+}
+
 /*
  * nes_alloc_fast_reg_page_list
  */
@@ -3537,6 +3548,79 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 				  wqe_misc);
 			break;
 		}
+		case IB_WR_FASTREG_MR:
+		{
+			int i;
+			struct nes_mr *mr = to_nesmr(ib_wr->wr.fastreg.mr);
+			int flags = mr->ibmr.access;
+			u64 *src_page_list = mr->pl;
+			u64 *dst_page_list = mr->mpl;
+
+			if (mr->npages > (NES_4K_PBL_CHUNK_SIZE / sizeof(u64))) {
+				nes_debug(NES_DBG_IW_TX, "SQ_FMR: bad page_list_len\n");
+				err = -EINVAL;
+				break;
+			}
+			wqe_misc = NES_IWARP_SQ_OP_FAST_REG;
+			set_wqe_64bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_VA_FBO_LOW_IDX,
+					    mr->ibmr.iova);
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_LENGTH_LOW_IDX,
+					    mr->ibmr.length);
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_LENGTH_HIGH_IDX, 0);
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_MR_STAG_IDX,
+					    ib_wr->wr.fastreg.key);
+
+			/* Set page size: currently only 4K*/
+			if (ib_wr->wr.fast_reg.page_shift == 12) {
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_4K;
+			} else {
+				nes_debug(NES_DBG_IW_TX, "Invalid page shift,"
+					  " ib_wr=%u, max=1\n", ib_wr->num_sge);
+				err = -EINVAL;
+				break;
+			}
+
+			/* Set access_flags */
+			wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_READ;
+			if (flags & IB_ACCESS_LOCAL_WRITE)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_WRITE;
+
+			if (flags & IB_ACCESS_REMOTE_WRITE)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_WRITE;
+
+			if (flags & IB_ACCESS_REMOTE_READ)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_READ;
+
+			if (flags & IB_ACCESS_MW_BIND)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_WINDOW_BIND;
+
+			/* Fill in PBL info: */
+			set_wqe_64bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_PBL_ADDR_LOW_IDX,
+					    mr->mpl_addr);
+
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_PBL_LENGTH_IDX,
+					    mr->npages * 8);
+
+			for (i = 0; i < mr->npages; i++)
+				dst_page_list[i] = cpu_to_le64(src_page_list[i]);
+
+			nes_debug(NES_DBG_IW_TX, "SQ_FMR: iova_start: %llx, "
+				  "length: %d, rkey: %0x, pgl_paddr: %llx, "
+				  "page_list_len: %u, wqe_misc: %x\n",
+				  (unsigned long long) mr->ibmr.iova,
+				  mr->ibmr.length,
+				  ib_wr->wr.fastreg.key,
+				  (unsigned long long) mr->mpl_addr,
+				  mr->npages,
+				  wqe_misc);
+			break;
+		}
 		default:
 			/* error */
 			err = -EINVAL;
@@ -3964,6 +4048,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.bind_mw = nes_bind_mw;
 
 	nesibdev->ibdev.alloc_mr = nes_alloc_mr;
+	nesibdev->ibdev.map_mr_sg = nes_map_mr_sg;
 	nesibdev->ibdev.alloc_fast_reg_page_list = nes_alloc_fast_reg_page_list;
 	nesibdev->ibdev.free_fast_reg_page_list = nes_free_fast_reg_page_list;
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
