From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] opensm: Outgoing responses can be significantly delayed by
 requests
Date: Fri, 30 Aug 2013 01:09:12 -0700 (PDT)
Message-ID: <81659855-ed1b-4c3d-9310-f9669e8bc507@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The vl15 poller thread will pause sending SMPs if the max_wire_smps
limit is reached, waiting for active transactions to complete. If there
are unresponsive port(s) in the fabric then any requests towards these
port(s) will stay on the queue until it has timed out.

If the queue is full this will also block outgoing responses. The SM
does not control the timeout on the requester side so this might cause
retries and potential timeouts from the remote end.

With this change any SMP responses will wake up the vl15 poller and
be sent out even though the max limit is reached.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 

---

diff --git a/include/opensm/osm_vl15intf.h b/include/opensm/osm_vl15intf.h
index e621c68..717f8d5 100644
--- a/include/opensm/osm_vl15intf.h
+++ b/include/opensm/osm_vl15intf.h
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -327,12 +328,15 @@ void osm_vl15_post(IN osm_vl15_t * p_vl15, IN osm_madw_t * p_madw);
 *
 * SYNOPSIS
 */
-void osm_vl15_poll(IN osm_vl15_t * p_vl);
+void osm_vl15_poll(IN osm_vl15_t * p_vl, IN boolean_t is_respons);
 /*
 * PARAMETERS
 *	p_vl15
 *		[in] Pointer to an osm_vl15_t object.
 *
+*	is_respons
+*		[in] If TRUE, the poller thread will always be signalled.
+*
 * RETURN VALUES
 *	None.
 *
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index 11195e8..05f9931 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -4,6 +4,7 @@
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -165,7 +166,7 @@ static void sm_mad_ctrl_update_wire_stats(IN osm_sm_mad_ctrl_t * p_ctrl)
 	   We can signal the VL15 controller to send another MAD
 	   if any are waiting for transmission.
 	 */
-	osm_vl15_poll(p_ctrl->p_vl15);
+	osm_vl15_poll(p_ctrl->p_vl15, FALSE);
 	OSM_LOG_EXIT(p_ctrl->p_log);
 }
 
diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index f85252c..9b2a5cc 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -118,6 +119,7 @@ static void vl15_poller(IN void *p_ptr)
 	cl_qlist_t *p_fifo;
 	int32_t max_smps = p_vl->max_wire_smps;
 	int32_t max_smps2 = p_vl->max_wire_smps2;
+	uint32_t num_in_ufifo;
 
 	OSM_LOG_ENTER(p_vl->p_log);
 
@@ -135,7 +137,8 @@ static void vl15_poller(IN void *p_ptr)
 		 */
 		cl_spinlock_acquire(&p_vl->lock);
 
-		if (cl_qlist_count(&p_vl->ufifo) != 0)
+		num_in_ufifo = cl_qlist_count(&p_vl->ufifo);
+		if (num_in_ufifo != 0)
 			p_fifo = &p_vl->ufifo;
 		else
 			p_fifo = &p_vl->rfifo;
@@ -161,6 +164,7 @@ static void vl15_poller(IN void *p_ptr)
 						  EVENT_NO_TIMEOUT, TRUE);
 
 		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >= max_smps &&
+		       num_in_ufifo <= 1 &&
 		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
 			status = cl_event_wait_on(&p_vl->signal,
 						  p_vl->max_smps_timeout,
@@ -176,6 +180,10 @@ static void vl15_poller(IN void *p_ptr)
 				break;
 			}
 			max_smps = p_vl->max_wire_smps;
+
+			/* Check if there are any new responses to send */
+			if (cl_qlist_count(&p_vl->ufifo) != 0)
+				break;
 		}
 	}
 
@@ -283,7 +291,7 @@ Exit:
 	return status;
 }
 
-void osm_vl15_poll(IN osm_vl15_t * p_vl)
+void osm_vl15_poll(IN osm_vl15_t * p_vl, IN boolean_t is_respons)
 {
 	OSM_LOG_ENTER(p_vl->p_log);
 
@@ -299,7 +307,8 @@ void osm_vl15_poll(IN osm_vl15_t * p_vl)
 	   thread checks for a spurious wake-up.
 	 */
 	if (p_vl->p_stats->qp0_mads_outstanding_on_wire <
-	    (int32_t) p_vl->max_wire_smps) {
+	    (int32_t) p_vl->max_wire_smps ||
+	    is_respons) {
 		OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
 			"Signalling poller thread\n");
 		cl_event_signal(&p_vl->signal);
@@ -310,6 +319,8 @@ void osm_vl15_poll(IN osm_vl15_t * p_vl)
 
 void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
 {
+	boolean_t is_respons;
+
 	OSM_LOG_ENTER(p_vl->p_log);
 
 	CL_ASSERT(p_vl->state == OSM_VL15_STATE_READY);
@@ -323,8 +334,11 @@ void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
 	if (p_madw->resp_expected == TRUE) {
 		cl_qlist_insert_tail(&p_vl->rfifo, &p_madw->list_item);
 		osm_stats_inc_qp0_outstanding(p_vl->p_stats);
-	} else
+		is_respons = FALSE;
+	} else {
 		cl_qlist_insert_tail(&p_vl->ufifo, &p_madw->list_item);
+		is_respons = TRUE;
+	}
 	cl_spinlock_release(&p_vl->lock);
 
 	OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
@@ -332,7 +346,7 @@ void osm_vl15_post(IN osm_vl15_t * p_vl, IN osm_madw_t * p_madw)
 		p_vl->p_stats->qp0_mads_outstanding_on_wire,
 		p_vl->p_stats->qp0_mads_outstanding);
 
-	osm_vl15_poll(p_vl);
+	osm_vl15_poll(p_vl, is_respons);
 
 	OSM_LOG_EXIT(p_vl->p_log);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
