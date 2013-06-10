From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] RDMA/ocrdma: Use MCC_CREATE_EXT_V1 for MCC create.
Date: Mon, 10 Jun 2013 10:12:38 +0530
Message-ID: <81e5cef1-1958-4a21-b182-0f17cfe9c01b@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Use MCC_CREATE_EXT_V1 to create MCC_queue to receive RoCE events.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  | 39 +++++++++++--------------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 20 ++--------------
 2 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 910b706..f671d5d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -563,32 +563,19 @@ static int ocrdma_mbx_create_mq(struct ocrdma_dev *dev,
 	memset(cmd, 0, sizeof(*cmd));
 	num_pages = PAGES_4K_SPANNED(mq->va, mq->size);
 
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-		ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_MQ,
-				OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
-		cmd->v0.pages = num_pages;
-		cmd->v0.async_cqid_valid = OCRDMA_CREATE_MQ_ASYNC_CQ_VALID;
-		cmd->v0.async_cqid_valid = (cq->id << 1);
-		cmd->v0.cqid_ringsize |= (ocrdma_encoded_q_len(mq->len) <<
-					     OCRDMA_CREATE_MQ_RING_SIZE_SHIFT);
-		cmd->v0.cqid_ringsize |=
-			(cq->id << OCRDMA_CREATE_MQ_V0_CQ_ID_SHIFT);
-		cmd->v0.valid = OCRDMA_CREATE_MQ_VALID;
-		pa = &cmd->v0.pa[0];
-	} else {
-		ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_MQ_EXT,
-				OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
-		cmd->req.rsvd_version = 1;
-		cmd->v1.cqid_pages = num_pages;
-		cmd->v1.cqid_pages |= (cq->id << OCRDMA_CREATE_MQ_CQ_ID_SHIFT);
-		cmd->v1.async_cqid_valid = OCRDMA_CREATE_MQ_ASYNC_CQ_VALID;
-		cmd->v1.async_event_bitmap = Bit(20);
-		cmd->v1.async_cqid_ringsize = cq->id;
-		cmd->v1.async_cqid_ringsize |= (ocrdma_encoded_q_len(mq->len) <<
-					     OCRDMA_CREATE_MQ_RING_SIZE_SHIFT);
-		cmd->v1.valid = OCRDMA_CREATE_MQ_VALID;
-		pa = &cmd->v1.pa[0];
-	}
+	ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_MQ_EXT,
+			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
+	cmd->req.rsvd_version = 1;
+	cmd->cqid_pages = num_pages;
+	cmd->cqid_pages |= (cq->id << OCRDMA_CREATE_MQ_CQ_ID_SHIFT);
+	cmd->async_cqid_valid = OCRDMA_CREATE_MQ_ASYNC_CQ_VALID;
+	cmd->async_event_bitmap = Bit(20);
+	cmd->async_cqid_ringsize = cq->id;
+	cmd->async_cqid_ringsize |= (ocrdma_encoded_q_len(mq->len) <<
+				OCRDMA_CREATE_MQ_RING_SIZE_SHIFT);
+	cmd->valid = OCRDMA_CREATE_MQ_VALID;
+	pa = &cmd->pa[0];
+
 	ocrdma_build_q_pages(pa, num_pages, mq->dma, PAGE_SIZE_4K);
 	status = be_roce_mcc_cmd(dev->nic_info.netdev,
 				 cmd, sizeof(*cmd), NULL, NULL);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index c75cbdf..cd0512f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -608,16 +608,8 @@ enum {
 	OCRDMA_CREATE_MQ_ASYNC_CQ_VALID		= Bit(0)
 };
 
-struct ocrdma_create_mq_v0 {
-	u32 pages;
-	u32 cqid_ringsize;
-	u32 valid;
-	u32 async_cqid_valid;
-	u32 rsvd;
-	struct ocrdma_pa pa[8];
-} __packed;
-
-struct ocrdma_create_mq_v1 {
+struct ocrdma_create_mq_req {
+	struct ocrdma_mbx_hdr req;
 	u32 cqid_pages;
 	u32 async_event_bitmap;
 	u32 async_cqid_ringsize;
@@ -627,14 +619,6 @@ struct ocrdma_create_mq_v1 {
 	struct ocrdma_pa pa[8];
 } __packed;
 
-struct ocrdma_create_mq_req {
-	struct ocrdma_mbx_hdr req;
-	union {
-		struct ocrdma_create_mq_v0 v0;
-		struct ocrdma_create_mq_v1 v1;
-	};
-} __packed;
-
 struct ocrdma_create_mq_rsp {
 	struct ocrdma_mbx_rsp rsp;
 	u32 id;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
