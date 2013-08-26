From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/14] RDMA/ocrdma: Add support for reg_phys_mr.
Date: Mon, 26 Aug 2013 15:27:45 +0530
Message-ID: <df60332b-2d16-4d6e-b7d3-a377e9a420ea@CMEXHTCAS1.ad.emulex.com>
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

Added support of reg_phys_mr.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 162 ++++++++++++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 4eeea56..7d43ba9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -326,6 +326,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.req_notify_cq = ocrdma_arm_cq;
 
 	dev->ibdev.get_dma_mr = ocrdma_get_dma_mr;
+	dev->ibdev.reg_phys_mr = ocrdma_reg_kernel_mr;
 	dev->ibdev.dereg_mr = ocrdma_dereg_mr;
 	dev->ibdev.reg_user_mr = ocrdma_reg_user_mr;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 812da17..e554fc2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2811,3 +2811,165 @@ void ocrdma_free_frmr_page_list(struct ib_fast_reg_page_list *page_list)
 	kfree(page_list);
 }
 
+#define MAX_KERNEL_PBE_SIZE 65536
+static inline int count_kernel_pbes(struct ib_phys_buf *buf_list,
+				    int buf_cnt, u32 *pbe_size)
+{
+	u64 total_size = 0;
+	u64 buf_size = 0;
+	int i;
+	*pbe_size = roundup(buf_list[0].size, PAGE_SIZE);
+	*pbe_size = roundup_pow_of_two(*pbe_size);
+
+	/* find the smallest PBE size that we can have */
+	for (i = 0; i < buf_cnt; i++) {
+		/* first addr may not be page aligned, so ignore checking */
+		if ((i != 0) && ((buf_list[i].addr & ~PAGE_MASK) ||
+				 (buf_list[i].size & ~PAGE_MASK))) {
+			return 0;
+		}
+
+		/* if configured PBE size is greater then the chosen one,
+		 * reduce the PBE size.
+		 */
+		buf_size = roundup(buf_list[i].size, PAGE_SIZE);
+		/* pbe_size has to be even multiple of 4K 1,2,4,8...*/
+		buf_size = roundup_pow_of_two(buf_size);
+		if (*pbe_size > buf_size)
+			*pbe_size = buf_size;
+
+		total_size += buf_size;
+	}
+	*pbe_size = *pbe_size > MAX_KERNEL_PBE_SIZE ?
+	    (MAX_KERNEL_PBE_SIZE) : (*pbe_size);
+
+	/* num_pbes = total_size / (*pbe_size);  this is implemented below. */
+
+	return total_size >> ilog2(*pbe_size);
+}
+
+static void build_kernel_pbes(struct ib_phys_buf *buf_list, int ib_buf_cnt,
+			      u32 pbe_size, struct ocrdma_pbl *pbl_tbl,
+			      struct ocrdma_hw_mr *hwmr)
+{
+	int i;
+	int idx;
+	int pbes_per_buf = 0;
+	u64 buf_addr = 0;
+	int num_pbes;
+	struct ocrdma_pbe *pbe;
+	int total_num_pbes = 0;
+
+	if (!hwmr->num_pbes)
+		return;
+
+	pbe = (struct ocrdma_pbe *)pbl_tbl->va;
+	num_pbes = 0;
+
+	/* go through the OS phy regions & fill hw pbe entries into pbls. */
+	for (i = 0; i < ib_buf_cnt; i++) {
+		buf_addr = buf_list[i].addr;
+		pbes_per_buf =
+		    roundup_pow_of_two(roundup(buf_list[i].size, PAGE_SIZE)) /
+		    pbe_size;
+		hwmr->len += buf_list[i].size;
+		/* number of pbes can be more for one OS buf, when
+		 * buffers are of different sizes.
+		 * split the ib_buf to one or more pbes.
+		 */
+		for (idx = 0; idx < pbes_per_buf; idx++) {
+			/* we program always page aligned addresses,
+			 * first unaligned address is taken care by fbo.
+			 */
+			if (i == 0) {
+				/* for non zero fbo, assign the
+				 * start of the page.
+				 */
+				pbe->pa_lo =
+				    cpu_to_le32((u32) (buf_addr & PAGE_MASK));
+				pbe->pa_hi =
+				    cpu_to_le32((u32) upper_32_bits(buf_addr));
+			} else {
+				pbe->pa_lo =
+				    cpu_to_le32((u32) (buf_addr & 0xffffffff));
+				pbe->pa_hi =
+				    cpu_to_le32((u32) upper_32_bits(buf_addr));
+			}
+			buf_addr += pbe_size;
+			num_pbes += 1;
+			total_num_pbes += 1;
+			pbe++;
+
+			if (total_num_pbes == hwmr->num_pbes)
+				goto mr_tbl_done;
+			/* if the pbl is full storing the pbes,
+			 * move to next pbl.
+			 */
+			if (num_pbes == (hwmr->pbl_size/sizeof(u64))) {
+				pbl_tbl++;
+				pbe = (struct ocrdma_pbe *)pbl_tbl->va;
+				num_pbes = 0;
+			}
+		}
+	}
+mr_tbl_done:
+	return;
+}
+
+struct ib_mr *ocrdma_reg_kernel_mr(struct ib_pd *ibpd,
+				   struct ib_phys_buf *buf_list,
+				   int buf_cnt, int acc, u64 *iova_start)
+{
+	int status = -ENOMEM;
+	struct ocrdma_mr *mr;
+	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
+	u32 num_pbes;
+	u32 pbe_size = 0;
+
+	if ((acc & IB_ACCESS_REMOTE_WRITE) && !(acc & IB_ACCESS_LOCAL_WRITE))
+		return ERR_PTR(-EINVAL);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(status);
+
+	num_pbes = count_kernel_pbes(buf_list, buf_cnt, &pbe_size);
+	if (num_pbes == 0) {
+		status = -EINVAL;
+		goto pbl_err;
+	}
+	status = ocrdma_get_pbl_info(dev, mr, num_pbes);
+	if (status)
+		goto pbl_err;
+
+	mr->hwmr.pbe_size = pbe_size;
+	mr->hwmr.fbo = *iova_start - (buf_list[0].addr & PAGE_MASK);
+	mr->hwmr.va = *iova_start;
+	mr->hwmr.local_rd = 1;
+	mr->hwmr.remote_wr = (acc & IB_ACCESS_REMOTE_WRITE) ? 1 : 0;
+	mr->hwmr.remote_rd = (acc & IB_ACCESS_REMOTE_READ) ? 1 : 0;
+	mr->hwmr.local_wr = (acc & IB_ACCESS_LOCAL_WRITE) ? 1 : 0;
+	mr->hwmr.remote_atomic = (acc & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
+	mr->hwmr.mw_bind = (acc & IB_ACCESS_MW_BIND) ? 1 : 0;
+
+	status = ocrdma_build_pbl_tbl(dev, &mr->hwmr);
+	if (status)
+		goto pbl_err;
+	build_kernel_pbes(buf_list, buf_cnt, pbe_size, mr->hwmr.pbl_table,
+			  &mr->hwmr);
+	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, acc);
+	if (status)
+		goto mbx_err;
+
+	mr->ibmr.lkey = mr->hwmr.lkey;
+	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
+		mr->ibmr.rkey = mr->hwmr.lkey;
+	return &mr->ibmr;
+
+mbx_err:
+	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
+pbl_err:
+	kfree(mr);
+	return ERR_PTR(status);
+}
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
