From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2][RESEND] opensm/osm_vl15intf.c: In vl15_poller, drain
	unicast even if max_wire_smps outstanding
Date: Wed, 30 Jun 2010 09:00:48 -0400
Message-ID: <20100630130048.GA22992@comcast.net>
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
Changes since v1:
Rebased

diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index bb2c0c6..a343227 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -115,6 +116,7 @@ static void vl15_poller(IN void *p_ptr)
 	cl_qlist_t *p_fifo;
 	int32_t max_smps = p_vl->max_wire_smps;
 	int32_t max_smps2 = p_vl->max_wire_smps2;
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
 
@@ -157,7 +164,13 @@ static void vl15_poller(IN void *p_ptr)
 			status = cl_event_wait_on(&p_vl->signal,
 						  EVENT_NO_TIMEOUT, TRUE);
 
-		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >= max_smps &&
+		if (ufifo_count) {
+			cl_spinlock_acquire(&p_vl->lock);
+			ufifo_count = cl_qlist_count(&p_vl->ufifo);
+			cl_spinlock_release(&p_vl->lock);
+		}
+		while (!ufifo_count &&
+		       p_vl->p_stats->qp0_mads_outstanding_on_wire >= max_smps &&
 		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
 			status = cl_event_wait_on(&p_vl->signal,
 						  p_vl->max_smps_timeout,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
