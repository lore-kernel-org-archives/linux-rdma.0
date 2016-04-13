From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 12/16] RDMA/i40iw: Initialize max enabled vfs variable
Date: Wed, 13 Apr 2016 09:30:48 -0500
Message-ID: <1460557852-10824-13-git-send-email-mustafa.ismail@intel.com>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Initialize max enabled vfs to max rdma vfs instead of 0.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 9cf5b3e..e7b7724 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1509,6 +1509,7 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 	    I40IW_HMC_PROFILE_DEFAULT;
 	iwdev->max_rdma_vfs =
 		(iwdev->resource_profile != I40IW_HMC_PROFILE_DEFAULT) ?  max_rdma_vfs : 0;
+	iwdev->max_enabled_vfs = iwdev->max_rdma_vfs;
 	iwdev->netdev = ldev->netdev;
 	hdl->client = client;
 	iwdev->mss = (!ldev->params.mtu) ? I40IW_DEFAULT_MSS : ldev->params.mtu - I40IW_MTU_TO_MSS;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
