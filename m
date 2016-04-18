From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 04/16] RDMA/i40iw: Correct max message size in query port
Date: Mon, 18 Apr 2016 10:32:57 -0500
Message-ID: <1460993589-9428-5-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix to correct max reported message size in query port.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 329f59a..2534c5d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -120,7 +120,7 @@ static int i40iw_query_port(struct ib_device *ibdev,
 	props->pkey_tbl_len = 1;
 	props->active_width = IB_WIDTH_4X;
 	props->active_speed = 1;
-	props->max_msg_sz = 0x80000000;
+	props->max_msg_sz = I40IW_MAX_OUTBOUND_MESSAGE_SIZE;
 	return 0;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
