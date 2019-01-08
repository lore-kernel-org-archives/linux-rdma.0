From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 1/5] RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
Date: Tue,  8 Jan 2019 08:16:41 +0200
Message-ID: <20190108061645.25226-2-leon@kernel.org>
References: <20190108061645.25226-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190108061645.25226-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

CONFIG_INFINIBAND_ON_DEMAND_PAGING is used in general structures
to micro-optimize the memory footprint. Remove it, so it will allow
us to simplify various ODP device flows.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 --
 include/rdma/ib_verbs.h              | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b06d3b1efea8..93c288a4de2b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -911,7 +911,6 @@ struct mlx5_ib_dev {
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
 	int				fill_delay;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_odp_caps	odp_caps;
 	u64			odp_max_size;
 	struct mlx5_ib_pf_eq	odp_pf_eq;
@@ -923,7 +922,6 @@ struct mlx5_ib_dev {
 	struct srcu_struct      mr_srcu;
 	u32			null_mkey;
 	struct workqueue_struct *advise_mr_wq;
-#endif
 	struct mlx5_ib_flow_db	*flow_db;
 	/* protect resources needed as part of reset flow */
 	spinlock_t		reset_flow_resource_lock;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a3ceed3a040a..3ddd199ba602 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1504,12 +1504,10 @@ struct ib_ucontext {
 
 	bool cleanup_retryable;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	void (*invalidate_range)(struct ib_umem_odp *umem_odp,
 				 unsigned long start, unsigned long end);
 	struct mutex per_mm_list_lock;
 	struct list_head per_mm_list;
-#endif
 
 	struct ib_rdmacg_object	cg_obj;
 	/*
-- 
2.19.1
