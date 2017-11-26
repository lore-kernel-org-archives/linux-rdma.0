From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/vmw_pvrdma: Do not re-calculate npages
Date: Sun, 26 Nov 2017 13:51:35 +0200
Message-ID: <20171126115135.5824-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no need to re-calculate the number of pages since it is already
done in ib_umem_get.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
index 8519f3212e52..fa96fa4fb829 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
@@ -119,10 +119,7 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	union pvrdma_cmd_resp rsp;
 	struct pvrdma_cmd_create_mr *cmd = &req.create_mr;
 	struct pvrdma_cmd_create_mr_resp *resp = &rsp.create_mr_resp;
-	int nchunks;
 	int ret;
-	int entry;
-	struct scatterlist *sg;
 
 	if (length == 0 || length > dev->dsr->caps.max_mr_size) {
 		dev_warn(&dev->pdev->dev, "invalid mem region length\n");
@@ -137,13 +134,9 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_CAST(umem);
 	}
 
-	nchunks = 0;
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry)
-		nchunks += sg_dma_len(sg) >> PAGE_SHIFT;
-
-	if (nchunks < 0 || nchunks > PVRDMA_PAGE_DIR_MAX_PAGES) {
+	if (umem->npages < 0 || umem->npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
 		dev_warn(&dev->pdev->dev, "overflow %d pages in mem region\n",
-			 nchunks);
+			 umem->npages);
 		ret = -EINVAL;
 		goto err_umem;
 	}
@@ -158,7 +151,7 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->mmr.size = length;
 	mr->umem = umem;
 
-	ret = pvrdma_page_dir_init(dev, &mr->pdir, nchunks, false);
+	ret = pvrdma_page_dir_init(dev, &mr->pdir, umem->npages, false);
 	if (ret) {
 		dev_warn(&dev->pdev->dev,
 			 "could not allocate page directory\n");
@@ -175,7 +168,7 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	cmd->length = length;
 	cmd->pd_handle = to_vpd(pd)->pd_handle;
 	cmd->access_flags = access_flags;
-	cmd->nchunks = nchunks;
+	cmd->nchunks = umem->npages;
 	cmd->pdir_dma = mr->pdir.dir_dma;
 
 	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_MR_RESP);
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
