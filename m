From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 08/16] RDMA/i40iw: Populate vendor_id and vendor_part_id fields
Date: Mon, 18 Apr 2016 10:33:01 -0500
Message-ID: <1460993589-9428-9-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Populate PCI info fields from PCI device structure.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index d3b4b58..40444c0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -63,8 +63,8 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	ether_addr_copy((u8 *)&props->sys_image_guid, iwdev->netdev->dev_addr);
 	props->fw_ver = I40IW_FW_VERSION;
 	props->device_cap_flags = iwdev->device_cap_flags;
-	props->vendor_id = iwdev->vendor_id;
-	props->vendor_part_id = iwdev->vendor_part_id;
+	props->vendor_id = iwdev->ldev->pcidev->vendor;
+	props->vendor_part_id = iwdev->ldev->pcidev->device;
 	props->hw_ver = (u32)iwdev->sc_dev.hw_rev;
 	props->max_mr_size = I40IW_MAX_OUTBOUND_MESSAGE_SIZE;
 	props->max_qp = iwdev->max_qp;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
