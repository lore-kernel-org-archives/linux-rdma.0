From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 23/26] net/9p: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:15 -0800
Message-ID: <20170112190718.6728-24-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Eric Van Hensbergen <ericvh@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/trans_rdma.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 553ed4ecb6a0..b49d5998289e 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -294,8 +294,8 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	int16_t tag;
 
 	req = NULL;
-	ib_dma_unmap_single(rdma->cm_id->device, c->busa, client->msize,
-							 DMA_FROM_DEVICE);
+	dma_unmap_single(rdma->cm_id->device->dma_device, c->busa,
+			 client->msize, DMA_FROM_DEVICE);
 
 	if (wc->status != IB_WC_SUCCESS)
 		goto err_out;
@@ -339,9 +339,8 @@ send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct p9_rdma_context *c =
 		container_of(wc->wr_cqe, struct p9_rdma_context, cqe);
 
-	ib_dma_unmap_single(rdma->cm_id->device,
-			    c->busa, c->req->tc->size,
-			    DMA_TO_DEVICE);
+	dma_unmap_single(rdma->cm_id->device->dma_device, c->busa,
+			 c->req->tc->size, DMA_TO_DEVICE);
 	up(&rdma->sq_sem);
 	kfree(c);
 }
@@ -379,10 +378,9 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct ib_recv_wr wr, *bad_wr;
 	struct ib_sge sge;
 
-	c->busa = ib_dma_map_single(rdma->cm_id->device,
-				    c->rc->sdata, client->msize,
-				    DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa))
+	c->busa = dma_map_single(rdma->cm_id->device->dma_device, c->rc->sdata,
+				 client->msize, DMA_FROM_DEVICE);
+	if (dma_mapping_error(rdma->cm_id->device->dma_device, c->busa))
 		goto error;
 
 	c->cqe.done = recv_done;
@@ -469,10 +467,10 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	}
 	c->req = req;
 
-	c->busa = ib_dma_map_single(rdma->cm_id->device,
-				    c->req->tc->sdata, c->req->tc->size,
-				    DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa)) {
+	c->busa = dma_map_single(rdma->cm_id->device->dma_device,
+				 c->req->tc->sdata, c->req->tc->size,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(rdma->cm_id->device->dma_device, c->busa)) {
 		err = -EIO;
 		goto send_error;
 	}
-- 
2.11.0
