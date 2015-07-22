From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 09/10] ib_srpt: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:42 -0600
Message-ID: <1437608083-22898-10-git-send-email-jgunthorpe@obsidianresearch.com>
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
 drivers/infiniband/ulp/srpt/ib_srpt.c | 15 ++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  1 -
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 82897ca17f32..07da3817d92d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -783,7 +783,7 @@ static int srpt_post_recv(struct srpt_device *sdev,
 
 	list.addr = ioctx->ioctx.dma;
 	list.length = srp_max_req_size;
-	list.lkey = sdev->mr->lkey;
+	list.lkey = sdev->pd->local_dma_lkey;
 
 	wr.next = NULL;
 	wr.sg_list = &list;
@@ -818,7 +818,7 @@ static int srpt_post_send(struct srpt_rdma_ch *ch,
 
 	list.addr = ioctx->ioctx.dma;
 	list.length = len;
-	list.lkey = sdev->mr->lkey;
+	list.lkey = sdev->pd->local_dma_lkey;
 
 	wr.next = NULL;
 	wr.wr_id = encode_wr_id(SRPT_SEND, ioctx->ioctx.index);
@@ -1206,7 +1206,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 
 		while (rsize > 0 && tsize > 0) {
 			sge->addr = dma_addr;
-			sge->lkey = ch->sport->sdev->mr->lkey;
+			sge->lkey = ch->sport->sdev->pd->local_dma_lkey;
 
 			if (rsize >= dma_len) {
 				sge->length =
@@ -3212,10 +3212,6 @@ static void srpt_add_one(struct ib_device *device)
 	if (IS_ERR(sdev->pd))
 		goto free_dev;
 
-	sdev->mr = ib_get_dma_mr(sdev->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(sdev->mr))
-		goto err_pd;
-
 	sdev->srq_size = min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
 
 	srq_attr.event_handler = srpt_srq_event;
@@ -3227,7 +3223,7 @@ static void srpt_add_one(struct ib_device *device)
 
 	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);
 	if (IS_ERR(sdev->srq))
-		goto err_mr;
+		goto err_pd;
 
 	pr_debug("%s: create SRQ #wr= %d max_allow=%d dev= %s\n",
 		 __func__, sdev->srq_size, sdev->dev_attr.max_srq_wr,
@@ -3312,8 +3308,6 @@ err_cm:
 	ib_destroy_cm_id(sdev->cm_id);
 err_srq:
 	ib_destroy_srq(sdev->srq);
-err_mr:
-	ib_dereg_mr(sdev->mr);
 err_pd:
 	ib_dealloc_pd(sdev->pd);
 free_dev:
@@ -3359,7 +3353,6 @@ static void srpt_remove_one(struct ib_device *device)
 	srpt_release_sdev(sdev);
 
 	ib_destroy_srq(sdev->srq);
-	ib_dereg_mr(sdev->mr);
 	ib_dealloc_pd(sdev->pd);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)sdev->ioctx_ring, sdev,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 21f8df67522a..5faad8acd789 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -393,7 +393,6 @@ struct srpt_port {
 struct srpt_device {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
-	struct ib_mr		*mr;
 	struct ib_srq		*srq;
 	struct ib_cm_id		*cm_id;
 	struct ib_device_attr	dev_attr;
-- 
2.1.4
