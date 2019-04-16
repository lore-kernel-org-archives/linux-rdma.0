From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/6] RDMA/ucontext: Fix regression with disassociate
Date: Tue, 16 Apr 2019 14:07:28 +0300
Message-ID: <20190416110730.32230-5-leon@kernel.org>
References: <20190416110730.32230-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190416110730.32230-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

When this code was consolidated the intention was that the VMA would
become backed by anonymous zero pages after the zap_vma_pte - however this
very subtly relied on setting the vm_ops = NULL and clearing the VM_SHARED
bits to transform the VMA into an anonymous VMA. Since the vm_ops was
removed this broke.

Now userspace gets a SIGBUS if it touches the vma after disassociation.

Instead of converting the VMA to anonymous provide a fault handler that
puts a zero'd page into the VMA when user-space touches it after
disassociation.

Cc: stable@vger.kernel.org
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 51 +++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 0fc71ad42490..d2c29868172c 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -160,6 +160,7 @@ struct ib_uverbs_file {
 
 	struct mutex umap_lock;
 	struct list_head umaps;
+	struct page *disassociate_page;
 
 	struct idr		idr;
 	/* spinlock protects write access to idr */
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3ef6474cd201..4a7cf5fddaee 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -208,6 +208,9 @@ void ib_uverbs_release_file(struct kref *ref)
 		kref_put(&file->async_file->ref,
 			 ib_uverbs_release_async_event_file);
 	put_device(&file->device->dev);
+
+	if (file->disassociate_page)
+		__free_pages(file->disassociate_page, 0);
 	kfree(file);
 }
 
@@ -877,9 +880,50 @@ static void rdma_umap_close(struct vm_area_struct *vma)
 	kfree(priv);
 }
 
+/*
+ * Once the zap_vma_ptes has been called touches to the VMA will come here and
+ * we return a dummy writable zero page for all the pfns.
+ */
+static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
+{
+	struct ib_uverbs_file *ufile = vmf->vma->vm_file->private_data;
+	struct rdma_umap_priv *priv = vmf->vma->vm_private_data;
+	vm_fault_t ret = 0;
+
+	if (!priv)
+		return VM_FAULT_SIGBUS;
+
+	/* Read only pages can just use the system zero page. */
+	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
+		vmf->page = ZERO_PAGE(vmf->vm_start);
+		get_page(vmf->page);
+		return 0;
+	}
+
+	mutex_lock(&ufile->umap_lock);
+	if (!ufile->disassociate_page)
+		ufile->disassociate_page =
+			alloc_pages(vmf->gfp_mask | __GFP_ZERO, 0);
+
+	if (ufile->disassociate_page) {
+		/*
+		 * This VMA is forced to always be shared so this doesn't have
+		 * to worry about COW.
+		 */
+		vmf->page = ufile->disassociate_page;
+		get_page(vmf->page);
+	} else {
+		ret = VM_FAULT_SIGBUS;
+	}
+	mutex_unlock(&ufile->umap_lock);
+
+	return ret;
+}
+
 static const struct vm_operations_struct rdma_umap_ops = {
 	.open = rdma_umap_open,
 	.close = rdma_umap_close,
+	.fault = rdma_umap_fault,
 };
 
 static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *ucontext,
@@ -889,6 +933,8 @@ static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *ucontext,
 	struct ib_uverbs_file *ufile = ucontext->ufile;
 	struct rdma_umap_priv *priv;
 
+	if (!(vma->vm_flags & VM_SHARED))
+		return ERR_PTR(-EINVAL);
 	if (vma->vm_flags & VM_EXEC)
 		return ERR_PTR(-EINVAL);
 	vma->vm_flags &= ~VM_MAYEXEC;
@@ -996,7 +1042,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 		 * at a time to get the lock ordering right. Typically there
 		 * will only be one mm, so no big deal.
 		 */
-		down_write(&mm->mmap_sem);
+		down_read(&mm->mmap_sem);
 		mutex_lock(&ufile->umap_lock);
 		list_for_each_entry_safe (priv, next_priv, &ufile->umaps,
 					  list) {
@@ -1008,10 +1054,9 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 
 			zap_vma_ptes(vma, vma->vm_start,
 				     vma->vm_end - vma->vm_start);
-			vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
 		}
 		mutex_unlock(&ufile->umap_lock);
-		up_write(&mm->mmap_sem);
+		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
 }
-- 
2.20.1
