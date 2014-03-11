From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/mad: Check and handle potential DMA mapping errors
Date: Tue, 11 Mar 2014 14:41:47 +0200
Message-ID: <1394541707-9282-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Running over a kernel built with DMA_API_DEBUG and not checking for
DMA mapping error triggers a kernel stack trace with "DMA-API: device
driver failed to check map error" message. So adding it here, for the
sake of being more robust and eliminating the false-positives stack traces.

Signed-off-by: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4c837e6..ab31f13 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1022,12 +1022,21 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 					mad_send_wr->send_buf.mad,
 					sge[0].length,
 					DMA_TO_DEVICE);
+	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[0].addr)))
+		return -ENOMEM;
+
 	mad_send_wr->header_mapping = sge[0].addr;
 
 	sge[1].addr = ib_dma_map_single(mad_agent->device,
 					ib_get_payload(mad_send_wr),
 					sge[1].length,
 					DMA_TO_DEVICE);
+	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[1].addr))) {
+		ib_dma_unmap_single(mad_agent->device,
+				    mad_send_wr->header_mapping,
+				    sge[0].length, DMA_TO_DEVICE);
+		return -ENOMEM;
+	}
 	mad_send_wr->payload_mapping = sge[1].addr;
 
 	spin_lock_irqsave(&qp_info->send_queue.lock, flags);
@@ -2590,6 +2599,11 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 						 sizeof *mad_priv -
 						   sizeof mad_priv->header,
 						 DMA_FROM_DEVICE);
+		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
+						  sg_list.addr))) {
+			ret = -ENOMEM;
+			break;
+		}
 		mad_priv->header.mapping = sg_list.addr;
 		recv_wr.wr_id = (unsigned long)&mad_priv->header.mad_list;
 		mad_priv->header.mad_list.mad_queue = recv_queue;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
