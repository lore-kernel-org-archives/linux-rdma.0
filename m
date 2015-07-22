From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 10/10] net/9p: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:43 -0600
Message-ID: <1437608083-22898-11-git-send-email-jgunthorpe@obsidianresearch.com>
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
 net/9p/trans_rdma.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 37a78d20c0f6..ba1210253f5e 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -94,8 +94,6 @@ struct p9_trans_rdma {
 	struct ib_pd *pd;
 	struct ib_qp *qp;
 	struct ib_cq *cq;
-	struct ib_mr *dma_mr;
-	u32 lkey;
 	long timeout;
 	int sq_depth;
 	struct semaphore sq_sem;
@@ -382,9 +380,6 @@ static void rdma_destroy_trans(struct p9_trans_rdma *rdma)
 	if (!rdma)
 		return;
 
-	if (rdma->dma_mr && !IS_ERR(rdma->dma_mr))
-		ib_dereg_mr(rdma->dma_mr);
-
 	if (rdma->qp && !IS_ERR(rdma->qp))
 		ib_destroy_qp(rdma->qp);
 
@@ -415,7 +410,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 
 	sge.addr = c->busa;
 	sge.length = client->msize;
-	sge.lkey = rdma->lkey;
+	sge.lkey = rdma->pd->local_dma_lkey;
 
 	wr.next = NULL;
 	c->wc_op = IB_WC_RECV;
@@ -506,7 +501,7 @@ dont_need_post_recv:
 
 	sge.addr = c->busa;
 	sge.length = c->req->tc->size;
-	sge.lkey = rdma->lkey;
+	sge.lkey = rdma->pd->local_dma_lkey;
 
 	wr.next = NULL;
 	c->wc_op = IB_WC_SEND;
@@ -647,7 +642,6 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 	struct p9_trans_rdma *rdma;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
-	struct ib_device_attr devattr;
 	struct ib_cq_init_attr cq_attr = {};
 
 	/* Parse the transport specific mount options */
@@ -700,11 +694,6 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 	if (err || (rdma->state != P9_RDMA_ROUTE_RESOLVED))
 		goto error;
 
-	/* Query the device attributes */
-	err = ib_query_device(rdma->cm_id->device, &devattr);
-	if (err)
-		goto error;
-
 	/* Create the Completion Queue */
 	cq_attr.cqe = opts.sq_depth + opts.rq_depth + 1;
 	rdma->cq = ib_create_cq(rdma->cm_id->device, cq_comp_handler,
@@ -719,17 +708,6 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 	if (IS_ERR(rdma->pd))
 		goto error;
 
-	/* Cache the DMA lkey in the transport */
-	rdma->dma_mr = NULL;
-	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
-		rdma->lkey = rdma->cm_id->device->local_dma_lkey;
-	else {
-		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(rdma->dma_mr))
-			goto error;
-		rdma->lkey = rdma->dma_mr->lkey;
-	}
-
 	/* Create the Queue Pair */
 	memset(&qp_attr, 0, sizeof qp_attr);
 	qp_attr.event_handler = qp_event_handler;
-- 
2.1.4
