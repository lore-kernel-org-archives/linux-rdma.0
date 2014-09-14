From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/mlx5: Fix possible array overflow
Date: Sun, 14 Sep 2014 16:47:53 +0300
Message-ID: <1410702475-28826-5-git-send-email-eli@mellanox.com>
References: <1410702475-28826-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410702475-28826-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The check to verify that userspace does not provide an invalid index to the
micro UAR was placed too late. Fix this by moving the check before using the
index.

Reported by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ecd3aebc46fe..a24431746377 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -650,13 +650,13 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 			return -EINVAL;
 
 		idx = get_index(vma->vm_pgoff);
+		if (idx >= uuari->num_uars)
+			return -EINVAL;
+
 		pfn = uar_index2pfn(dev, uuari->uars[idx].index);
 		mlx5_ib_dbg(dev, "uar idx 0x%lx, pfn 0x%llx\n", idx,
 			    (unsigned long long)pfn);
 
-		if (idx >= uuari->num_uars)
-			return -EINVAL;
-
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		if (io_remap_pfn_range(vma, vma->vm_start, pfn,
 				       PAGE_SIZE, vma->vm_page_prot))
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
