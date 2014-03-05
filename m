From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sm_state_mgr.c: Fix opensm crash after handover
Date: Wed, 05 Mar 2014 13:49:07 -0500
Message-ID: <531771A3.1090906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 8 Apr 2013 20:09:23 +0300

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sm_state_mgr.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 5e4b06a..2c26d38 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -1,6 +1,6 @@
 /*
+ * Copyright (c) 2002-2013 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2013, Oracle and/or its affiliates. All rights reserved.
  *
@@ -297,15 +297,17 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * Update the state of the SM to MASTER
 			 */
 			/* Turn on the first_time_master_sweep flag */
-			sm->p_subn->first_time_master_sweep = TRUE;
 			sm->p_subn->sm_state = IB_SMINFO_STATE_MASTER;
 			osm_report_sm_state(sm);
 			/*
 			 * Make sure to set the subnet master_sm_base_lid
 			 * to the sm_base_lid value
 			 */
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+			sm->p_subn->first_time_master_sweep = TRUE;
 			sm->p_subn->master_sm_base_lid =
 			    sm->p_subn->sm_base_lid;
+			CL_PLOCK_RELEASE(sm->p_lock)
 			break;
 		case OSM_SM_SIGNAL_MASTER_OR_HIGHER_SM_DETECTED:
 			/*
@@ -318,8 +320,9 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * Since another SM is doing the LFT config - we should not
 			 * ignore the results of it
 			 */
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 			sm->p_subn->ignore_existing_lfts = FALSE;
-
+			CL_PLOCK_RELEASE(sm->p_lock);
 			sm_state_mgr_start_polling(sm);
 			break;
 		case OSM_SM_SIGNAL_HANDOVER:
@@ -351,7 +354,9 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			sm->p_subn->sm_state = IB_SMINFO_STATE_DISCOVERING;
 			osm_report_sm_state(sm);
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 			sm->p_subn->coming_out_of_standby = TRUE;
+			CL_PLOCK_RELEASE(sm->p_lock);
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
 		case OSM_SM_SIGNAL_DISABLE:
@@ -367,6 +372,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * OPTIONAL: send ACKNOWLEDGE
 			 */
 			/* Turn on the first_time_master_sweep flag */
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 			sm->p_subn->first_time_master_sweep = TRUE;
 			/*
 			 * Turn on the force_heavy_sweep - we want a
@@ -374,15 +380,19 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			sm->p_subn->force_heavy_sweep = TRUE;
 
-			sm->p_subn->sm_state = IB_SMINFO_STATE_MASTER;
-			osm_report_sm_state(sm);
 			/*
 			 * Make sure to set the subnet master_sm_base_lid
 			 * to the sm_base_lid value
 			 */
 			sm->p_subn->master_sm_base_lid =
 			    sm->p_subn->sm_base_lid;
+
 			sm->p_subn->coming_out_of_standby = TRUE;
+
+			CL_PLOCK_RELEASE(sm->p_lock);
+
+			sm->p_subn->sm_state = IB_SMINFO_STATE_MASTER;
+			osm_report_sm_state(sm);
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
 		case OSM_SM_SIGNAL_ACKNOWLEDGE:
@@ -448,11 +458,13 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			/* Force set_client_rereg_on_sweep, we don't know what the other
 			 * SM may have configure/done on the fabric.
 			 */
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 			sm->p_subn->set_client_rereg_on_sweep = TRUE;
 			sm->polling_sm_guid = 0;
 			sm->p_subn->first_time_master_sweep = TRUE;
 			sm->p_subn->coming_out_of_standby = TRUE;
 			sm->p_subn->force_heavy_sweep = TRUE;
+			CL_PLOCK_RELEASE(sm->p_lock);
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
 		case OSM_SM_SIGNAL_HANDOVER_SENT:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
