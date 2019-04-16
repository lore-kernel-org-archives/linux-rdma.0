From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings to be executable
Date: Tue, 16 Apr 2019 14:07:27 +0300
Message-ID: <20190416110730.32230-4-leon@kernel.org>
References: <20190416110730.32230-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190416110730.32230-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

These are not code pages and should never be executed.

Cc: stable@vger.kernel.org
Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index fef4519d1241..3ef6474cd201 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -889,6 +889,10 @@ static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *ucontext,
 	struct ib_uverbs_file *ufile = ucontext->ufile;
 	struct rdma_umap_priv *priv;
 
+	if (vma->vm_flags & VM_EXEC)
+		return ERR_PTR(-EINVAL);
+	vma->vm_flags &= ~VM_MAYEXEC;
+
 	if (vma->vm_end - vma->vm_start != size)
 		return ERR_PTR(-EINVAL);
 
-- 
2.20.1
