From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/02] RDMA/nes: listener destroyed during loopback setup crash
Date: Fri, 12 Feb 2010 13:57:04 -0600
Message-ID: <20100212195704.GA71688@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, -c@vger.kernel.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When listener is destroyed and where is MPA response pending for
loopback connection, the active side cm_node gets destroyed in
cm_event_connect_error() and again in nes_accept()/nes_reject().
Incrementing cm_node's refcount to not be destroyed by cm_event_connect_error().

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index debd92c..2a49ee4 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1011,9 +1011,10 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 					event.cm_info.loc_port =
 							 loopback->loc_port;
 					event.cm_info.cm_id = loopback->cm_id;
+					add_ref_cm_node(loopback);
+					loopback->state = NES_CM_STATE_CLOSED;
 					cm_event_connect_error(&event);
 					cm_node->state = NES_CM_STATE_LISTENER_DESTROYED;
-					loopback->state = NES_CM_STATE_CLOSED;
 
 					rem_ref_cm_node(cm_node->cm_core,
 							 cm_node);
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
