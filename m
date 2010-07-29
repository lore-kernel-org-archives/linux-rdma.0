From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 4/4] mthca: Add support for reg_io_mr and unreg_io_mr
Date: Thu, 29 Jul 2010 11:25:20 -0500
Message-ID: <20100729162520.14674.91057.stgit@build.ogc.int>
References: <20100729162339.14674.15788.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729162339.14674.15788.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add support for the new I/O memory registration verbs to
the mthca driver.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/hw/mthca/mthca_provider.c |  111 ++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..3d3e871 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -900,6 +900,114 @@ static inline u32 convert_access(int acc)
 	       MTHCA_MPT_FLAG_LOCAL_READ;
 }
 
+static struct ib_mr *mthca_reg_io_mr(struct ib_pd *pd, u64 start, u64 length,
+				     u64 virt, int acc, struct ib_udata *udata)
+{
+	struct mthca_dev *dev = to_mdev(pd->device);
+	struct ib_umem_chunk *chunk;
+	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
+	u64 *pages;
+	int shift, n, len;
+	int i, j, k;
+	int err = 0;
+	int write_mtt_size;
+
+	if (udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) < sizeof ucmd) {
+		if (!to_mucontext(pd->uobject->context)->reg_mr_warned) {
+			mthca_warn(dev,
+				   "Process '%s' did not pass in MR attrs.\n",
+				   current->comm);
+			mthca_warn(dev, "  Update libmthca to fix this.\n");
+		}
+		++to_mucontext(pd->uobject->context)->reg_mr_warned;
+		ucmd.mr_attrs = 0;
+	} else if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
+		return ERR_PTR(-EFAULT);
+
+	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->umem = ib_iomem_get(pd->uobject->context, start, length, acc,
+				ucmd.mr_attrs & MTHCA_MR_DMASYNC);
+
+	if (IS_ERR(mr->umem)) {
+		err = PTR_ERR(mr->umem);
+		goto err;
+	}
+
+	shift = ffs(mr->umem->page_size) - 1;
+
+	n = 0;
+	list_for_each_entry(chunk, &mr->umem->chunk_list, list)
+		n += chunk->nents;
+
+	mr->mtt = mthca_alloc_mtt(dev, n);
+	if (IS_ERR(mr->mtt)) {
+		err = PTR_ERR(mr->mtt);
+		goto err_umem;
+	}
+
+	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	if (!pages) {
+		err = -ENOMEM;
+		goto err_mtt;
+	}
+
+	i = n = 0;
+
+	write_mtt_size = min(mthca_write_mtt_size(dev),
+			     (int) (PAGE_SIZE / sizeof *pages));
+
+	list_for_each_entry(chunk, &mr->umem->chunk_list, list)
+		for (j = 0; j < chunk->nmap; ++j) {
+			len = sg_dma_len(&chunk->page_list[j]) >> shift;
+			for (k = 0; k < len; ++k) {
+				pages[i++] =
+					sg_dma_address(&chunk->page_list[j]) +
+					mr->umem->page_size * k;
+				/*
+				 * Be friendly to write_mtt and pass it chunks
+				 * of appropriate size.
+				 */
+				if (i == write_mtt_size) {
+					err = mthca_write_mtt(dev, mr->mtt, n,
+							      pages, i);
+					if (err)
+						goto mtt_done;
+					n += i;
+					i = 0;
+				}
+			}
+		}
+
+	if (i)
+		err = mthca_write_mtt(dev, mr->mtt, n, pages, i);
+mtt_done:
+	free_page((unsigned long) pages);
+	if (err)
+		goto err_mtt;
+
+	err = mthca_mr_alloc(dev, to_mpd(pd)->pd_num, shift, virt, length,
+			     convert_access(acc), mr);
+
+	if (err)
+		goto err_mtt;
+
+	return &mr->ibmr;
+
+err_mtt:
+	mthca_free_mtt(dev, mr->mtt);
+
+err_umem:
+	ib_umem_release(mr->umem);
+
+err:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
 static struct ib_mr *mthca_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	struct mthca_mr *mr;
@@ -1318,6 +1426,8 @@ int mthca_register_device(struct mthca_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
 		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
 		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_REG_IO_MR)		|
+		(1ull << IB_USER_VERBS_CMD_DEREG_IO_MR)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
 		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
 		(1ull << IB_USER_VERBS_CMD_RESIZE_CQ)		|
@@ -1376,6 +1486,7 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.reg_phys_mr          = mthca_reg_phys_mr;
 	dev->ib_dev.reg_user_mr          = mthca_reg_user_mr;
 	dev->ib_dev.dereg_mr             = mthca_dereg_mr;
+	dev->ib_dev.reg_io_mr		 = mthca_reg_io_mr;
 
 	if (dev->mthca_flags & MTHCA_FLAG_FMR) {
 		dev->ib_dev.alloc_fmr            = mthca_alloc_fmr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
