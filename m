From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/9] ib/core: Add GID change event
Date: Wed, 15 Jun 2011 17:39:29 +0300
Message-ID: <alpine.LRH.2.00.1106151739060.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add IB GID change event. This is needed for IBoE when the HW driver
updates the GID (e.g when new vlans are added/deleted) table and the
change should be reflected to the IB core cache.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/cache.c |    3 ++-
 include/rdma/ib_verbs.h         |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/infiniband/core/cache.c
===================================================================
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -302,7 +302,8 @@ static void ib_cache_event(struct ib_eve
 	    event->event == IB_EVENT_LID_CHANGE  ||
 	    event->event == IB_EVENT_PKEY_CHANGE ||
 	    event->event == IB_EVENT_SM_CHANGE   ||
-	    event->event == IB_EVENT_CLIENT_REREGISTER) {
+	    event->event == IB_EVENT_CLIENT_REREGISTER ||
+	    event->event == IB_EVENT_GID_CHANGE) {
 		work = kmalloc(sizeof *work, GFP_ATOMIC);
 		if (work) {
 			INIT_WORK(&work->work, ib_cache_task);
Index: b/include/rdma/ib_verbs.h
===================================================================
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -350,7 +350,8 @@ enum ib_event_type {
 	IB_EVENT_SRQ_ERR,
 	IB_EVENT_SRQ_LIMIT_REACHED,
 	IB_EVENT_QP_LAST_WQE_REACHED,
-	IB_EVENT_CLIENT_REREGISTER
+	IB_EVENT_CLIENT_REREGISTER,
+	IB_EVENT_GID_CHANGE,
 };

 struct ib_event {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
