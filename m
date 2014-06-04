From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 11/15] RDMA/ocrdma: Return proper value for max_mr_size
Date: Wed, 4 Jun 2014 23:49:11 +0530
Message-ID: <21d032d7-bf16-4864-b66c-e4bf54422430@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-3-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-4-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-5-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-6-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-7-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-8-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-9-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-10-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-11-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-11-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 5b6e9d9..105659d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1088,7 +1088,8 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT;
 	attr->max_mw = rsp->max_mw;
 	attr->max_mr = rsp->max_mr;
-	attr->max_mr_size = ~0ull;
+	attr->max_mr_size = ((u64)rsp->max_mr_size_hi << 32) |
+			      rsp->max_mr_size_lo;
 	attr->max_fmr = 0;
 	attr->max_pages_per_frmr = rsp->max_pages_per_frmr;
 	attr->max_num_mr_pbl = rsp->max_num_mr_pbl;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 14a84b2..3cb88f0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -530,8 +530,8 @@ struct ocrdma_mbx_query_config {
 	u32 max_ird_ord_per_qp;
 	u32 max_shared_ird_ord;
 	u32 max_mr;
-	u32 max_mr_size_lo;
 	u32 max_mr_size_hi;
+	u32 max_mr_size_lo;
 	u32 max_num_mr_pbl;
 	u32 max_mw;
 	u32 max_fmr;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8cd16a1..90152de 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -69,7 +69,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	memcpy(&attr->fw_ver, &dev->attr.fw_ver[0],
 	       min(sizeof(dev->attr.fw_ver), sizeof(attr->fw_ver)));
 	ocrdma_get_guid(dev, (u8 *)&attr->sys_image_guid);
-	attr->max_mr_size = ~0ull;
+	attr->max_mr_size = dev->attr.max_mr_size;
 	attr->page_size_cap = 0xffff000;
 	attr->vendor_id = dev->nic_info.pdev->vendor;
 	attr->vendor_part_id = dev->nic_info.pdev->device;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
