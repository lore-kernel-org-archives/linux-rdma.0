From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 07/15] RDMA/ocrdma: Delete AH table if ocrdma_init_hw fails after AH table creation
Date: Wed, 4 Jun 2014 23:49:07 +0530
Message-ID: <649cd2ec-f10c-4c01-8987-d18effcd5075@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-3-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-4-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-5-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-6-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-7-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-7-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index e6463cb..55308b6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1505,6 +1505,7 @@ static void ocrdma_mbx_delete_ah_tbl(struct ocrdma_dev *dev)
 	ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	dma_free_coherent(&pdev->dev, dev->av_tbl.size, dev->av_tbl.va,
 			  dev->av_tbl.pa);
+	dev->av_tbl.va = NULL;
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->av_tbl.pbl.va,
 			  dev->av_tbl.pbl.pa);
 	kfree(cmd);
@@ -2882,13 +2883,15 @@ int ocrdma_init_hw(struct ocrdma_dev *dev)
 		goto conf_err;
 	status = ocrdma_mbx_get_phy_info(dev);
 	if (status)
-		goto conf_err;
+		goto info_attrb_err;
 	status = ocrdma_mbx_get_ctrl_attribs(dev);
 	if (status)
-		goto conf_err;
+		goto info_attrb_err;
 
 	return 0;
 
+info_attrb_err:
+	ocrdma_mbx_delete_ah_tbl(dev);
 conf_err:
 	ocrdma_destroy_mq(dev);
 mq_err:
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
