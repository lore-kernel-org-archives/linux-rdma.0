From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] IB/mlx5: Delete locally redefined variable
Date: Tue, 19 Jan 2016 11:11:24 +0200
Message-ID: <1453194684-1549-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix the following sparse warning:
drivers/infiniband/hw/mlx5/main.c:1061:29: warning: symbol 'pfn' shadows
an earlier one
drivers/infiniband/hw/mlx5/main.c:1030:21: originally declared here

Fixes: d69e3bcf7976 ('IB/mlx5: Mmap the HCA's core clock register to user-space')
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5e3d3aea35bc..5e997c0793d1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1057,9 +1057,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 		return -ENOSYS;
 
 	case MLX5_IB_MMAP_CORE_CLOCK:
-	{
-		phys_addr_t pfn;
-
 		if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 			return -EINVAL;
 
@@ -1082,7 +1079,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 			    vma->vm_start,
 			    (unsigned long long)pfn << PAGE_SHIFT);
 		break;
-	}
 
 	default:
 		return -EINVAL;
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
