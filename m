From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 20/26] IB/srpt: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:12 -0800
Message-ID: <20170112190718.6728-21-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7ff9de063c53..df42ae43bce0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -626,8 +626,8 @@ static struct srpt_ioctx *srpt_alloc_ioctx(struct srpt_device *sdev,
 	if (!ioctx->buf)
 		goto err_free_ioctx;
 
-	ioctx->dma = ib_dma_map_single(sdev->device, ioctx->buf, dma_size, dir);
-	if (ib_dma_mapping_error(sdev->device, ioctx->dma))
+	ioctx->dma = dma_map_single(sdev->device->dma_device, ioctx->buf, dma_size, dir);
+	if (dma_mapping_error(sdev->device->dma_device, ioctx->dma))
 		goto err_free_buf;
 
 	return ioctx;
@@ -649,7 +649,7 @@ static void srpt_free_ioctx(struct srpt_device *sdev, struct srpt_ioctx *ioctx,
 	if (!ioctx)
 		return;
 
-	ib_dma_unmap_single(sdev->device, ioctx->dma, dma_size, dir);
+	dma_unmap_single(sdev->device->dma_device, ioctx->dma, dma_size, dir);
 	kfree(ioctx->buf);
 	kfree(ioctx);
 }
@@ -1492,9 +1492,9 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 	BUG_ON(!ch);
 	BUG_ON(!recv_ioctx);
 
-	ib_dma_sync_single_for_cpu(ch->sport->sdev->device,
-				   recv_ioctx->ioctx.dma, srp_max_req_size,
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ch->sport->sdev->device->dma_device,
+				recv_ioctx->ioctx.dma, srp_max_req_size,
+				DMA_FROM_DEVICE);
 
 	if (unlikely(ch->state == CH_CONNECTING))
 		goto out_wait;
@@ -2385,8 +2385,8 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		goto out;
 	}
 
-	ib_dma_sync_single_for_device(sdev->device, ioctx->ioctx.dma, resp_len,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(sdev->device->dma_device, ioctx->ioctx.dma,
+				   resp_len, DMA_TO_DEVICE);
 
 	sge.addr = ioctx->ioctx.dma;
 	sge.length = resp_len;
-- 
2.11.0
