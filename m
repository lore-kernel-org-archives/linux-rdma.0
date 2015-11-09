From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/4] IB/mlx5: Mmap the HCA's core clock register to user-space
Date: Mon,  9 Nov 2015 18:30:57 +0200
Message-ID: <1447086657-15358-5-git-send-email-matanb@mellanox.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086657-15358-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to read the HCA's current cycles register, we need
to map it to user-space. Add support to map this register
via mmap command.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 24 ++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b8be3ad..23cedb4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -825,6 +825,30 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 	case MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES:
 		return -ENOSYS;
 
+	case MLX5_IB_MMAP_CORE_CLOCK:
+	{
+		phys_addr_t pfn;
+
+		if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+			return -EINVAL;
+
+		if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+			return -EINVAL;
+
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		pfn = (dev->mdev->iseg_base +
+		       offsetof(struct mlx5_init_seg, internal_timer_h)) >>
+			PAGE_SHIFT;
+		if (io_remap_pfn_range(vma, vma->vm_start, pfn,
+				       PAGE_SIZE, vma->vm_page_prot))
+			return -EAGAIN;
+
+		mlx5_ib_dbg(dev, "mapped internal timer at 0x%lx, PA 0x%llx\n",
+			    vma->vm_start,
+			    (unsigned long long)pfn << PAGE_SHIFT);
+		break;
+	}
+
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c33cf8f..87cd616 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -65,7 +65,9 @@ enum {
 
 enum mlx5_ib_mmap_cmd {
 	MLX5_IB_MMAP_REGULAR_PAGE		= 0,
-	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1, /* always last */
+	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1,
+	/* 5 is chosen in order to be compatible with old versions of libmlx5 */
+	MLX5_IB_MMAP_CORE_CLOCK			= 5,
 };
 
 enum {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
