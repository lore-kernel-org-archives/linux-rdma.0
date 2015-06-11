From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V4 4/5] IB/mlx4_ib: Disassociate support
Date: Thu, 11 Jun 2015 15:56:53 +0300
Message-ID: <1434027414-711-5-git-send-email-yishaih@mellanox.com>
References: <1434027414-711-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434027414-711-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implements the IB core disassociate_ucontext API. The driver detaches the HW
resources for a given user context to prevent a dependency between application
termination and device disconnecting. This is done by managing the VMAs that
were mapped to the HW bars such as door bell and blueflame. When need to detach
remap them to an arbitrary kernel page returned by the zap API.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  125 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   12 +++
 2 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 86c0c27..1edbbf0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -653,7 +653,7 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		resp.cqe_size	      = dev->dev->caps.cqe_size;
 	}
 
-	context = kmalloc(sizeof *context, GFP_KERNEL);
+	context = kzalloc(sizeof *context, GFP_KERNEL);
 	if (!context)
 		return ERR_PTR(-ENOMEM);
 
@@ -690,21 +690,140 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	return 0;
 }
 
+static void  mlx4_ib_vma_open(struct vm_area_struct *area)
+{
+	/* vma_open is called when a new VMA is created on top of our VMA.
+	 * This is done through either mremap flow or split_vma (usually due
+	 * to mlock, madvise, munmap, etc.). We do not support a clone of the
+	 * vma, as this VMA is strongly hardware related. Therefore we set the
+	 * vm_ops of the newly created/cloned VMA to NULL, to prevent it from
+	 * calling us again and trying to do incorrect actions. We assume that
+	 * the original vma size is exactly a single page that there will be no
+	 * "splitting" operations on.
+	 */
+	area->vm_ops = NULL;
+}
+
+static void  mlx4_ib_vma_close(struct vm_area_struct *area)
+{
+	struct mlx4_ib_vma_private_data *mlx4_ib_vma_priv_data;
+
+	/* It's guaranteed that all VMAs opened on a FD are closed before the
+	 * file itself is closed, therefore no sync is needed with the regular
+	 * closing flow. (e.g. mlx4_ib_dealloc_ucontext) However need a sync
+	 * with accessing the vma as part of mlx4_ib_disassociate_ucontext.
+	 * The close operation is usually called under mm->mmap_sem except when
+	 * process is exiting.  The exiting case is handled explicitly as part
+	 * of mlx4_ib_disassociate_ucontext.
+	 */
+	mlx4_ib_vma_priv_data = (struct mlx4_ib_vma_private_data *)area->vm_private_data;
+
+	/* set the vma context pointer to null in the mlx4_ib driver's private
+	 * data to protect against a race condition in mlx4_ib_dissassociate_ucontext().
+	 */
+	mlx4_ib_vma_priv_data->vma = NULL;
+}
+
+static const struct vm_operations_struct mlx4_ib_vm_ops = {
+	.open = mlx4_ib_vma_open,
+	.close = mlx4_ib_vma_close
+};
+
+static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
+{
+	int i;
+	int ret = 0;
+	struct vm_area_struct *vma;
+	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);
+	struct task_struct *owning_process  = NULL;
+	struct mm_struct   *owning_mm       = NULL;
+
+	owning_process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
+	if (!owning_process)
+		return;
+
+	owning_mm = get_task_mm(owning_process);
+	if (!owning_mm) {
+		pr_info("no mm, disassociate ucontext is pending task termination\n");
+		while (1) {
+			/* make sure that task is dead before returning, it may
+			 * prevent a rare case of module down in parallel to a
+			 * call to mlx4_ib_vma_close.
+			 */
+			put_task_struct(owning_process);
+			msleep(1);
+			owning_process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
+			if (!owning_process || owning_process->state == TASK_DEAD) {
+				pr_info("disassociate ucontext done, task was terminated\n");
+				/* in case task was dead need to release the task struct */
+				if (owning_process)
+					put_task_struct(owning_process);
+				return;
+			}
+		}
+	}
+
+	/* need to protect from a race on closing the vma as part of
+	 * mlx4_ib_vma_close().
+	 */
+	down_read(&owning_mm->mmap_sem);
+	for (i = 0; i < HW_BAR_COUNT; i++) {
+		vma = context->hw_bar_info[i].vma;
+		if (!vma)
+			continue;
+
+		ret = zap_vma_ptes(context->hw_bar_info[i].vma,
+				   context->hw_bar_info[i].vma->vm_start,
+				   PAGE_SIZE);
+		if (ret) {
+			pr_err("Error: zap_vma_ptes failed for index=%d, ret=%d\n", i, ret);
+			BUG_ON(1);
+		}
+
+		/* context going to be destroyed, should not access ops any more */
+		context->hw_bar_info[i].vma->vm_ops = NULL;
+	}
+
+	up_read(&owning_mm->mmap_sem);
+	mmput(owning_mm);
+	put_task_struct(owning_process);
+}
+
+static void mlx4_ib_set_vma_data(struct vm_area_struct *vma,
+				 struct mlx4_ib_vma_private_data *vma_private_data)
+{
+	vma_private_data->vma = vma;
+	vma->vm_private_data = vma_private_data;
+	vma->vm_ops =  &mlx4_ib_vm_ops;
+}
+
 static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
 	struct mlx4_ib_dev *dev = to_mdev(context->device);
+	struct mlx4_ib_ucontext *mucontext = to_mucontext(context);
 
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
 	if (vma->vm_pgoff == 0) {
+		/* We prevent double mmaping on same context */
+		if (mucontext->hw_bar_info[HW_BAR_DB].vma != NULL)
+			return -EINVAL;
+
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       to_mucontext(context)->uar.pfn,
 				       PAGE_SIZE, vma->vm_page_prot))
 			return -EAGAIN;
+
+		mlx4_ib_set_vma_data(vma, &mucontext->hw_bar_info[HW_BAR_DB]);
+
 	} else if (vma->vm_pgoff == 1 && dev->dev->caps.bf_reg_size != 0) {
+		/* We prevent double mmaping on same context */
+		if (mucontext->hw_bar_info[HW_BAR_BF].vma != NULL)
+			return -EINVAL;
+
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 		if (io_remap_pfn_range(vma, vma->vm_start,
@@ -712,6 +831,9 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 				       dev->dev->caps.num_uars,
 				       PAGE_SIZE, vma->vm_page_prot))
 			return -EAGAIN;
+
+		mlx4_ib_set_vma_data(vma, &mucontext->hw_bar_info[HW_BAR_BF]);
+
 	} else
 		return -EINVAL;
 
@@ -2264,6 +2386,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
 	ibdev->ib_dev.get_port_immutable = mlx4_port_immutable;
+	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 645d55e..7cc2f4f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -70,11 +70,23 @@ extern int mlx4_ib_sm_guid_assign;
 
 #define MLX4_IB_UC_STEER_QPN_ALIGN 1
 #define MLX4_IB_UC_MAX_NUM_QPS     256
+
+enum hw_bar_type {
+	HW_BAR_BF,
+	HW_BAR_DB,
+	HW_BAR_COUNT
+};
+
+struct mlx4_ib_vma_private_data {
+	struct vm_area_struct *vma;
+};
+
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
 	struct list_head	db_page_list;
 	struct mutex		db_page_mutex;
+	struct mlx4_ib_vma_private_data hw_bar_info[HW_BAR_COUNT];
 };
 
 struct mlx4_ib_pd {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
