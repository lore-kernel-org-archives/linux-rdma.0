From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/6] SRP initiator related bug fixes
Date: Fri, 4 Dec 2015 15:08:15 -0800
Message-ID: <56621CDF.3070604@sandisk.com>
References: <565DE3EC.2070002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE3EC.2070002-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/01/2015 10:16 AM, Bart Van Assche wrote:
> [ ... ]

Hello,

While preparing this patch series I noticed that none of the SCSI RDMA
initiator drivers syncs RDMA buffers before performing RDMA. Does
anyone know why something like the code below is not present in these
drivers and why no dma_sync_sg operations are present in struct
ib_dma_mapping_ops ?

Thanks,

Bart.


[PATCH] IB/srp: Sync scatterlists before and after DMA

---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++++
 include/rdma/ib_verbs.h             | 16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3db9a65..23e3c25 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1780,6 +1780,7 @@ static int srp_post_recv(struct srp_rdma_ch *ch, struct srp_iu *iu)
 static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 {
 	struct srp_target_port *target = ch->target;
+	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_request *req;
 	struct scsi_cmnd *scmnd;
 	unsigned long flags;
@@ -1828,6 +1829,11 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
 			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
 
+		if (scmnd->sc_data_direction != DMA_NONE)
+			ib_dma_sync_sg_for_cpu(dev, scsi_sglist(scmnd),
+					       scsi_sg_count(scmnd),
+					       scmnd->sc_data_direction);
+
 		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
 
@@ -2112,6 +2118,10 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
 				      DMA_TO_DEVICE);
+	if (scmnd->sc_data_direction != DMA_NONE)
+		ib_dma_sync_sg_for_device(dev, scsi_sglist(scmnd),
+					  scsi_sg_count(scmnd),
+					  scmnd->sc_data_direction);
 
 	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a68a19..5f9cba7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2796,6 +2796,22 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
 		dma_sync_single_for_device(dev->dma_device, addr, size, dir);
 }
 
+/* Prepare DMA region to be accessed by CPU */
+static inline void ib_dma_sync_sg_for_cpu(struct ib_device *dev,
+					  struct scatterlist *sg, int nelems,
+					  enum dma_data_direction dir)
+{
+	dma_sync_sg_for_cpu(dev->dma_device, sg, nelems, dir);
+}
+
+/* Prepare DMA region to be accessed by HCA */
+static inline void ib_dma_sync_sg_for_device(struct ib_device *dev,
+					     struct scatterlist *sg, int nelems,
+					     enum dma_data_direction dir)
+{
+	dma_sync_sg_for_device(dev->dma_device, sg, nelems, dir);
+}
+
 /**
  * ib_dma_alloc_coherent - Allocate memory and map it for DMA
  * @dev: The device for which the DMA address is requested
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
