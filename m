From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/4] IB/mlx5: WQE dump jumps over first 16 bytes
Date: Tue, 19 Mar 2019 11:24:37 +0200
Message-ID: <20190319092439.10701-3-leon@kernel.org>
References: <20190319092439.10701-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190319092439.10701-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko@mellanox.com>

Move index increment after its is used or otherwise it will start the
dump of the WQE from second WQE BB.

Fixes: 34f4c9554d8b ("IB/mlx5: Use fragmented QP's buffer for in-kernel users")
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6b1f0e76900b..2014fd0fddc7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4724,16 +4724,15 @@ static void set_linv_wr(struct mlx5_ib_qp *qp, void **seg, int *size,
 static void dump_wqe(struct mlx5_ib_qp *qp, u32 idx, int size_16)
 {
 	__be32 *p = NULL;
-	u32 tidx = idx;
 	int i, j;
 
 	pr_debug("dump WQE index %u:\n", idx);
 	for (i = 0, j = 0; i < size_16 * 4; i += 4, j += 4) {
 		if ((i & 0xf) == 0) {
-			tidx = (tidx + 1) & (qp->sq.wqe_cnt - 1);
-			p = mlx5_frag_buf_get_wqe(&qp->sq.fbc, tidx);
+			p = mlx5_frag_buf_get_wqe(&qp->sq.fbc, idx);
 			pr_debug("WQBB at %p:\n", (void *)p);
 			j = 0;
+			idx = (idx + 1) & (qp->sq.wqe_cnt - 1);
 		}
 		pr_debug("%08x %08x %08x %08x\n", be32_to_cpu(p[j]),
 			 be32_to_cpu(p[j + 1]), be32_to_cpu(p[j + 2]),
-- 
2.20.1
