From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/7] i40iw: Do not free sqbuf when event is I40IW_TIMER_TYPE_CLOSE
Date: Tue, 21 Nov 2017 12:44:58 -0600
Message-ID: <20171121184502.14056-4-henry.orosco@intel.com>
References: <20171121184502.14056-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121184502.14056-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the event type is I40IW_TIMER_TYPE_CLOSE, there is no sqbuf and
it should not be freed as one in i40iw_schedule_cm_timer().

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 493d6ef..e145417 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1043,7 +1043,7 @@ static int i40iw_parse_mpa(struct i40iw_cm_node *cm_node, u8 *buffer, u32 *type,
  * i40iw_schedule_cm_timer
  * @@cm_node: connection's node
  * @sqbuf: buffer to send
- * @type: if it es send ot close
+ * @type: if it is send or close
  * @send_retrans: if rexmits to be done
  * @close_when_complete: is cm_node to be removed
  *
@@ -1067,7 +1067,8 @@ int i40iw_schedule_cm_timer(struct i40iw_cm_node *cm_node,
 
 	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
 	if (!new_send) {
-		i40iw_free_sqbuf(vsi, (void *)sqbuf);
+		if (type != I40IW_TIMER_TYPE_CLOSE)
+			i40iw_free_sqbuf(vsi, (void *)sqbuf);
 		return -ENOMEM;
 	}
 	new_send->retrycount = I40IW_DEFAULT_RETRYS;
@@ -1082,7 +1083,6 @@ int i40iw_schedule_cm_timer(struct i40iw_cm_node *cm_node,
 		new_send->timetosend += (HZ / 10);
 		if (cm_node->close_entry) {
 			kfree(new_send);
-			i40iw_free_sqbuf(vsi, (void *)sqbuf);
 			i40iw_pr_err("already close entry\n");
 			return -EINVAL;
 		}
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
