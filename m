From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vl15intf.c: In vl15_poller, drain unicast even
	if max_wire_smps are outstanding
Date: Tue, 20 Oct 2009 09:41:17 -0400
Message-ID: <20091020134117.GB5440@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Unicast sends should not be blocked by waiting transactions.
In this case (one example is timeouts due to rebooting nodes),
this can cause trap represses to be delayed (which is not a good thing).

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index 9e43a9c..07a2336 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -115,6 +116,7 @@ static void vl15_poller(IN void *p_ptr)
 	osm_madw_t *p_madw;
 	osm_vl15_t *p_vl = p_ptr;
 	cl_qlist_t *p_fifo;
+	uint32_t ufifo_count = 0;
 
 	OSM_LOG_ENTER(p_vl->p_log);
 
@@ -132,10 +134,15 @@ static void vl15_poller(IN void *p_ptr)
 		 */
 		cl_spinlock_acquire(&p_vl->lock);
 
-		if (cl_qlist_count(&p_vl->ufifo) != 0)
+		if (ufifo_count)
 			p_fifo = &p_vl->ufifo;
-		else
-			p_fifo = &p_vl->rfifo;
+		else {
+			ufifo_count = cl_qlist_count(&p_vl->ufifo);
+			if (ufifo_count != 0)
+				p_fifo = &p_vl->ufifo;
+			else
+				p_fifo = &p_vl->rfifo;
+		}
 
 		p_madw = (osm_madw_t *) cl_qlist_remove_head(p_fifo);
 
@@ -157,7 +164,14 @@ static void vl15_poller(IN void *p_ptr)
 			status = cl_event_wait_on(&p_vl->signal,
 						  EVENT_NO_TIMEOUT, TRUE);
 
-		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >=
+		if (ufifo_count) {
+			cl_spinlock_acquire(&p_vl->lock);
+                	ufifo_count = cl_qlist_count(&p_vl->ufifo);
+			cl_spinlock_release(&p_vl->lock);
+		}
+
+		while (!ufifo_count &&
+		       p_vl->p_stats->qp0_mads_outstanding_on_wire >=
 		       (int32_t) p_vl->max_wire_smps &&
 		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
 			status = cl_event_wait_on(&p_vl->signal,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
