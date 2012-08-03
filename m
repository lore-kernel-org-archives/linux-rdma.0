From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/ucma.c: Different fix for ucma context uid=0, causing
 iWarp RDMA applications to fail in connection establishment
Date: Fri, 3 Aug 2012 18:59:41 -0500
Message-ID: <20120803235940.GA4912@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for ucma context uid=0, causing iWarp RDMA applications to fail in connection establishment.

This is a new patch addressing the librdmacm segfault when RDMA_CM_EVENT_ESTABLISHED event shows up with evt->id_priv = NULL
In the ucma_event_handler(), ctx->file->mut is moved up to prevent race conditions and protect from assigning zero ucma ctx->uid to asynchronously generated events.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sean Hefty <Sean.Hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 8002ae6..88c50d2 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -267,6 +267,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 	if (!uevent)
 		return event->event == RDMA_CM_EVENT_CONNECT_REQUEST;
 
+	mutex_lock(&ctx->file->mut);
 	uevent->cm_id = cm_id;
 	ucma_set_event_context(ctx, event, uevent);
 	uevent->resp.event = event->event;
@@ -277,7 +278,6 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 		ucma_copy_conn_event(&uevent->resp.param.conn,
 				     &event->param.conn);
 
-	mutex_lock(&ctx->file->mut);
 	if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) {
 		if (!ctx->backlog) {
 			ret = -ENOMEM;
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
