From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/11] RDMA/nes: abnormal listener termination causes loopback node crash
Date: Wed, 9 Dec 2009 16:41:15 -0600
Message-ID: <20091209224115.GA128120@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

when listener is destroyed for loopback connection, listener node is
getting reset event. This causes crash as listener is not expecting
reset event. Code review of cm_event_reset() durring debugging showed
the cm_id ref count in incrementing after calling its event handler
and not before.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index ec04786..20e21f1 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1014,18 +1014,6 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 					cm_node->state = NES_CM_STATE_LISTENER_DESTROYED;
 					loopback->state = NES_CM_STATE_CLOSED;
 
-					event.cm_node = cm_node;
-					event.cm_info.rem_addr =
-							 cm_node->rem_addr;
-					event.cm_info.loc_addr =
-							 cm_node->loc_addr;
-					event.cm_info.rem_port =
-							 cm_node->rem_port;
-					event.cm_info.loc_port =
-							 cm_node->loc_port;
-					event.cm_info.cm_id = cm_node->cm_id;
-					cm_event_reset(&event);
-
 					rem_ref_cm_node(cm_node->cm_core,
 							 cm_node);
 
@@ -3440,6 +3428,8 @@ static void cm_event_reset(struct nes_cm_event *event)
 
 	nes_debug(NES_DBG_CM, "%p - cm_id = %p\n", event->cm_node, cm_id);
 	nesqp = cm_id->provider_data;
+	if (!nesqp)
+		return;
 
 	nesqp->cm_id = NULL;
 	/* cm_id->provider_data = NULL; */
@@ -3451,8 +3441,8 @@ static void cm_event_reset(struct nes_cm_event *event)
 	cm_event.private_data = NULL;
 	cm_event.private_data_len = 0;
 
-	ret = cm_id->event_handler(cm_id, &cm_event);
 	cm_id->add_ref(cm_id);
+	ret = cm_id->event_handler(cm_id, &cm_event);
 	atomic_inc(&cm_closes);
 	cm_event.event = IW_CM_EVENT_CLOSE;
 	cm_event.status = IW_CM_EVENT_STATUS_OK;
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
