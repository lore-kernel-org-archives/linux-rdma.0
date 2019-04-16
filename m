From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 5/6] RDMA/mlx5: Use get_zeroed_page() for clock_info
Date: Tue, 16 Apr 2019 14:07:29 +0300
Message-ID: <20190416110730.32230-6-leon@kernel.org>
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

get_zeroed_page() returns a virtual address for the page which is better
than allocating a struct page and doing a permanent kmap on it.

Cc: stable@vger.kernel.org
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  5 ++--
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 30 +++++++------------
 include/linux/mlx5/driver.h                   |  1 -
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 77b018c0923f..9a718258b8eb 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2074,11 +2074,12 @@ static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
 		return -EPERM;
 	vma->vm_flags &= ~VM_MAYWRITE;
 
-	if (!dev->mdev->clock_info_page)
+	if (!dev->mdev->clock_info)
 		return -EOPNOTSUPP;
 
 	return rdma_user_mmap_page(&context->ibucontext, vma,
-				   dev->mdev->clock_info_page, PAGE_SIZE);
+				   virt_to_page(dev->mdev->clock_info),
+				   PAGE_SIZE);
 }
 
 static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ca0ee9916e9e..0059b290e095 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -535,23 +535,16 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	do_div(ns, NSEC_PER_SEC / HZ);
 	clock->overflow_period = ns;
 
-	mdev->clock_info_page = alloc_page(GFP_KERNEL);
-	if (mdev->clock_info_page) {
-		mdev->clock_info = kmap(mdev->clock_info_page);
-		if (!mdev->clock_info) {
-			__free_page(mdev->clock_info_page);
-			mlx5_core_warn(mdev, "failed to map clock page\n");
-		} else {
-			mdev->clock_info->sign   = 0;
-			mdev->clock_info->nsec   = clock->tc.nsec;
-			mdev->clock_info->cycles = clock->tc.cycle_last;
-			mdev->clock_info->mask   = clock->cycles.mask;
-			mdev->clock_info->mult   = clock->nominal_c_mult;
-			mdev->clock_info->shift  = clock->cycles.shift;
-			mdev->clock_info->frac   = clock->tc.frac;
-			mdev->clock_info->overflow_period =
-						clock->overflow_period;
-		}
+	mdev->clock_info =
+		(struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
+	if (mdev->clock_info) {
+		mdev->clock_info->nsec = clock->tc.nsec;
+		mdev->clock_info->cycles = clock->tc.cycle_last;
+		mdev->clock_info->mask = clock->cycles.mask;
+		mdev->clock_info->mult = clock->nominal_c_mult;
+		mdev->clock_info->shift = clock->cycles.shift;
+		mdev->clock_info->frac = clock->tc.frac;
+		mdev->clock_info->overflow_period = clock->overflow_period;
 	}
 
 	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
@@ -599,8 +592,7 @@ void mlx5_cleanup_clock(struct mlx5_core_dev *mdev)
 	cancel_delayed_work_sync(&clock->overflow_work);
 
 	if (mdev->clock_info) {
-		kunmap(mdev->clock_info_page);
-		__free_page(mdev->clock_info_page);
+		free_page((unsigned long)mdev->clock_info);
 		mdev->clock_info = NULL;
 	}
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6c43191c0186..de4a493de3b9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -681,7 +681,6 @@ struct mlx5_core_dev {
 #endif
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
-	struct page             *clock_info_page;
 	struct mlx5_fw_tracer   *tracer;
 };
 
-- 
2.20.1
