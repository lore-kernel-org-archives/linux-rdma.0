From: Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 1/3] infinitiband: ocrdma: Don't memset() buffers we just allocated with kzalloc()
Date: Sun,  5 Oct 2014 16:33:23 +0200
Message-ID: <1412519605-16106-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1412519605-16106-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412519605-16106-1-git-send-email-Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Get rid of obfuscating ocrdma_alloc_mqe() kzalloc() wrapper as all it
did was to make it less visible that the structure was already cleared
on allocation.

Signed-off-by: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index dd35ae5..01c29e7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -348,11 +348,6 @@ static void *ocrdma_init_emb_mqe(u8 opcode, u32 cmd_len)
 	return mqe;
 }
 
-static void *ocrdma_alloc_mqe(void)
-{
-	return kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
-}
-
 static void ocrdma_free_q(struct ocrdma_dev *dev, struct ocrdma_queue_info *q)
 {
 	dma_free_coherent(&dev->nic_info.pdev->dev, q->size, q->va, q->dma);
@@ -1189,10 +1184,10 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
 {
 	struct ocrdma_rdma_stats_req *req = dev->stats_mem.va;
 	struct ocrdma_mqe *mqe = &dev->stats_mem.mqe;
-	struct ocrdma_rdma_stats_resp *old_stats = NULL;
+	struct ocrdma_rdma_stats_resp *old_stats;
 	int status;
 
-	old_stats = kzalloc(sizeof(*old_stats), GFP_KERNEL);
+	old_stats = kmalloc(sizeof(*old_stats), GFP_KERNEL);
 	if (old_stats == NULL)
 		return -ENOMEM;
 
@@ -1235,10 +1230,9 @@ static int ocrdma_mbx_get_ctrl_attribs(struct ocrdma_dev *dev)
 	struct ocrdma_get_ctrl_attribs_rsp *ctrl_attr_rsp;
 	struct mgmt_hba_attribs *hba_attribs;
 
-	mqe = ocrdma_alloc_mqe();
+	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
 	if (!mqe)
 		return status;
-	memset(mqe, 0, sizeof(*mqe));
 
 	dma.size = sizeof(struct ocrdma_get_ctrl_attribs_rsp);
 	dma.va	 = dma_alloc_coherent(&dev->nic_info.pdev->dev,
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
