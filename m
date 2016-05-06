From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 03/17] RDMA/iw_cxgb4: set the correct FID value in DSGL commands
Date: Fri,  6 May 2016 22:17:56 +0530
Message-ID: <1462553290-16422-4-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The FID value in a ULP_MEMIO command needs to be set to an IQ ID of
a queue configured for our PF.  The FID/IQ id is used to index into the
PCIE FID table, to find out on which function the DMA needs to be
issued. Essentially, every DMA needs to have the ingress queue. The exact
ingress queue doesn't matter, but it needs to be an ingress queue
associated with the function you want to see the DMA on.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c           | 5 +++--
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 008be07d5604..d495675ea68d 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -86,8 +86,9 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 			(wait ? FW_WR_COMPL_F : 0));
 	req->wr.wr_lo = wait ? (__force __be64)(unsigned long) &wr_wait : 0L;
 	req->wr.wr_mid = cpu_to_be32(FW_WR_LEN16_V(DIV_ROUND_UP(wr_len, 16)));
-	req->cmd = cpu_to_be32(ULPTX_CMD_V(ULP_TX_MEM_WRITE));
-	req->cmd |= cpu_to_be32(T5_ULP_MEMIO_ORDER_V(1));
+	req->cmd = cpu_to_be32(ULPTX_CMD_V(ULP_TX_MEM_WRITE) |
+			       T5_ULP_MEMIO_ORDER_V(1) |
+			       T5_ULP_MEMIO_FID_V(rdev->lldi.rxq_ids[0]));
 	req->dlen = cpu_to_be32(ULP_MEMIO_DATA_LEN_V(len>>5));
 	req->len16 = cpu_to_be32(DIV_ROUND_UP(wr_len-sizeof(req->wr), 16));
 	req->lock_addr = cpu_to_be32(ULP_MEMIO_ADDR_V(addr));
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 80417fc564d4..4705e2dea423 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -1392,6 +1392,10 @@ struct ulp_mem_io {
 #define T5_ULP_MEMIO_ORDER_V(x) ((x) << T5_ULP_MEMIO_ORDER_S)
 #define T5_ULP_MEMIO_ORDER_F    T5_ULP_MEMIO_ORDER_V(1U)
 
+#define T5_ULP_MEMIO_FID_S	4
+#define T5_ULP_MEMIO_FID_M	0x7ff
+#define T5_ULP_MEMIO_FID_V(x)	((x) << T5_ULP_MEMIO_FID_S)
+
 /* ulp_mem_io.lock_addr fields */
 #define ULP_MEMIO_ADDR_S    0
 #define ULP_MEMIO_ADDR_V(x) ((x) << ULP_MEMIO_ADDR_S)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
