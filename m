From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 06/11] RDMA/mlx5: Remove SRQ signature global flag
Date: Wed, 28 Nov 2018 20:53:38 +0200
Message-ID: <20181128185343.21669-7-leon@kernel.org>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

SRQ signature is not supported, hence no need for special static
global variable to announce it.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/srq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a86d9f153805..154fd0d3718e 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -12,9 +12,6 @@
 #include "mlx5_ib.h"
 #include "srq.h"

-/* not supported currently */
-static int srq_signature;
-
 static void *get_wqe(struct mlx5_ib_srq *srq, int n)
 {
 	return mlx5_buf_offset(&srq->buf, n << srq->msrq.wqe_shift);
@@ -175,7 +172,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 		err = -ENOMEM;
 		goto err_in;
 	}
-	srq->wq_sig = !!srq_signature;
+	srq->wq_sig = 0;

 	in->log_page_size = srq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
