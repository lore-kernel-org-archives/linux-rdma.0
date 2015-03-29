From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/18] IB/iser: Remove redundant cmd_data_len calculation
Date: Sun, 29 Mar 2015 15:45:18 +0300
Message-ID: <1427633132-23910-5-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This code was added before we had protection data length
calculation (in iser_send_command), so we needed to calc
the sg data length from the sg itself. This is not needed
anymore.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 341040b..32ccd5c 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -53,12 +53,9 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 	struct scatterlist *sgl = (struct scatterlist *)data->buf;
 	struct scatterlist *sg;
 	char *mem = NULL;
-	unsigned long  cmd_data_len = 0;
+	unsigned long  cmd_data_len = data->data_len;
 	int dma_nents, i;
 
-	for_each_sg(sgl, sg, data->size, i)
-		cmd_data_len += ib_sg_dma_len(dev, sg);
-
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
 		mem = (void *)__get_free_pages(GFP_ATOMIC,
 		      ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
