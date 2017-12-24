From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/4] IB/mlx5: Serialize access to the VMA list
Date: Sun, 24 Dec 2017 13:54:56 +0200
Message-ID: <20171224115458.27577-3-leon@kernel.org>
References: <20171224115458.27577-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224115458.27577-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

User-space applications can do mmap and munmap directly.

Since the VMA list is not protected with a mutex, concurrent
accesses to the VMA list from the mmap and munmap can cause
data corruption.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7
Fixes: 7c2344c3bbf9 ("IB/mlx5: Implements disassociate_ucontext API")
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 8 ++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b4ef4d9b6ce5..8ac50de2b242 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1463,6 +1463,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	}
 
 	INIT_LIST_HEAD(&context->vma_private_list);
+	mutex_init(&context->vma_private_list_mutex);
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
@@ -1624,7 +1625,9 @@ static void  mlx5_ib_vma_close(struct vm_area_struct *area)
 	 * mlx5_ib_disassociate_ucontext().
 	 */
 	mlx5_ib_vma_priv_data->vma = NULL;
+	mutex_lock(mlx5_ib_vma_priv_data->vma_private_list_mutex);
 	list_del(&mlx5_ib_vma_priv_data->list);
+	mutex_unlock(mlx5_ib_vma_priv_data->vma_private_list_mutex);
 	kfree(mlx5_ib_vma_priv_data);
 }
 
@@ -1644,10 +1647,13 @@ static int mlx5_ib_set_vma_data(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	vma_prv->vma = vma;
+	vma_prv->vma_private_list_mutex = &ctx->vma_private_list_mutex;
 	vma->vm_private_data = vma_prv;
 	vma->vm_ops =  &mlx5_ib_vm_ops;
 
+	mutex_lock(&ctx->vma_private_list_mutex);
 	list_add(&vma_prv->list, vma_head);
+	mutex_unlock(&ctx->vma_private_list_mutex);
 
 	return 0;
 }
@@ -1690,6 +1696,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx5_ib_vma_close.
 	 */
 	down_write(&owning_mm->mmap_sem);
+	mutex_lock(&context->vma_private_list_mutex);
 	list_for_each_entry_safe(vma_private, n, &context->vma_private_list,
 				 list) {
 		vma = vma_private->vma;
@@ -1704,6 +1711,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		list_del(&vma_private->list);
 		kfree(vma_private);
 	}
+	mutex_unlock(&context->vma_private_list_mutex);
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6dd8cac78de2..dcf30e18409e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -115,6 +115,9 @@ enum {
 struct mlx5_ib_vma_private_data {
 	struct list_head list;
 	struct vm_area_struct *vma;
+	/* protect vma_private_list add/del
+	 */
+	struct mutex *vma_private_list_mutex;
 };
 
 struct mlx5_ib_ucontext {
@@ -129,6 +132,9 @@ struct mlx5_ib_ucontext {
 	/* Transport Domain number */
 	u32			tdn;
 	struct list_head	vma_private_list;
+	/* protect vma_private_list add/del
+	 */
+	struct mutex		vma_private_list_mutex;
 
 	unsigned long		upd_xlt_page;
 	/* protect ODP/KSM */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
