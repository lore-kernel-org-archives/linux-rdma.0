From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] i40iw: Update list correctly
Date: Fri, 23 Jun 2017 16:04:01 -0500
Message-ID: <20170623210402.19988-8-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To avoid infinite loop, in i40iw_ieq_handle_exception, update
plist inside while loop.

Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index 1bb1681..71050c5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -1414,10 +1414,10 @@ static void i40iw_ieq_handle_exception(struct i40iw_puda_rsrc *ieq,
 
 	if (!list_empty(rxlist)) {
 		tmpbuf = (struct i40iw_puda_buf *)rxlist->next;
-		plist = &tmpbuf->list;
 		while ((struct list_head *)tmpbuf != rxlist) {
 			if ((int)(buf->seqnum - tmpbuf->seqnum) < 0)
 				break;
+			plist = &tmpbuf->list;
 			tmpbuf = (struct i40iw_puda_buf *)plist->next;
 		}
 		/* Insert buf before tmpbuf */
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
