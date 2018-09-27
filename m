From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] RDMA/ucontext: fix building with CONFIG_MMU=n
Date: Thu, 27 Sep 2018 12:10:03 +0200
Message-ID: <20180927101017.990471-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Parav Pandit <parav@mellanox.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Huy Nguyen <huyn@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The zap_vma_ptes() is declared but not defined on NOMMU kernels,
causing a link error for the newly added uverbs code:

drivers/infiniband/core/uverbs_main.o: In function `uverbs_user_mmap_disassociate':
uverbs_main.c:(.text+0x114c): undefined reference to `zap_vma_ptes'
drivers/infiniband/core/uverbs_main.o: In function `rdma_umap_open':
uverbs_main.c:(.text+0x53c): undefined reference to `zap_vma_ptes'

To fix this, we can either make uverbs depend on CONFIG_MMU, or try
to build it anyway. Since this is the only compile-time dependency,
I decided to allow building it with an extra compile-time check for
CONFIG_MMU before calling the one function.

Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/core/uverbs_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 40dcf3d02a4b..5c1202af0748 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -884,7 +884,8 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	 * point, so zap it.
 	 */
 	vma->vm_private_data = NULL;
-	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	if (IS_ENABLED(CONFIG_MMU))
+		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 
 static void rdma_umap_close(struct vm_area_struct *vma)
@@ -1023,8 +1024,9 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 				continue;
 			list_del_init(&priv->list);
 
-			zap_vma_ptes(vma, vma->vm_start,
-				     vma->vm_end - vma->vm_start);
+			if (IS_ENABLED(CONFIG_MMU))
+				zap_vma_ptes(vma, vma->vm_start,
+					     vma->vm_end - vma->vm_start);
 			vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
 		}
 		mutex_unlock(&ufile->umap_lock);
-- 
2.18.0
