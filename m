From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 6/6] RDMA: Remove rdma_user_mmap_page
Date: Tue, 16 Apr 2019 14:07:30 +0300
Message-ID: <20190416110730.32230-7-leon@kernel.org>
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

Upon further research drivers that want this should simply call the core
function vm_insert_page(). The VMA holds a reference on the page and it
will be automatically freed when the last reference drops. No need for
disassociate to sequence the cleanup.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c | 64 +++++----------------------
 drivers/infiniband/hw/mlx5/main.c     | 12 ++---
 include/rdma/ib_verbs.h               |  9 ----
 3 files changed, 18 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 4a7cf5fddaee..d252825930f6 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -926,46 +926,35 @@ static const struct vm_operations_struct rdma_umap_ops = {
 	.fault = rdma_umap_fault,
 };
 
-static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *ucontext,
-						 struct vm_area_struct *vma,
-						 unsigned long size)
+/*
+ * Map IO memory into a process. This is to be called by drivers as part of
+ * their mmap() functions if they wish to send something like PCI-E BAR memory
+ * to userspace.
+ */
+int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
+		      unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	struct ib_uverbs_file *ufile = ucontext->ufile;
 	struct rdma_umap_priv *priv;
 
 	if (!(vma->vm_flags & VM_SHARED))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	if (vma->vm_flags & VM_EXEC)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	vma->vm_flags &= ~VM_MAYEXEC;
 
 	if (vma->vm_end - vma->vm_start != size)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/* Driver is using this wrong, must be called by ib_uverbs_mmap */
 	if (WARN_ON(!vma->vm_file ||
 		    vma->vm_file->private_data != ufile))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	lockdep_assert_held(&ufile->device->disassociate_srcu);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return ERR_PTR(-ENOMEM);
-	return priv;
-}
-
-/*
- * Map IO memory into a process. This is to be called by drivers as part of
- * their mmap() functions if they wish to send something like PCI-E BAR memory
- * to userspace.
- */
-int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
-		      unsigned long pfn, unsigned long size, pgprot_t prot)
-{
-	struct rdma_umap_priv *priv = rdma_user_mmap_pre(ucontext, vma, size);
-
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
+		return -ENOMEM;
 
 	vma->vm_page_prot = prot;
 	if (io_remap_pfn_range(vma, vma->vm_start, pfn, size, prot)) {
@@ -978,35 +967,6 @@ int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL(rdma_user_mmap_io);
 
-/*
- * The page case is here for a slightly different reason, the driver expects
- * to be able to free the page it is sharing to user space when it destroys
- * its ucontext, which means we need to zap the user space references.
- *
- * We could handle this differently by providing an API to allocate a shared
- * page and then only freeing the shared page when the last ufile is
- * destroyed.
- */
-int rdma_user_mmap_page(struct ib_ucontext *ucontext,
-			struct vm_area_struct *vma, struct page *page,
-			unsigned long size)
-{
-	struct rdma_umap_priv *priv = rdma_user_mmap_pre(ucontext, vma, size);
-
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
-
-	if (remap_pfn_range(vma, vma->vm_start, page_to_pfn(page), size,
-			    vma->vm_page_prot)) {
-		kfree(priv);
-		return -EAGAIN;
-	}
-
-	rdma_umap_priv_init(priv, vma);
-	return 0;
-}
-EXPORT_SYMBOL(rdma_user_mmap_page);
-
 void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 {
 	struct rdma_umap_priv *priv, *next_priv;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9a718258b8eb..692759914d20 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2064,22 +2064,22 @@ static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
 					struct vm_area_struct *vma,
 					struct mlx5_ib_ucontext *context)
 {
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+	if ((vma->vm_end - vma->vm_start != PAGE_SIZE) ||
+	    !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
 	if (get_index(vma->vm_pgoff) != MLX5_IB_CLOCK_INFO_V1)
 		return -EOPNOTSUPP;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
 		return -EPERM;
-	vma->vm_flags &= ~VM_MAYWRITE;
+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 
 	if (!dev->mdev->clock_info)
 		return -EOPNOTSUPP;
 
-	return rdma_user_mmap_page(&context->ibucontext, vma,
-				   virt_to_page(dev->mdev->clock_info),
-				   PAGE_SIZE);
+	return vm_insert_page(vma, vma->vm_start,
+			      virt_to_page(dev->mdev->clock_info));
 }
 
 static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cc311f14f41a..8014dec3bd07 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2754,9 +2754,6 @@ void ib_set_device_ops(struct ib_device *device,
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
 		      unsigned long pfn, unsigned long size, pgprot_t prot);
-int rdma_user_mmap_page(struct ib_ucontext *ucontext,
-			struct vm_area_struct *vma, struct page *page,
-			unsigned long size);
 #else
 static inline int rdma_user_mmap_io(struct ib_ucontext *ucontext,
 				    struct vm_area_struct *vma,
@@ -2765,12 +2762,6 @@ static inline int rdma_user_mmap_io(struct ib_ucontext *ucontext,
 {
 	return -EINVAL;
 }
-static inline int rdma_user_mmap_page(struct ib_ucontext *ucontext,
-				struct vm_area_struct *vma, struct page *page,
-				unsigned long size)
-{
-	return -EINVAL;
-}
 #endif
 
 static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t len)
-- 
2.20.1
