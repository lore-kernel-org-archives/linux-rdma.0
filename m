From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 3/9] IB/core: Umem tunneling peer memory APIs
Date: Thu, 23 Oct 2014 15:02:51 +0300
Message-ID: <1414065777-21173-4-git-send-email-yishaih@mellanox.com>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414065777-21173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Builds umem over peer memory client functionality.
It tries getting a peer client for a given address range, in case found
further memory calls are tunneled to that peer client.
ib_umem_get was extended to have an indication whether this umem can
be part of a peer client. As a result, usage of
ib_umem_get was updated accordingly.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c               |   77 +++++++++++++++++++++++++-
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c            |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |    2 +-
 drivers/infiniband/hw/mlx4/cq.c              |    2 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx4/mr.c              |   11 +++-
 drivers/infiniband/hw/mlx4/qp.c              |    2 +-
 drivers/infiniband/hw/mlx4/srq.c             |    2 +-
 drivers/infiniband/hw/mlx5/cq.c              |    5 +-
 drivers/infiniband/hw/mlx5/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx5/mr.c              |    2 +-
 drivers/infiniband/hw/mlx5/qp.c              |    2 +-
 drivers/infiniband/hw/mlx5/srq.c             |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    2 +-
 drivers/infiniband/hw/qib/qib_mr.c           |    2 +-
 include/rdma/ib_peer_mem.h                   |    4 +
 include/rdma/ib_umem.h                       |   13 +++-
 22 files changed, 119 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index df0c4f6..f3e445c 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -42,6 +42,66 @@
 
 #include "uverbs.h"
 
+static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
+				     struct ib_umem *umem, unsigned long addr,
+				     int dmasync)
+{
+	int ret;
+	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+
+	umem->ib_peer_mem = ib_peer_mem;
+	/*
+	 * We always request write permissions to the pages, to force breaking of any CoW
+	 * during the registration of the MR. For read-only MRs we use the "force" flag to
+	 * indicate that CoW breaking is required but the registration should not fail if
+	 * referencing read-only areas.
+	 */
+	ret = peer_mem->get_pages(addr, umem->length,
+				  1, !umem->writable,
+				  &umem->sg_head,
+				  umem->peer_mem_client_context,
+				  0);
+	if (ret)
+		goto out;
+
+	umem->page_size = peer_mem->get_page_size
+					(umem->peer_mem_client_context);
+	if (umem->page_size <= 0)
+		goto put_pages;
+
+	umem->offset = addr & ((unsigned long)umem->page_size - 1);
+	ret = peer_mem->dma_map(&umem->sg_head,
+				umem->peer_mem_client_context,
+				umem->context->device->dma_device,
+				dmasync,
+				&umem->nmap);
+	if (ret)
+		goto put_pages;
+
+	return umem;
+
+put_pages:
+	peer_mem->put_pages(umem->peer_mem_client_context,
+					&umem->sg_head);
+out:
+	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
+	kfree(umem);
+	return ERR_PTR(ret);
+}
+
+static void peer_umem_release(struct ib_umem *umem)
+{
+	const struct peer_memory_client *peer_mem =
+				umem->ib_peer_mem->peer_mem;
+
+	peer_mem->dma_unmap(&umem->sg_head,
+			    umem->peer_mem_client_context,
+			    umem->context->device->dma_device);
+	peer_mem->put_pages(&umem->sg_head,
+			    umem->peer_mem_client_context);
+	ib_put_peer_client(umem->ib_peer_mem, umem->peer_mem_client_context);
+	kfree(umem);
+}
 
 static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int dirty)
 {
@@ -74,9 +134,11 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
  * @dmasync: flush in-flight DMA when the memory region is written
+ * @peer_mem_flags: IB_PEER_MEM_xxx flags for memory being used
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync)
+			       size_t size, int access, int dmasync,
+			       unsigned long peer_mem_flags)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -114,6 +176,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	 * "MW bind" can change permissions by binding a window.
 	 */
 	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
+	if (peer_mem_flags & IB_PEER_MEM_ALLOW) {
+		struct ib_peer_memory_client *peer_mem_client;
+
+		peer_mem_client =  ib_get_peer_client(context, addr, size,
+						      &umem->peer_mem_client_context);
+		if (peer_mem_client)
+			return peer_umem_get(peer_mem_client, umem, addr,
+					dmasync);
+	}
 
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   = 1;
@@ -234,6 +305,10 @@ void ib_umem_release(struct ib_umem *umem)
 	struct mm_struct *mm;
 	struct task_struct *task;
 	unsigned long diff;
+	if (umem->ib_peer_mem) {
+		peer_umem_release(umem);
+		return;
+	}
 
 	__ib_umem_release(umem->context->device, umem, 1);
 
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 2d5cbf4..e88d222 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -444,7 +444,7 @@ static struct ib_mr *c2_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-ENOMEM);
 	c2mr->pd = c2pd;
 
-	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0, 0);
 	if (IS_ERR(c2mr->umem)) {
 		err = PTR_ERR(c2mr->umem);
 		kfree(c2mr);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 811b24a..aa9c142 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -635,7 +635,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mhp->rhp = rhp;
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0, 0);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree(mhp);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index ec7a298..506ddd2 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -705,7 +705,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mhp->rhp = rhp;
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0, 0);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree(mhp);
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 3488e8c..d5bbbc0 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -359,7 +359,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	e_mr->umem = ib_umem_get(pd->uobject->context, start, length,
-				 mr_access_flags, 0);
+				 mr_access_flags, 0, 0);
 	if (IS_ERR(e_mr->umem)) {
 		ib_mr = (void *)e_mr->umem;
 		goto reg_user_mr_exit1;
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index 5e61e9b..d6641be 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -198,7 +198,7 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	umem = ib_umem_get(pd->uobject->context, start, length,
-			   mr_access_flags, 0);
+			   mr_access_flags, 0, 0);
 	if (IS_ERR(umem))
 		return (void *) umem;
 
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 1066eec..23aaf77 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -142,7 +142,7 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *cont
 	int cqe_size = dev->dev->caps.cqe_size;
 
 	*umem = ib_umem_get(context, buf_addr, cqe * cqe_size,
-			    IB_ACCESS_LOCAL_WRITE, 1);
+			    IB_ACCESS_LOCAL_WRITE, 1, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
 
diff --git a/drivers/infiniband/hw/mlx4/doorbell.c b/drivers/infiniband/hw/mlx4/doorbell.c
index c517409..71e7b66 100644
--- a/drivers/infiniband/hw/mlx4/doorbell.c
+++ b/drivers/infiniband/hw/mlx4/doorbell.c
@@ -62,7 +62,7 @@ int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0, 0);
+				      PAGE_SIZE, 0, 0, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 8f9325c..ad4cdfd 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -147,7 +147,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	/* Force registering the memory as writable. */
 	/* Used for memory re-registeration. HCA protects the access */
 	mr->umem = ib_umem_get(pd->uobject->context, start, length,
-			       access_flags | IB_ACCESS_LOCAL_WRITE, 0);
+			       access_flags | IB_ACCESS_LOCAL_WRITE, 0,
+			       IB_PEER_MEM_ALLOW);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
@@ -226,12 +227,18 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 		int err;
 		int n;
 
+		/* Peer memory isn't supported */
+		if (mmr->umem->ib_peer_mem) {
+			err = -ENOTSUPP;
+			goto release_mpt_entry;
+		}
+
 		mlx4_mr_rereg_mem_cleanup(dev->dev, &mmr->mmr);
 		ib_umem_release(mmr->umem);
 		mmr->umem = ib_umem_get(mr->uobject->context, start, length,
 					mr_access_flags |
 					IB_ACCESS_LOCAL_WRITE,
-					0);
+					0, 0);
 		if (IS_ERR(mmr->umem)) {
 			err = PTR_ERR(mmr->umem);
 			/* Prevent mlx4_ib_dereg_mr from free'ing invalid pointer */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 577b477..15d6430 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -721,7 +721,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0, 0);
+				       qp->buf_size, 0, 0, IB_PEER_MEM_ALLOW);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 62d9285..e05c772 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -114,7 +114,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}
 
 		srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-					buf_size, 0, 0);
+					buf_size, 0, 0, IB_PEER_MEM_ALLOW);
 		if (IS_ERR(srq->umem)) {
 			err = PTR_ERR(srq->umem);
 			goto err_srq;
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index e405627..a968a54 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -628,7 +628,8 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	cq->buf.umem = ib_umem_get(context, ucmd.buf_addr,
 				   entries * ucmd.cqe_size,
-				   IB_ACCESS_LOCAL_WRITE, 1);
+				   IB_ACCESS_LOCAL_WRITE, 1,
+				   IB_PEER_MEM_ALLOW);
 	if (IS_ERR(cq->buf.umem)) {
 		err = PTR_ERR(cq->buf.umem);
 		return err;
@@ -958,7 +959,7 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 		return -EINVAL;
 
 	umem = ib_umem_get(context, ucmd.buf_addr, entries * ucmd.cqe_size,
-			   IB_ACCESS_LOCAL_WRITE, 1);
+			   IB_ACCESS_LOCAL_WRITE, 1, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(umem)) {
 		err = PTR_ERR(umem);
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index ece028f..5d7f427 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -64,7 +64,7 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context, unsigned long virt,
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0, 0);
+				      PAGE_SIZE, 0, 0, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 80b3c63..55c6649 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -884,7 +884,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx\n",
 		    start, virt_addr, length);
 	umem = ib_umem_get(pd->uobject->context, start, length, access_flags,
-			   0);
+			   0, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(umem)) {
 		mlx5_ib_dbg(dev, "umem get failed\n");
 		return (void *)umem;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8c574b6..d6856c6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -584,7 +584,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	if (ucmd.buf_addr && qp->buf_size) {
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0, 0);
+				       qp->buf_size, 0, 0, IB_PEER_MEM_ALLOW);
 		if (IS_ERR(qp->umem)) {
 			mlx5_ib_dbg(dev, "umem_get failed\n");
 			err = PTR_ERR(qp->umem);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 70bd131..4bca523 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -103,7 +103,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
 	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
-				0, 0);
+				0, 0, IB_PEER_MEM_ALLOW);
 	if (IS_ERR(srq->umem)) {
 		mlx5_ib_dbg(dev, "failed umem get, size %d\n", buf_size);
 		err = PTR_ERR(srq->umem);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1..599ee1f 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1002,7 +1002,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-ENOMEM);
 
 	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc,
-			       ucmd.mr_attrs & MTHCA_MR_DMASYNC);
+			       ucmd.mr_attrs & MTHCA_MR_DMASYNC, 0);
 
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fef067c..5b70588 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2333,7 +2333,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	u8 stag_key;
 	int first_page = 1;
 
-	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	region = ib_umem_get(pd->uobject->context, start, length, acc, 0, 0);
 	if (IS_ERR(region)) {
 		return (struct ib_mr *)region;
 	}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8f5f257..a90c88b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -794,7 +794,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(status);
-	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc, 0);
+	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc, 0, 0);
 	if (IS_ERR(mr->umem)) {
 		status = -EFAULT;
 		goto umem_err;
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 9bbb553..aadce11 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -242,7 +242,7 @@ struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	umem = ib_umem_get(pd->uobject->context, start, length,
-			   mr_access_flags, 0);
+			   mr_access_flags, 0, 0);
 	if (IS_ERR(umem))
 		return (void *) umem;
 
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 3353ae7..98056c5 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -13,6 +13,10 @@ struct ib_peer_memory_client {
 	struct completion unload_comp;
 };
 
+enum ib_peer_mem_flags {
+	IB_PEER_MEM_ALLOW	= 1,
+};
+
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
 						 size_t size, void **peer_client_context);
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index a2bf41e..a22dde0 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -36,6 +36,7 @@
 #include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
+#include <rdma/ib_peer_mem.h>
 
 struct ib_ucontext;
 
@@ -53,12 +54,17 @@ struct ib_umem {
 	struct sg_table sg_head;
 	int             nmap;
 	int             npages;
+	/* peer memory that manages this umem */
+	struct ib_peer_memory_client *ib_peer_mem;
+	/* peer memory private context */
+	void *peer_mem_client_context;
 };
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync);
+			       size_t size, int access, int dmasync,
+			       unsigned long peer_mem_flags);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -67,8 +73,9 @@ int ib_umem_page_count(struct ib_umem *umem);
 #include <linux/err.h>
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
-					  unsigned long addr, size_t size,
-					  int access, int dmasync) {
+					     unsigned long addr, size_t size,
+					     int access, int dmasync,
+					     unsigned long peer_mem_flags) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
