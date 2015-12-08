From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC contig pages support 2/2] IB/mlx5: Exporting to user space the contiguous allocation capability
Date: Tue,  8 Dec 2015 17:15:07 +0200
Message-ID: <1449587707-24214-3-git-send-email-yishaih@mellanox.com>
References: <1449587707-24214-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449587707-24214-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend mlx5_ib_mmap to recognize 'allocate contiguous' command.
Offset field will be encoded to hold both command and its data.
Last 8 bits will hold the command, this will enable future
extension for further commands.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 35 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +++-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7e97cb5..46de426 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -43,6 +43,7 @@
 #include <linux/mlx5/vport.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_cmem.h>
 #include "user.h"
 #include "mlx5_ib.h"
 
@@ -751,6 +752,11 @@ static int get_index(unsigned long offset)
 	return get_arg(offset);
 }
 
+static int get_pg_order(unsigned long offset)
+{
+	return get_arg(offset);
+}
+
 static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
 {
 	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
@@ -759,6 +765,11 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 	unsigned long command;
 	unsigned long idx;
 	phys_addr_t pfn;
+	unsigned long total_size;
+	unsigned long order;
+	struct ib_cmem *ib_cmem;
+	int err;
+	int local_numa_node;
 
 	command = get_command(vma->vm_pgoff);
 	switch (command) {
@@ -784,8 +795,30 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 			    (unsigned long long)pfn << PAGE_SHIFT);
 		break;
 
+	case MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_CPU_NUMA:
+	case MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_DEV_NUMA:
 	case MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES:
-		return -ENOSYS;
+		if (command == MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_CPU_NUMA)
+			local_numa_node = numa_node_id();
+		else if (command == MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_DEV_NUMA)
+			local_numa_node = dev_to_node(&dev->mdev->pdev->dev);
+		else
+			local_numa_node = -1;
+
+		total_size = vma->vm_end - vma->vm_start;
+		order = get_pg_order(vma->vm_pgoff);
+
+		ib_cmem = ib_cmem_alloc_contiguous_pages(ibcontext, total_size,
+							 order, local_numa_node);
+		if (IS_ERR(ib_cmem))
+			return PTR_ERR(ib_cmem);
+
+		err = ib_cmem_map_contiguous_pages_to_vma(ib_cmem, vma);
+		if (err) {
+			ib_cmem_release_contiguous_pages(ib_cmem);
+			return err;
+		}
+		break;
 
 	default:
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6333472..1e2c57e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -62,7 +62,9 @@ enum {
 
 enum mlx5_ib_mmap_cmd {
 	MLX5_IB_MMAP_REGULAR_PAGE		= 0,
-	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1, /* always last */
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1,
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_CPU_NUMA  = 0xFC,
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES_DEV_NUMA  = 0xFD,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
