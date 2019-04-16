From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 1/6] RDMA/mlx5: Do not allow the user to write to the clock page
Date: Tue, 16 Apr 2019 14:07:25 +0300
Message-ID: <20190416110730.32230-2-leon@kernel.org>
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

The intent of this VMA was to be read-only from user space, but the
VM_MAYWRITE masking was missed, so mprotect could make it writable.

Cc: stable@vger.kernel.org
Fixes: 5c99eaecb1fc ("IB/mlx5: Mmap the HCA's clock info to user-space")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 15676a149680..73b7f9636f82 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2072,6 +2072,7 @@ static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
 
 	if (vma->vm_flags & VM_WRITE)
 		return -EPERM;
+	vma->vm_flags &= ~VM_MAYWRITE;
 
 	if (!dev->mdev->clock_info_page)
 		return -EOPNOTSUPP;
@@ -2237,6 +2238,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 
 		if (vma->vm_flags & VM_WRITE)
 			return -EPERM;
+		vma->vm_flags &= ~VM_MAYWRITE;
 
 		/* Don't expose to user-space information it shouldn't have */
 		if (PAGE_SIZE > 4096)
-- 
2.20.1
