From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Remove NULL check for cm_node->iwdev
Date: Wed,  9 Nov 2016 21:32:25 -0600
Message-ID: <20161110033225.18708-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is not necessary to check cm_node->iwdev in
i40iw_rem_ref_cm_node() as it can never be NULL after
a successful call out of i40iw_make_cm_node().

Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index c5e3d7a..71f2452 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2224,7 +2224,7 @@ static void i40iw_rem_ref_cm_node(struct i40iw_cm_node *cm_node)
 		i40iw_dec_refcnt_listen(cm_core, cm_node->listener, 0, true);
 	} else {
 		if (!i40iw_listen_port_in_use(cm_core, cm_node->loc_port) &&
-		    cm_node->apbvt_set && cm_node->iwdev) {
+		    cm_node->apbvt_set) {
 			i40iw_manage_apbvt(cm_node->iwdev,
 					   cm_node->loc_port,
 					   I40IW_MANAGE_APBVT_DEL);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
