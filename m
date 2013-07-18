From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.11 1/7] IB/iser: Use proper debug level value for info prints
Date: Thu, 18 Jul 2013 16:25:25 +0300
Message-ID: <1374153931-7313-2-git-send-email-ogerlitz@mellanox.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374153931-7313-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 4f363882612 "IB/iser: Move informational messages from error to info level"
was setting info prints to require lower value for the debug level vs warning prints
which isn't the common convention, fix that. Also move the prints on unaligned SG
from warning to debug level.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    4 ++--
 drivers/infiniband/ulp/iser/iser_memory.c |   13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 4f069c0..d694bcd 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -78,14 +78,14 @@
 
 #define iser_warn(fmt, arg...)				\
 	do {						\
-		if (iser_debug_level > 1)		\
+		if (iser_debug_level > 0)		\
 			pr_warn(PFX "%s:" fmt,          \
 				__func__ , ## arg);	\
 	} while (0)
 
 #define iser_info(fmt, arg...)				\
 	do {						\
-		if (iser_debug_level > 0)		\
+		if (iser_debug_level > 1)		\
 			pr_info(PFX "%s:" fmt,          \
 				__func__ , ## arg);	\
 	} while (0)
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 7827baf..797e49f 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -267,11 +267,8 @@ static void iser_data_buf_dump(struct iser_data_buf *data,
 	struct scatterlist *sg;
 	int i;
 
-	if (iser_debug_level == 0)
-		return;
-
 	for_each_sg(sgl, sg, data->dma_nents, i)
-		iser_warn("sg[%d] dma_addr:0x%lX page:0x%p "
+		iser_dbg("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
 			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
 			 sg_page(sg), sg->offset,
@@ -373,9 +370,11 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 	if (aligned_len != mem->dma_nents ||
 	    (!ib_conn->fmr_pool && mem->dma_nents > 1)) {
 		iscsi_conn->fmr_unalign_cnt++;
-		iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
-			  aligned_len, mem->size);
-		iser_data_buf_dump(mem, ibdev);
+		iser_dbg("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
+			 aligned_len, mem->size);
+
+		if (iser_debug_level > 0)
+			iser_data_buf_dump(mem, ibdev);
 
 		/* unmap the command data before accessing it */
 		iser_dma_unmap_task_data(iser_task);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
