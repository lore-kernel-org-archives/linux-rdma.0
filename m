From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] rdma/cm: Discard events for IDs not yet claimed by user space
Date: Fri,  1 Nov 2013 14:39:50 -0700
Message-ID: <1383341990-4055-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Problem reported by Avneesh Pant <avneesh.pant-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:

>>
It looks like we are triggering a bug in RDMA CM/UCM interaction.
The bug specifically hits when we have an incoming connection request
and the connecting process dies BEFORE the passive end of the
connection can process the request i.e. it does not call
rdma_get_cm_event() to retrieve the initial connection event.
We were able to triage this further and have some additional
information now.

In the example below when P1 dies after issuing a connect request
as the CM id is being destroyed all outstanding connects (to P2)
are sent a reject message. We see this reject message being
received on the passive end and the appropriate CM ID created for
the initial connection message being retrieved in cm_match_req().
The problem is in the ucma_event_handler() code when this reject
message is delivered to it and the initial connect message itself
HAS NOT been delivered to the client. In fact the client has not
even called rdma_cm_get_event() at this stage so we haven't
allocated a new ctx in ucma_get_event() and updated the new
connection CM_ID to point to the new UCMA context.

This results in the reject message not being dropped in
ucma_event_handler() for the new connection request as the
(if (!ctx->uid)) block is skipped since the ctx it refers to is
the listen CM id context which does have a valid UID associated
with it (I believe the new CMID for the connection initially
uses the listen CMID -> context when it is created in
cma_new_conn_id). Thus the assumption that new events for a
connection can get dropped in ucma_event_handler() is incorrect
IF the initial connect request has not been retrieved in the
first case. We end up getting a CM Reject event on the listen CM
ID and our upper layer code asserts (in fact this event does not
even have the listen_id set as that only gets set up librdmacm
for connect requests).
<<

The solution is to verify that the cm_id being reported in the
event is the same as the cm_id referenced by the ucma context.
A mismatch indicates that the ucma context corresponds to the
listen.  This fix was validated by using a modified version of
the librdmacm that was able to verify the problem and see that
the reject message was indeed dropped after this patch was applied.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..826016b 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -271,7 +271,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 			goto out;
 		}
 		ctx->backlog--;
-	} else if (!ctx->uid) {
+	} else if (!ctx->uid || ctx->cm_id != cm_id) {
 		/*
 		 * We ignore events for new connections until userspace has set
 		 * their context.  This can only happen if an error occurs on a
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
