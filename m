From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/6] RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
Date: Tue, 16 Apr 2019 14:07:26 +0300
Message-ID: <20190416110730.32230-3-leon@kernel.org>
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

Since mlx5 supports device disassociate it must use this API for all
BAR page mmaps, otherwise the pages can remain mapped after the device
is unplugged causing a system crash.

Cc: stable@vger.kernel.org
Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 73b7f9636f82..77b018c0923f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2244,14 +2244,12 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 		if (PAGE_SIZE > 4096)
 			return -EOPNOTSUPP;
 
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		pfn = (dev->mdev->iseg_base +
 		       offsetof(struct mlx5_init_seg, internal_timer_h)) >>
 			PAGE_SHIFT;
-		if (io_remap_pfn_range(vma, vma->vm_start, pfn,
-				       PAGE_SIZE, vma->vm_page_prot))
-			return -EAGAIN;
-		break;
+		return rdma_user_mmap_io(&context->ibucontext, vma, pfn,
+					 PAGE_SIZE,
+					 pgprot_noncached(vma->vm_page_prot));
 	case MLX5_IB_MMAP_CLOCK_INFO:
 		return mlx5_ib_mmap_clock_info_page(dev, vma, context);
 
-- 
2.20.1
