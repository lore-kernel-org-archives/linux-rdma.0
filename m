From: Joel Nider <joeln@il.ibm.com>
Subject: [PATCH 4/5] RDMA/uverbs: add owner parameter to ib_umem_odp_get
Date: Tue, 29 Jan 2019 15:26:25 +0200
Message-ID: <1548768386-28289-5-git-send-email-joeln@il.ibm.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Joel Nider <joeln@il.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Propagate the change of adding the owner parameter to several internal
core functions, as well as the ib_umem_odp_get() kernel interface
function. The mm of the address space that owns the memory region is
saved in the per_mm struct, which is then used by
ib_umem_odp_map_dma_pages() when resolving a page fault from ODP.

Signed-off-by: Joel Nider <joeln@il.ibm.com>
---
 drivers/infiniband/core/umem.c     |  4 +--
 drivers/infiniband/core/umem_odp.c | 50 ++++++++++++++++++--------------------
 drivers/infiniband/hw/mlx5/odp.c   |  6 ++++-
 include/rdma/ib_umem_odp.h         |  6 +++--
 4 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 9646cee..77874e5 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -142,7 +142,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	mmgrab(mm);
 
 	if (access & IB_ACCESS_ON_DEMAND) {
-		ret = ib_umem_odp_get(to_ib_umem_odp(umem), access);
+		ret = ib_umem_odp_get(to_ib_umem_odp(umem), access, owner);
 		if (ret)
 			goto umem_kfree;
 		return umem;
@@ -200,7 +200,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 				     mm, cur_base,
 				     min_t(unsigned long, npages,
 				     PAGE_SIZE / sizeof(struct page *)),
-				     gup_flags, page_list, vma_list, NULL);
+				     gup_flags, page_list, vma_list);
 		if (ret < 0) {
 			up_read(&mm->mmap_sem);
 			goto umem_release;
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index a4ec430..49826070 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -227,7 +227,8 @@ static void remove_umem_from_per_mm(struct ib_umem_odp *umem_odp)
 }
 
 static struct ib_ucontext_per_mm *alloc_per_mm(struct ib_ucontext *ctx,
-					       struct mm_struct *mm)
+					       struct mm_struct *mm,
+					       struct pid *owner)
 {
 	struct ib_ucontext_per_mm *per_mm;
 	int ret;
@@ -241,12 +242,8 @@ static struct ib_ucontext_per_mm *alloc_per_mm(struct ib_ucontext *ctx,
 	per_mm->umem_tree = RB_ROOT_CACHED;
 	init_rwsem(&per_mm->umem_rwsem);
 	per_mm->active = ctx->invalidate_range;
-
-	rcu_read_lock();
-	per_mm->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
-	rcu_read_unlock();
-
-	WARN_ON(mm != current->mm);
+	per_mm->tgid = owner;
+	mmgrab(per_mm->mm);
 
 	per_mm->mn.ops = &ib_umem_notifiers;
 	ret = mmu_notifier_register(&per_mm->mn, per_mm->mm);
@@ -265,7 +262,7 @@ static struct ib_ucontext_per_mm *alloc_per_mm(struct ib_ucontext *ctx,
 	return ERR_PTR(ret);
 }
 
-static int get_per_mm(struct ib_umem_odp *umem_odp)
+static int get_per_mm(struct ib_umem_odp *umem_odp, struct pid *owner)
 {
 	struct ib_ucontext *ctx = umem_odp->umem.context;
 	struct ib_ucontext_per_mm *per_mm;
@@ -280,7 +277,7 @@ static int get_per_mm(struct ib_umem_odp *umem_odp)
 			goto found;
 	}
 
-	per_mm = alloc_per_mm(ctx, umem_odp->umem.owning_mm);
+	per_mm = alloc_per_mm(ctx, umem_odp->umem.owning_mm, owner);
 	if (IS_ERR(per_mm)) {
 		mutex_unlock(&ctx->per_mm_list_lock);
 		return PTR_ERR(per_mm);
@@ -333,7 +330,8 @@ void put_per_mm(struct ib_umem_odp *umem_odp)
 }
 
 struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
-				      unsigned long addr, size_t size)
+				      unsigned long addr, size_t size,
+				      struct mm_struct *owner_mm)
 {
 	struct ib_ucontext *ctx = per_mm->context;
 	struct ib_umem_odp *odp_data;
@@ -345,12 +343,14 @@ struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
 	if (!odp_data)
 		return ERR_PTR(-ENOMEM);
 	umem = &odp_data->umem;
+
 	umem->context    = ctx;
 	umem->length     = size;
 	umem->address    = addr;
 	umem->page_shift = PAGE_SHIFT;
 	umem->writable   = 1;
 	umem->is_odp = 1;
+	umem->owning_mm = owner_mm;
 	odp_data->per_mm = per_mm;
 
 	mutex_init(&odp_data->umem_mutex);
@@ -389,13 +389,9 @@ struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
 }
 EXPORT_SYMBOL(ib_alloc_odp_umem);
 
-int ib_umem_odp_get(struct ib_umem_odp *umem_odp, int access)
+int ib_umem_odp_get(struct ib_umem_odp *umem_odp, int access, struct pid *owner)
 {
 	struct ib_umem *umem = &umem_odp->umem;
-	/*
-	 * NOTE: This must called in a process context where umem->owning_mm
-	 * == current->mm
-	 */
 	struct mm_struct *mm = umem->owning_mm;
 	int ret_val;
 
@@ -437,7 +433,7 @@ int ib_umem_odp_get(struct ib_umem_odp *umem_odp, int access)
 		}
 	}
 
-	ret_val = get_per_mm(umem_odp);
+	ret_val = get_per_mm(umem_odp, owner);
 	if (ret_val)
 		goto out_dma_list;
 	add_umem_to_per_mm(umem_odp);
@@ -574,8 +570,8 @@ static int ib_umem_odp_map_dma_single_page(
  *        the return value.
  * @access_mask: bit mask of the requested access permissions for the given
  *               range.
- * @current_seq: the MMU notifiers sequance value for synchronization with
- *               invalidations. the sequance number is read from
+ * @current_seq: the MMU notifiers sequence value for synchronization with
+ *               invalidations. the sequence number is read from
  *               umem_odp->notifiers_seq before calling this function
  */
 int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
@@ -584,7 +580,7 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 {
 	struct ib_umem *umem = &umem_odp->umem;
 	struct task_struct *owning_process  = NULL;
-	struct mm_struct *owning_mm = umem_odp->umem.owning_mm;
+	struct mm_struct *owning_mm;
 	struct page       **local_page_list = NULL;
 	u64 page_mask, off;
 	int j, k, ret = 0, start_idx, npages = 0, page_shift;
@@ -609,12 +605,13 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 	bcnt += off; /* Charge for the first page offset as well. */
 
 	/*
-	 * owning_process is allowed to be NULL, this means somehow the mm is
-	 * existing beyond the lifetime of the originating process.. Presumably
+	 * owning_process may be NULL, because the mm can
+	 * exist independently of the originating process.
 	 * mmget_not_zero will fail in this case.
 	 */
 	owning_process = get_pid_task(umem_odp->per_mm->tgid, PIDTYPE_PID);
-	if (WARN_ON(!mmget_not_zero(umem_odp->umem.owning_mm))) {
+	owning_mm = umem_odp->per_mm->mm;
+	if (WARN_ON(!mmget_not_zero(owning_mm))) {
 		ret = -EINVAL;
 		goto out_put_task;
 	}
@@ -632,15 +629,16 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 
 		down_read(&owning_mm->mmap_sem);
 		/*
-		 * Note: this might result in redundent page getting. We can
+		 * Note: this might result in redundant page getting. We can
 		 * avoid this by checking dma_list to be 0 before calling
-		 * get_user_pages. However, this make the code much more
+		 * get_user_pages. However, this makes the code much more
 		 * complex (and doesn't gain us much performance in most use
 		 * cases).
 		 */
-		npages = get_user_pages_remote(owning_process, owning_mm,
+		npages = get_user_pages_remote_longterm(owning_process,
+				owning_mm,
 				user_virt, gup_num_pages,
-				flags, local_page_list, NULL, NULL);
+				flags, local_page_list, NULL);
 		up_read(&owning_mm->mmap_sem);
 
 		if (npages < 0) {
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index c317e18..1abc917 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -439,8 +439,12 @@ static struct ib_umem_odp *implicit_mr_get_data(struct mlx5_ib_mr *mr,
 		if (nentries)
 			nentries++;
 	} else {
+		struct mm_struct *owner_mm = current->mm;
+
+		if (mr->umem->owning_mm)
+			owner_mm = mr->umem->owning_mm;
 		odp = ib_alloc_odp_umem(odp_mr->per_mm, addr,
-					MLX5_IMR_MTT_SIZE);
+					MLX5_IMR_MTT_SIZE, owner_mm);
 		if (IS_ERR(odp)) {
 			mutex_unlock(&odp_mr->umem_mutex);
 			return ERR_CAST(odp);
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 0b1446f..28099e6 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -102,9 +102,11 @@ struct ib_ucontext_per_mm {
 	struct rcu_head rcu;
 };
 
-int ib_umem_odp_get(struct ib_umem_odp *umem_odp, int access);
+int ib_umem_odp_get(struct ib_umem_odp *umem_odp, int access,
+		     struct pid *owner);
 struct ib_umem_odp *ib_alloc_odp_umem(struct ib_ucontext_per_mm *per_mm,
-				      unsigned long addr, size_t size);
+				      unsigned long addr, size_t size,
+				      struct mm_struct *owner_mm);
 void ib_umem_odp_release(struct ib_umem_odp *umem_odp);
 
 /*
-- 
2.7.4
