From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 04/10] IB/mlx4: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:37 -0600
Message-ID: <1437608083-22898-5-git-send-email-jgunthorpe@obsidianresearch.com>
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
 drivers/infiniband/hw/mlx4/mad.c     | 23 ++++-------------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  1 -
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 85a50df2f203..3a897ed3db30 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -580,7 +580,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	list.addr = tun_qp->tx_ring[tun_tx_ix].buf.map;
 	list.length = sizeof (struct mlx4_rcv_tunnel_mad);
-	list.lkey = tun_ctx->mr->lkey;
+	list.lkey = tun_ctx->pd->local_dma_lkey;
 
 	wr.wr.ud.ah = ah;
 	wr.wr.ud.port_num = port;
@@ -1123,7 +1123,7 @@ static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_demux_pv_ctx *ctx,
 
 	sg_list.addr = tun_qp->ring[index].map;
 	sg_list.length = size;
-	sg_list.lkey = ctx->mr->lkey;
+	sg_list.lkey = ctx->pd->local_dma_lkey;
 
 	recv_wr.next = NULL;
 	recv_wr.sg_list = &sg_list;
@@ -1234,7 +1234,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	list.addr = sqp->tx_ring[wire_tx_ix].buf.map;
 	list.length = sizeof (struct mlx4_mad_snd_buf);
-	list.lkey = sqp_ctx->mr->lkey;
+	list.lkey = sqp_ctx->pd->local_dma_lkey;
 
 	wr.wr.ud.ah = ah;
 	wr.wr.ud.port_num = port;
@@ -1817,19 +1817,12 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		goto err_cq;
 	}
 
-	ctx->mr = ib_get_dma_mr(ctx->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(ctx->mr)) {
-		ret = PTR_ERR(ctx->mr);
-		pr_err("Couldn't get tunnel DMA MR (%d)\n", ret);
-		goto err_pd;
-	}
-
 	if (ctx->has_smi) {
 		ret = create_pv_sqp(ctx, IB_QPT_SMI, create_tun);
 		if (ret) {
 			pr_err("Couldn't create %s QP0 (%d)\n",
 			       create_tun ? "tunnel for" : "",  ret);
-			goto err_mr;
+			goto err_pd;
 		}
 	}
 
@@ -1866,10 +1859,6 @@ err_qp0:
 		ib_destroy_qp(ctx->qp[0].qp);
 	ctx->qp[0].qp = NULL;
 
-err_mr:
-	ib_dereg_mr(ctx->mr);
-	ctx->mr = NULL;
-
 err_pd:
 	ib_dealloc_pd(ctx->pd);
 	ctx->pd = NULL;
@@ -1906,8 +1895,6 @@ static void destroy_pv_resources(struct mlx4_ib_dev *dev, int slave, int port,
 		ib_destroy_qp(ctx->qp[1].qp);
 		ctx->qp[1].qp = NULL;
 		mlx4_ib_free_pv_qp_bufs(ctx, IB_QPT_GSI, 1);
-		ib_dereg_mr(ctx->mr);
-		ctx->mr = NULL;
 		ib_dealloc_pd(ctx->pd);
 		ctx->pd = NULL;
 		ib_destroy_cq(ctx->cq);
@@ -2040,8 +2027,6 @@ static void mlx4_ib_free_sqp_ctx(struct mlx4_ib_demux_pv_ctx *sqp_ctx)
 		ib_destroy_qp(sqp_ctx->qp[1].qp);
 		sqp_ctx->qp[1].qp = NULL;
 		mlx4_ib_free_pv_qp_bufs(sqp_ctx, IB_QPT_GSI, 0);
-		ib_dereg_mr(sqp_ctx->mr);
-		sqp_ctx->mr = NULL;
 		ib_dealloc_pd(sqp_ctx->pd);
 		sqp_ctx->pd = NULL;
 		ib_destroy_cq(sqp_ctx->cq);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 334387f63358..9066fc2406cc 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -415,7 +415,6 @@ struct mlx4_ib_demux_pv_ctx {
 	struct ib_device *ib_dev;
 	struct ib_cq *cq;
 	struct ib_pd *pd;
-	struct ib_mr *mr;
 	struct work_struct work;
 	struct workqueue_struct *wq;
 	struct mlx4_ib_demux_pv_qp qp[2];
-- 
2.1.4
