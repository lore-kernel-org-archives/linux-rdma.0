From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 1/4] IB/mlx5: Reset access mask when looping inside page fault handler
Date: Tue, 19 Mar 2019 11:24:36 +0200
Message-ID: <20190319092439.10701-2-leon@kernel.org>
References: <20190319092439.10701-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190319092439.10701-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

If page-fault handler spans multiple MRs then the access mask needs to
be reset before each MR handling or otherwise write access will be
granted to mapped pages instead of read-only.

Cc: <stable@vger.kernel.org> # 3.19
Fixes: 7bdf65d411c1 ("IB/mlx5: Handle page faults")
Reported-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index ec8381d1e0f2..95dccac1f844 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -585,7 +585,7 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	struct ib_umem_odp *odp_mr = to_ib_umem_odp(mr->umem);
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
 	bool prefetch = flags & MLX5_PF_FLAGS_PREFETCH;
-	u64 access_mask = ODP_READ_ALLOWED_BIT;
+	u64 access_mask;
 	u64 start_idx, page_mask;
 	struct ib_umem_odp *odp;
 	size_t size;
@@ -607,6 +607,7 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	page_shift = mr->umem->page_shift;
 	page_mask = ~(BIT(page_shift) - 1);
 	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
+	access_mask = ODP_READ_ALLOWED_BIT;
 
 	if (prefetch && !downgrade && !mr->umem->writable) {
 		/* prefetch with write-access must
-- 
2.20.1
