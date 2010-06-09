From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv3] opensm: Better handling of non responsive SMAs
Date: Wed, 9 Jun 2010 14:29:11 -0400
Message-ID: <20100609182911.GA26769@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In order to better handle non responsive SMAs (when link is physically up
but the SMA does not respond), a timeout based mechanism for SMPs is added
to better enable forward progress in a more timely fashion. So rather than
waiting for timeouts and outstanding wire SMPs to drop below some configured
value, there is also an additional limit introduced for transaction based SMPs.
These timeout based SMPs are capped at a configured maximum value.

Two new options are added for this:
max_wire_smps2 indicates the second (higher) limit of timeout based
SMPs supported. When this limit is reached, timeout based SMPs
are not longer sent (until the number of outstanding ones drops below
this limit).
max_smps_timeout indicates the number of microseconds used for the
timeout in between sending SMPs when the oustanding wire count is above
max_wire_smps and below max_wire_smps2. It defaults to the transaction
timeout times the transaction retries.

The timeout based SMP mechanism can be disabled by setting max_wire_smps2 
to the same value as max_wire_smps. This is equivalent to the (current)
algorithm prior to this change. By default, this mechanism is disabled.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes from v2:
Change config options to be max_wire_smps2 and max_smps_timeout
Updated patch title and description to move from rate based to timeout based

Changes from v1:
Algorithm change is isolated to vl15_poller rather than involving
the vendor layer.

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 4e8c862..95a635c 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -149,6 +149,8 @@ typedef struct osm_subn_opt {
 	ib_net16_t m_key_lease_period;
 	uint32_t sweep_interval;
 	uint32_t max_wire_smps;
+	uint32_t max_wire_smps2;
+	uint32_t max_smps_timeout;
 	uint32_t transaction_timeout;
 	uint32_t transaction_retries;
 	uint8_t sm_priority;
@@ -264,6 +266,15 @@ typedef struct osm_subn_opt {
 *	max_wire_smps
 *		The maximum number of SMPs sent in parallel.  Default is 4.
 *
+*	max_wire_smps2
+*		The maximum number of timeout SMPs allowed to be outstanding.
+*		Default is same as max_wire_smps which disables the timeout
+*		mechanism.
+*
+*	max_smps_timeout
+*		The wait time in usec for timeout based SMPs.  Default is
+*		timeout * retries.
+*
 *	transaction_timeout
 *		The maximum time in milliseconds allowed for a transaction
 *		to complete.  Default is 200.
diff --git a/opensm/include/opensm/osm_vl15intf.h b/opensm/include/opensm/osm_vl15intf.h
index 15ed56c..e621c68 100644
--- a/opensm/include/opensm/osm_vl15intf.h
+++ b/opensm/include/opensm/osm_vl15intf.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -117,6 +117,8 @@ typedef struct osm_vl15 {
 	osm_thread_state_t thread_state;
 	osm_vl15_state_t state;
 	uint32_t max_wire_smps;
+	uint32_t max_wire_smps2;
+	uint32_t max_smps_timeout;
 	cl_event_t signal;
 	cl_thread_t poller;
 	cl_qlist_t rfifo;
@@ -137,6 +139,12 @@ typedef struct osm_vl15 {
 *	max_wire_smps
 *		Maximum number of VL15 MADs allowed on the wire at one time.
 *
+*	max_wire_smps2
+*		Maximum number of timeout based SMPs allowed to be outstanding.
+*
+*	max_smps_timeout
+*		Wait time in usec for timeout based SMPs.
+*
 *	signal
 *		Event on which the poller sleeps.
 *
@@ -243,7 +251,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl15, IN struct osm_mad_pool *p_pool);
 */
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
-			      IN int32_t max_wire_smps);
+			      IN int32_t max_wire_smps,
+			      IN int32_t max_wire_smps2,
+			      IN uint32_t max_smps_timeout);
 /*
 * PARAMETERS
 *	p_vl15
@@ -259,7 +269,15 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
 *		[in] Pointer to the OpenSM stastics block.
 *
 *	max_wire_smps
-*		[in] Maximum number of MADs allowed on the wire at one time.
+*		[in] Maximum number of SMPs allowed on the wire at one time.
+*
+*	max_wire_smps2
+*		[in] Maximum number of timeout based SMPs allowed to be
+*		     outstanding.
+*
+*	max_smps_timeout
+*		[in] Wait time in usec for timeout based SMPs.
+*
 *
 * RETURN VALUES
 *	IB_SUCCESS if the VL15 object was initialized successfully.
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index d0f39da..d3dc02e 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -392,7 +392,8 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 
 	status = osm_vl15_init(&p_osm->vl15, p_osm->p_vendor,
 			       &p_osm->log, &p_osm->stats,
-			       p_opt->max_wire_smps);
+			       p_opt->max_wire_smps, p_opt->max_wire_smps2,
+			       p_opt->max_smps_timeout);
 	if (status != IB_SUCCESS)
 		goto Exit;
 
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index ba2c812..d5c5ab2 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -297,6 +297,8 @@ static const opt_rec_t opt_tbl[] = {
 	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
 	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
+	{ "max_wire_smps2", OPT_OFFSET(max_wire_smps2), opts_parse_uint32, NULL, 1 },
+	{ "max_smps_timeout", OPT_OFFSET(max_smps_timeout), opts_parse_uint32, NULL, 1 },
 	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
 	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
 	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 0 },
@@ -670,10 +672,13 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->m_key_lease_period = 0;
 	p_opt->sweep_interval = OSM_DEFAULT_SWEEP_INTERVAL_SECS;
 	p_opt->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
+	p_opt->max_wire_smps2 = p_opt->max_wire_smps;
 	p_opt->console = strdup(OSM_DEFAULT_CONSOLE);
 	p_opt->console_port = OSM_DEFAULT_CONSOLE_PORT;
 	p_opt->transaction_timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
 	p_opt->transaction_retries = OSM_DEFAULT_RETRY_COUNT;
+	p_opt->max_smps_timeout = 1000 * p_opt->transaction_timeout *
+				  p_opt->transaction_retries;
 	/* by default we will consider waiting for 50x transaction timeout normal */
 	p_opt->max_msg_fifo_timeout = 50 * OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
 	p_opt->sm_priority = OSM_DEFAULT_SM_PRIORITY;
@@ -1074,6 +1079,13 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
 	}
 
+	if (p_opts->max_wire_smps2 > 0x7FFFFFFF) {
+		log_report(" Invalid Cached Option Value: max_wire_smps2 = %u,"
+			   " Using Default: %u",
+			   p_opts->max_wire_smps2, p_opts->max_wire_smps);
+		p_opts->max_wire_smps2 = p_opts->max_wire_smps;
+	}
+
 	if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE)
 	    && strcmp(p_opts->console, OSM_LOCAL_CONSOLE)
 #ifdef ENABLE_OSM_CONSOLE_SOCKET
@@ -1482,6 +1494,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#\n# TIMING AND THREADING OPTIONS\n#\n"
 		"# Maximum number of SMPs sent in parallel\n"
 		"max_wire_smps %u\n\n"
+		"# Maximum number of timeout based SMPs allowed to be outstanding\n"
+		"# A value less than or equal to max_wire_smps disables this mechanism\n"
+		"max_wire_smps2 %u\n\n"
+		"# The timeout in [usec] used for sending SMPs above max_wire_smps limit and below max_wire_smps2 limit\n"
+		"max_smps_timeout %u\n\n"
 		"# The maximum time in [msec] allowed for a transaction to complete\n"
 		"transaction_timeout %u\n\n"
 		"# The maximum number of retries allowed for a transaction to complete\n"
@@ -1494,6 +1511,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Use a single thread for handling SA queries\n"
 		"single_thread %s\n\n",
 		p_opts->max_wire_smps,
+		p_opts->max_wire_smps2,
+		p_opts->max_smps_timeout,
 		p_opts->transaction_timeout,
 		p_opts->transaction_retries,
 		p_opts->max_msg_fifo_timeout,
diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index ff9e4db..bb2c0c6 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006,2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -113,6 +113,8 @@ static void vl15_poller(IN void *p_ptr)
 	osm_madw_t *p_madw;
 	osm_vl15_t *p_vl = p_ptr;
 	cl_qlist_t *p_fifo;
+	int32_t max_smps = p_vl->max_wire_smps;
+	int32_t max_smps2 = p_vl->max_wire_smps2;
 
 	OSM_LOG_ENTER(p_vl->p_log);
 
@@ -155,17 +157,22 @@ static void vl15_poller(IN void *p_ptr)
 			status = cl_event_wait_on(&p_vl->signal,
 						  EVENT_NO_TIMEOUT, TRUE);
 
-		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >=
-		       (int32_t) p_vl->max_wire_smps &&
+		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >= max_smps &&
 		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
 			status = cl_event_wait_on(&p_vl->signal,
-						  EVENT_NO_TIMEOUT, TRUE);
-			if (status != CL_SUCCESS) {
+						  p_vl->max_smps_timeout,
+						  TRUE);
+			if (status == CL_TIMEOUT) {
+				if (max_smps < max_smps2)
+					max_smps++;
+				break;
+			} else if (status != CL_SUCCESS) {
 				OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E02: "
 					"Event wait failed (%s)\n",
 					CL_STATUS_MSG(status));
 				break;
 			}
+			max_smps = p_vl->max_wire_smps;
 		}
 	}
 
@@ -236,7 +243,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
 
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
-			      IN int32_t max_wire_smps)
+			      IN int32_t max_wire_smps,
+			      IN int32_t max_wire_smps2,
+			      IN uint32_t max_smps_timeout)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
@@ -246,6 +255,9 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 	p_vl->p_log = p_log;
 	p_vl->p_stats = p_stats;
 	p_vl->max_wire_smps = max_wire_smps;
+	p_vl->max_wire_smps2 = max_wire_smps2;
+	p_vl->max_smps_timeout = max_wire_smps < max_wire_smps2 ?
+				 max_smps_timeout : EVENT_NO_TIMEOUT;
 
 	status = cl_event_init(&p_vl->signal, FALSE);
 	if (status != IB_SUCCESS)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
