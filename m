From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/umem: Fix missing mmap_sem in get umem ODP call
Date: Sun, 21 May 2017 19:08:09 +0300
Message-ID: <20170521160809.19793-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add mmap_sem lock around VMA inspection in ib_umem_odp_get().

Fixes: 0008b84ea9af ('IB/umem: Add support to huge ODP')
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 0780b1afefa9..8c4ec564e495 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -321,11 +321,15 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
 		struct vm_area_struct *vma;
 		struct hstate *h;

+		down_read(&mm->mmap_sem);
 		vma = find_vma(mm, ib_umem_start(umem));
-		if (!vma || !is_vm_hugetlb_page(vma))
+		if (!vma || !is_vm_hugetlb_page(vma)) {
+			up_read(&mm->mmap_sem);
 			return -EINVAL;
+		}
 		h = hstate_vma(vma);
 		umem->page_shift = huge_page_shift(h);
+		up_read(&mm->mmap_sem);
 		umem->hugetlb = 1;
 	} else {
 		umem->hugetlb = 0;
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
