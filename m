From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] RDMA/uverbs: Fix compilation error on s390 and mips platforms
Date: Mon, 29 Apr 2019 13:00:14 +0300
Message-ID: <20190429100014.5820-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Most platforms ignore parameter provided to ZERO_PAGE macro,
hence wrong parameter was used and missed. This caused to compilation
error like presented below.

drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
drivers/infiniband/core/uverbs_main.c:898:28: error: 'struct vm_fault' has no member named 'vm_start'
   vmf->page = ZERO_PAGE(vmf->vm_start);
                            ^~
Cc: stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7843e89235c3..65fe89b3fa2d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -895,7 +895,7 @@ static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)

 	/* Read only pages can just use the system zero page. */
 	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
-		vmf->page = ZERO_PAGE(vmf->vm_start);
+		vmf->page = ZERO_PAGE(vmf->vma->vm_start);
 		get_page(vmf->page);
 		return 0;
 	}
