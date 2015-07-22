From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 05/10] IB/mlx5: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:38 -0600
Message-ID: <1437608083-22898-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 13 -------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
 drivers/infiniband/hw/mlx5/mr.c      |  5 ++---
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 085c24b4b603..72ab0bdb415a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1121,7 +1121,6 @@ static void destroy_umrc_res(struct mlx5_ib_dev *dev)
 
 	mlx5_ib_destroy_qp(dev->umrc.qp);
 	ib_destroy_cq(dev->umrc.cq);
-	ib_dereg_mr(dev->umrc.mr);
 	ib_dealloc_pd(dev->umrc.pd);
 }
 
@@ -1136,7 +1135,6 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	struct ib_pd *pd;
 	struct ib_cq *cq;
 	struct ib_qp *qp;
-	struct ib_mr *mr;
 	struct ib_cq_init_attr cq_attr = {};
 	int ret;
 
@@ -1154,13 +1152,6 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 		goto error_0;
 	}
 
-	mr = ib_get_dma_mr(pd,  IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(mr)) {
-		mlx5_ib_dbg(dev, "Couldn't create DMA MR for sync UMR QP\n");
-		ret = PTR_ERR(mr);
-		goto error_1;
-	}
-
 	cq_attr.cqe = 128;
 	cq = ib_create_cq(&dev->ib_dev, mlx5_umr_cq_handler, NULL, NULL,
 			  &cq_attr);
@@ -1218,7 +1209,6 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 
 	dev->umrc.qp = qp;
 	dev->umrc.cq = cq;
-	dev->umrc.mr = mr;
 	dev->umrc.pd = pd;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
@@ -1240,9 +1230,6 @@ error_3:
 	ib_destroy_cq(cq);
 
 error_2:
-	ib_dereg_mr(mr);
-
-error_1:
 	ib_dealloc_pd(pd);
 
 error_0:
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7cae09836481..446d80427773 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -349,7 +349,6 @@ struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
 	struct ib_qp	*qp;
-	struct ib_mr	*mr;
 	/* control access to UMR QP
 	 */
 	struct semaphore	sem;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bc9a0de897cb..4c92ca8a4181 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -690,12 +690,11 @@ static void prep_umr_reg_wqe(struct ib_pd *pd, struct ib_send_wr *wr,
 			     int access_flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct ib_mr *mr = dev->umrc.mr;
 	struct mlx5_umr_wr *umrwr = (struct mlx5_umr_wr *)&wr->wr.fast_reg;
 
 	sg->addr = dma;
 	sg->length = ALIGN(sizeof(u64) * n, 64);
-	sg->lkey = mr->lkey;
+	sg->lkey = dev->umrc.pd->local_dma_lkey;
 
 	wr->next = NULL;
 	wr->send_flags = 0;
@@ -926,7 +925,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 		sg.addr = dma;
 		sg.length = ALIGN(npages * sizeof(u64),
 				MLX5_UMR_MTT_ALIGNMENT);
-		sg.lkey = dev->umrc.mr->lkey;
+		sg.lkey = dev->umrc.pd->local_dma_lkey;
 
 		wr.send_flags = MLX5_IB_SEND_UMR_FAIL_IF_FREE |
 				MLX5_IB_SEND_UMR_UPDATE_MTT;
-- 
2.1.4
