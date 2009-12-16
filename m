From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 16 Dec 2009 10:11:15 -0500
Message-ID: <20091216151115.GA22639@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In order to better handle non responsive SMAs (when link is physically up
but the SMA does not respond), a rate based mechanism for SMPs is added
to better enable forward progress in a more timely fashion. So rather than
wait for timeouts and outstanding wire SMPs to drop below some configured
value, there is also a periodic rate for transaction based SMPs. These
rate based SMPs are capped at a configured maximum value. In order to
accomodate these, the vendor layer ibumad match table is increased by
that number in order not to overflow due to these added transactions.

Two new options are added for this:
rate_based_smp_usecs indicates the number of microseconds between rate
based SMPs. 
max_rate_based_smps indicates the maximum number of rate based SMPs
supported. When this limit is reached, rate based SMPs are no longer
sent (until the number of outstanding ones drops below this limit).

The rate based SMP mechanism can be disabled by setting rate_based_smp_usecs
to 0. This is equivalent to the (current) algorithm prior to this change.

Test results:

Subnet consists of 55 switches (all 36-port IS4) and couple of HCAs.
OpenSM configuration to enlarge the fabric: LMC=7, LMC of
extended port 0 = TRUE.

It takes ~8K SMPs to configure this fabric (no QoS).

Measured section of the code: LFTs configuration, which is
the most SMP-intense phase of the sweep.

Existing OpenSM code:
       max_wire_smps=1: LFT configuration took ~0.27 sec
       max_wire_smps=4: LFT configuration took ~0.13 sec

OpenSM with rate-based SMPs
       no difference from the existing OpenSM was observed.

Further testing showed that when subnet is OK (no timeouts),
SM doesn't send rate-based SMPs at all, or sends just a couple
of them (out of total 8K SMPs).

Experimenting with "bad" fabric:
With 480 timeouts in a row, all the timeouts were failed Set() commands.
OpenSM configuration was as follows:
       max_wire_smps=1
       rate_based_smp_usec=10000 (10 msec)
       max_rate_based_smps=100

Whole sweep time: 21 seconds
Virtually all the SMPs were rate-based.
Calculating how much this should have taken w/o rate-based SMPs:
(480 timeouts) * (3 retries) * (0.2 sec timeout) = 4.8 minutes
so this is a big improvement in the presence of errors.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 4e9aaa9..ddb1265 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -448,6 +448,30 @@ BEGIN_C_DECLS
 */
 #define OSM_DEFAULT_SMP_MAX_ON_WIRE 4
 /***********/
+/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE
+* NAME
+*	OSM_DEFAULT_SMP_RATE
+*
+* DESCRIPTION
+*	Specifies the default rate (in usec) for rate based SMPs.
+*	The default rate is 1 msec (1000 usec). A value of 0
+*	(or EVENT_NO_TIMEOUT) disables the rate based SMP mechanism.
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_SMP_RATE 1000
+/***********/
+/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE_MAX
+* NAME
+*	OSM_DEFAULT_SMP_RATE_MAX
+*
+* DESCRIPTION
+*	Specifies the default maximum number of outstanding rate based SMPs.
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_SMP_RATE_MAX 1000
+/***********/
 /****d* OpenSM: Base/OSM_SM_DEFAULT_QP0_RCV_SIZE
 * NAME
 *	OSM_SM_DEFAULT_QP0_RCV_SIZE
diff --git a/opensm/include/opensm/osm_madw.h b/opensm/include/opensm/osm_madw.h
index 9c63151..a590278 100644
--- a/opensm/include/opensm/osm_madw.h
+++ b/opensm/include/opensm/osm_madw.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -421,6 +421,7 @@ typedef struct osm_madw {
 	ib_api_status_t status;
 	cl_disp_msgid_t fail_msg;
 	boolean_t resp_expected;
+	boolean_t rate_based_smp;
 	const ib_mad_t *p_mad;
 } osm_madw_t;
 /*
@@ -461,6 +462,10 @@ typedef struct osm_madw {
 *		TRUE if a response is expected to this MAD.
 *		FALSE otherwise.
 *
+*	rate_based_smp
+*		TRUE if send is being requested based on rate based SMP
+*		algorithm. FALSE otherwise.
+*
 *	p_mad
 *		Pointer to the wire MAD.  The MAD itself cannot be part of the
 *		wrapper, since wire MADs typically reside in special memory
@@ -490,6 +495,7 @@ static inline void osm_madw_init(IN osm_madw_t * p_madw,
 	if (p_mad_addr)
 		p_madw->mad_addr = *p_mad_addr;
 	p_madw->resp_expected = FALSE;
+	p_madw->rate_based_smp = FALSE;
 }
 
 /*
diff --git a/opensm/include/opensm/osm_stats.h b/opensm/include/opensm/osm_stats.h
index 4331cfa..bb1400a 100644
--- a/opensm/include/opensm/osm_stats.h
+++ b/opensm/include/opensm/osm_stats.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -84,6 +84,7 @@ BEGIN_C_DECLS
 typedef struct osm_stats {
 	atomic32_t qp0_mads_outstanding;
 	atomic32_t qp0_mads_outstanding_on_wire;
+	atomic32_t qp0_rate_based_smps_outstanding;
 	atomic32_t qp0_mads_rcvd;
 	atomic32_t qp0_mads_sent;
 	atomic32_t qp0_unicasts_sent;
@@ -112,6 +113,11 @@ typedef struct osm_stats {
 *	qp0_mads_outstanding_on_wire
 *		The number of MADs outstanding on the wire at any moment.
 *
+*	qp0_rate_based_smps_outstanding
+*		The number of rate based SMPs outstanding on QP0.
+*		This count is included in qp0_mads_outstanding.
+*		It is used for rate based SMP accounting.
+*
 *	qp0_mads_rcvd
 *		Total number of QP0 MADs received.
 *
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index c484d60..b0ca174 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -149,6 +149,8 @@ typedef struct osm_subn_opt {
 	ib_net16_t m_key_lease_period;
 	uint32_t sweep_interval;
 	uint32_t max_wire_smps;
+	uint32_t rate_based_smp_usecs;
+	uint32_t max_rate_based_smps;
 	uint32_t transaction_timeout;
 	uint32_t transaction_retries;
 	uint8_t sm_priority;
@@ -260,6 +262,14 @@ typedef struct osm_subn_opt {
 *	max_wire_smps
 *		The maximum number of SMPs sent in parallel.  Default is 4.
 *
+*	rate_based_smp_usecs
+*		The wait time in usec for rate based SMPs.  Default is 1000
+*		usec (1 msec).
+*
+*	max_rate_based_smps
+*		The maximum number of rate based SMPs allowed to be outstanding.
+*		Default is 1000.
+*
 *	transaction_timeout
 *		The maximum time in milliseconds allowed for a transaction
 *		to complete.  Default is 200.
diff --git a/opensm/include/opensm/osm_vl15intf.h b/opensm/include/opensm/osm_vl15intf.h
index 15ed56c..b52af83 100644
--- a/opensm/include/opensm/osm_vl15intf.h
+++ b/opensm/include/opensm/osm_vl15intf.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -117,6 +117,8 @@ typedef struct osm_vl15 {
 	osm_thread_state_t thread_state;
 	osm_vl15_state_t state;
 	uint32_t max_wire_smps;
+	uint32_t rate_based_smp_usecs;
+	uint32_t max_rate_based_smps;
 	cl_event_t signal;
 	cl_thread_t poller;
 	cl_qlist_t rfifo;
@@ -137,6 +139,12 @@ typedef struct osm_vl15 {
 *	max_wire_smps
 *		Maximum number of VL15 MADs allowed on the wire at one time.
 *
+*	rate_based_smp_usecs
+*		Wait time in usec for rate based SMPs.
+*
+*	max_rate_based_smps
+*		Maximum number of rate based SMPs allowed to be outstanding.
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
+			      IN uint32_t rate_based_smp_usecs,
+			      IN uint32_t max_rate_based_smps);
 /*
 * PARAMETERS
 *	p_vl15
@@ -261,6 +271,13 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
 *	max_wire_smps
 *		[in] Maximum number of MADs allowed on the wire at one time.
 *
+*	rate_based_smp_usecs
+*		[in] Wait time in usec for rate based SMPs.
+*
+*	max_rate_based_smps
+*		[in] Maximum number of rate based SMPs allowed to be
+*		     outstanding.
+*
 * RETURN VALUES
 *	IB_SUCCESS if the VL15 object was initialized successfully.
 *
diff --git a/opensm/include/vendor/osm_vendor_api.h b/opensm/include/vendor/osm_vendor_api.h
index 4973417..dfefd8a 100644
--- a/opensm/include/vendor/osm_vendor_api.h
+++ b/opensm/include/vendor/osm_vendor_api.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -132,7 +132,8 @@ typedef void (*osm_vend_mad_send_err_callback_t) (IN void *bind_context,
 * SYNOPSIS
 */
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout);
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps);
 /*
 * PARAMETERS
 *  p_log
@@ -141,6 +142,9 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 *  timeout
 *     [in] transaction timeout
 *
+*  max_rate_based_smps
+*     [in] maximum number of rate based SMPs
+*
 * RETURN VALUES
 *  Returns a pointer to the vendor object.
 *
@@ -220,7 +224,8 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 */
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend, IN osm_log_t * const p_log,
-		IN const uint32_t timeout);
+		IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps);
 /*
 * PARAMETERS
 *  p_vend
@@ -234,6 +239,9 @@ osm_vendor_init(IN osm_vendor_t * const p_vend, IN osm_log_t * const p_log,
 *     [in] Transaction timeout value in milliseconds.
 *     A value of 0 disables timeouts.
 *
+*  max_rate_based_smps
+*     [in] Maximum number of rate based SMPs.
+*
 * RETURN VALUE
 *
 * NOTES
diff --git a/opensm/libvendor/osm_vendor_al.c b/opensm/libvendor/osm_vendor_al.c
index 3ac05c9..7184957 100644
--- a/opensm/libvendor/osm_vendor_al.c
+++ b/opensm/libvendor/osm_vendor_al.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -329,7 +329,8 @@ __osm_al_rcv_callback(IN void *mad_svc_context, IN ib_mad_element_t * p_elem)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	OSM_LOG_ENTER(p_log);
@@ -356,7 +357,8 @@ Exit:
 }
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -373,7 +375,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 
 	memset(p_vend, 0, sizeof(*p_vend));
 
-	status = osm_vendor_init(p_vend, p_log, timeout);
+	status = osm_vendor_init(p_vend, p_log, timeout, max_rate_based_smps);
 	if (status != IB_SUCCESS) {
 		free(p_vend);
 		p_vend = NULL;
diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index 6927060..73e4f59 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
@@ -439,7 +439,8 @@ static void umad_receiver_stop(umad_receiver_t * p_ur)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	char *max = NULL;
 	int r, n_cas;
@@ -471,7 +472,7 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
 	}
 
 	p_vend->ca_count = n_cas;
-	p_vend->mtbl.max = DEFAULT_OSM_UMAD_MAX_PENDING;
+	p_vend->mtbl.max = max_rate_based_smps + DEFAULT_OSM_UMAD_MAX_PENDING;
 
 	if ((max = getenv("OSM_UMAD_MAX_PENDING")) != NULL) {
 		int tmp = strtol(max, NULL, 0);
@@ -500,7 +501,8 @@ Exit:
 }
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	osm_vendor_t *p_vend = NULL;
 
@@ -521,7 +523,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 
 	memset(p_vend, 0, sizeof(*p_vend));
 
-	if (osm_vendor_init(p_vend, p_log, timeout) < 0) {
+	if (osm_vendor_init(p_vend, p_log, timeout, max_rate_based_smps) < 0) {
 		free(p_vend);
 		p_vend = NULL;
 	}
diff --git a/opensm/libvendor/osm_vendor_mlx.c b/opensm/libvendor/osm_vendor_mlx.c
index 9ae59a9..af7a7c2 100644
--- a/opensm/libvendor/osm_vendor_mlx.c
+++ b/opensm/libvendor/osm_vendor_mlx.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -64,7 +64,8 @@ static void __osm_vendor_internal_unbind(osm_bind_handle_t h_bind);
  */
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -77,7 +78,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 	if (p_vend != NULL) {
 		memset(p_vend, 0, sizeof(*p_vend));
 
-		status = osm_vendor_init(p_vend, p_log, timeout);
+		status = osm_vendor_init(p_vend, p_log, timeout,
+					 max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete(&p_vend);
 		}
@@ -147,7 +149,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
diff --git a/opensm/libvendor/osm_vendor_mlx_anafa.c b/opensm/libvendor/osm_vendor_mlx_anafa.c
index fbaab1d..4ab840a 100644
--- a/opensm/libvendor/osm_vendor_mlx_anafa.c
+++ b/opensm/libvendor/osm_vendor_mlx_anafa.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -71,7 +71,8 @@ static void __osm_vendor_internal_unbind(osm_bind_handle_t h_bind);
  */
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -83,7 +84,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 	p_vend = malloc(sizeof(*p_vend));
 	if (p_vend != NULL) {
 		memset(p_vend, 0, sizeof(*p_vend));
-		status = osm_vendor_init(p_vend, p_log, timeout);
+		status = osm_vendor_init(p_vend, p_log, timeout,
+					 max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete(&p_vend);
 		}
@@ -159,7 +161,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status = IB_SUCCESS;
 	char device_file[16];
diff --git a/opensm/libvendor/osm_vendor_mtl.c b/opensm/libvendor/osm_vendor_mtl.c
index ede3c71..85228e2 100644
--- a/opensm/libvendor/osm_vendor_mtl.c
+++ b/opensm/libvendor/osm_vendor_mtl.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -302,7 +302,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	osm_vendor_mgt_bind_t *ib_mgt_hdl_p;
 	ib_api_status_t status = IB_SUCCESS;
@@ -342,7 +343,8 @@ Exit:
  *  Create and Initialize osm_vendor_t Object
  **********************************************************************/
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -354,7 +356,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 	p_vend = malloc(sizeof(*p_vend));
 	if (p_vend != NULL) {
 		memset(p_vend, 0, sizeof(*p_vend));
-		status = osm_vendor_init(p_vend, p_log, timeout);
+		status = osm_vendor_init(p_vend, p_log, timeout,
+					 max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete(&p_vend);
 		}
diff --git a/opensm/libvendor/osm_vendor_test.c b/opensm/libvendor/osm_vendor_test.c
index 9f7b104..3a3ca55 100644
--- a/opensm/libvendor/osm_vendor_test.c
+++ b/opensm/libvendor/osm_vendor_test.c
@@ -75,7 +75,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	OSM_LOG_ENTER(p_log);
 
@@ -89,7 +90,8 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
 }
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -101,7 +103,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 	if (p_vend != NULL) {
 		memset(p_vend, 0, sizeof(*p_vend));
 
-		status = osm_vendor_init(p_vend, p_log, timeout);
+		status = osm_vendor_init(p_vend, p_log, timeout,
+					 max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete(&p_vend);
 		}
diff --git a/opensm/libvendor/osm_vendor_ts.c b/opensm/libvendor/osm_vendor_ts.c
index f4f1df1..a418098 100644
--- a/opensm/libvendor/osm_vendor_ts.c
+++ b/opensm/libvendor/osm_vendor_ts.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -211,7 +211,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
@@ -234,7 +235,8 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
  *  Create and Initialize osm_vendor_t Object
  **********************************************************************/
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	osm_vendor_t *p_vend;
@@ -247,7 +249,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 	if (p_vend != NULL) {
 		memset(p_vend, 0, sizeof(*p_vend));
 
-		status = osm_vendor_init(p_vend, p_log, timeout);
+		status = osm_vendor_init(p_vend, p_log, timeout,
+					 max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete(&p_vend);
 		}
diff --git a/opensm/libvendor/osm_vendor_umadt.c b/opensm/libvendor/osm_vendor_umadt.c
index b4d707d..b03351a 100644
--- a/opensm/libvendor/osm_vendor_umadt.c
+++ b/opensm/libvendor/osm_vendor_umadt.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -126,7 +126,8 @@ __match_tid_context(const cl_list_item_t * const p_list_item, void *context);
 void __osm_vendor_timer_callback(IN void *context);
 
 osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
-			     IN const uint32_t timeout)
+			     IN const uint32_t timeout,
+			     IN const uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status;
 	umadt_obj_t *p_umadt_obj;
@@ -138,7 +139,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
 		memset(p_umadt_obj, 0, sizeof(umadt_obj_t));
 
 		status = osm_vendor_init((osm_vendor_t *) p_umadt_obj, p_log,
-					 timeout);
+					 timeout, max_rate_based_smps);
 		if (status != IB_SUCCESS) {
 			osm_vendor_delete((osm_vendor_t **) & p_umadt_obj);
 		}
@@ -189,7 +190,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend)
 /*  */
 ib_api_status_t
 osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout)
+		IN osm_log_t * const p_log, IN const uint32_t timeout,
+		IN const uint32_t max_rate_based_smps)
 {
 	FSTATUS Status;
 	PUMADT_GET_INTERFACE uMadtGetInterface;
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index 206e7f7..f2327df 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -393,19 +394,21 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 #endif
 		fprintf(out, "\n   MAD stats\n"
 			"   ---------\n"
-			"   QP0 MADs outstanding           : %d\n"
-			"   QP0 MADs outstanding (on wire) : %d\n"
-			"   QP0 MADs rcvd                  : %d\n"
-			"   QP0 MADs sent                  : %d\n"
-			"   QP0 unicasts sent              : %d\n"
-			"   QP0 unknown MADs rcvd          : %d\n"
-			"   SA MADs outstanding            : %d\n"
-			"   SA MADs rcvd                   : %d\n"
-			"   SA MADs sent                   : %d\n"
-			"   SA unknown MADs rcvd           : %d\n"
-			"   SA MADs ignored                : %d\n",
+			"   QP0 MADs outstanding            : %d\n"
+			"   QP0 MADs outstanding (on wire)  : %d\n"
+			"   QP0 rate based SMPs outstanding : %d\n"
+			"   QP0 MADs rcvd                   : %d\n"
+			"   QP0 MADs sent                   : %d\n"
+			"   QP0 unicasts sent               : %d\n"
+			"   QP0 unknown MADs rcvd           : %d\n"
+			"   SA MADs outstanding             : %d\n"
+			"   SA MADs rcvd                    : %d\n"
+			"   SA MADs sent                    : %d\n"
+			"   SA unknown MADs rcvd            : %d\n"
+			"   SA MADs ignored                 : %d\n",
 			p_osm->stats.qp0_mads_outstanding,
 			p_osm->stats.qp0_mads_outstanding_on_wire,
+			p_osm->stats.qp0_rate_based_smps_outstanding,
 			p_osm->stats.qp0_mads_rcvd,
 			p_osm->stats.qp0_mads_sent,
 			p_osm->stats.qp0_unicasts_sent,
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index 5b3b364..cc587aa 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -379,7 +379,8 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 		goto Exit;
 
 	p_osm->p_vendor =
-	    osm_vendor_new(&p_osm->log, p_opt->transaction_timeout);
+	    osm_vendor_new(&p_osm->log, p_opt->transaction_timeout,
+			   p_opt->max_rate_based_smps);
 	if (p_osm->p_vendor == NULL) {
 		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
@@ -391,7 +392,9 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 
 	status = osm_vl15_init(&p_osm->vl15, p_osm->p_vendor,
 			       &p_osm->log, &p_osm->stats,
-			       p_opt->max_wire_smps);
+			       p_opt->max_wire_smps,
+			       p_opt->rate_based_smp_usecs,
+			       p_opt->max_rate_based_smps);
 	if (status != IB_SUCCESS)
 		goto Exit;
 
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index 3ae1eb6..ce61792 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -82,6 +82,8 @@ static void sm_mad_ctrl_retire_trans_mad(IN osm_sm_mad_ctrl_t * p_ctrl,
 		"Retiring MAD with TID 0x%" PRIx64 "\n",
 		cl_ntoh64(osm_madw_get_smp_ptr(p_madw)->trans_id));
 
+	if (p_madw->rate_based_smp)
+		cl_atomic_dec(&p_ctrl->p_stats->qp0_rate_based_smps_outstanding);
 	osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 
 	outstanding = osm_stats_dec_qp0_outstanding(p_ctrl->p_stats);
@@ -211,6 +213,7 @@ static void sm_mad_ctrl_process_get_resp(IN osm_sm_mad_ctrl_t * p_ctrl,
 	   can return the original MAD to the pool.
 	 */
 	osm_madw_copy_context(p_madw, p_old_madw);
+	p_madw->rate_based_smp = p_old_madw->rate_based_smp;
 	osm_mad_pool_put(p_ctrl->p_mad_pool, p_old_madw);
 
 	/*
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 032ef38..0c5f84d 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -297,6 +297,8 @@ static const opt_rec_t opt_tbl[] = {
 	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
 	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
+	{ "rate_based_smp_usecs", OPT_OFFSET(rate_based_smp_usecs), opts_parse_uint32, NULL, 1 },
+	{ "max_rate_based_smps", OPT_OFFSET(max_rate_based_smps), opts_parse_uint32, NULL, 1 },
 	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
 	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
 	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 1 },
@@ -680,6 +682,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->m_key_lease_period = 0;
 	p_opt->sweep_interval = OSM_DEFAULT_SWEEP_INTERVAL_SECS;
 	p_opt->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
+	p_opt->rate_based_smp_usecs = OSM_DEFAULT_SMP_RATE;
+	p_opt->max_rate_based_smps = OSM_DEFAULT_SMP_RATE_MAX;
 	p_opt->console = strdup(OSM_DEFAULT_CONSOLE);
 	p_opt->console_port = OSM_DEFAULT_CONSOLE_PORT;
 	p_opt->transaction_timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
@@ -1080,6 +1084,9 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
 	}
 
+	if (p_opts->rate_based_smp_usecs == 0)
+		p_opts->rate_based_smp_usecs = EVENT_NO_TIMEOUT;
+
 	if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE)
 	    && strcmp(p_opts->console, OSM_LOCAL_CONSOLE)
 #ifdef ENABLE_OSM_CONSOLE_SOCKET
@@ -1483,6 +1490,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#\n# TIMING AND THREADING OPTIONS\n#\n"
 		"# Maximum number of SMPs sent in parallel\n"
 		"max_wire_smps %u\n\n"
+		"# The rate in [usec] at which rate based SMPs are sent\n"
+		"# A value of 0 disables the rate based SMP mechanism\n"
+		"rate_based_smp_usecs %u\n\n"
+		"# Maximum number of rate based SMPs allowed to be outstanding\n"
+		"max_rate_based_smps %u\n\n"
 		"# The maximum time in [msec] allowed for a transaction to complete\n"
 		"transaction_timeout %u\n\n"
 		"# The maximum number of retries allowed for a transaction to complete\n"
@@ -1495,6 +1507,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Use a single thread for handling SA queries\n"
 		"single_thread %s\n\n",
 		p_opts->max_wire_smps,
+		p_opts->rate_based_smp_usecs,
+		p_opts->max_rate_based_smps,
 		p_opts->transaction_timeout,
 		p_opts->transaction_retries,
 		p_opts->max_msg_fifo_timeout,
diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index cc3ff33..e2b3888 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -54,7 +54,8 @@
 #include <opensm/osm_log.h>
 #include <opensm/osm_helper.h>
 
-static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
+static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw,
+			  boolean_t rate_based)
 {
 	ib_api_status_t status;
 
@@ -63,7 +64,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	   since we can have no confirmation that they arrived
 	   at their destination.
 	 */
-	if (p_madw->resp_expected == TRUE)
+	if (p_madw->resp_expected == TRUE) {
 		/*
 		   Note that other threads may not see the response MAD
 		   arrive before send() even returns.
@@ -71,8 +72,12 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 		   To avoid this confusion, preincrement the counts on the
 		   assumption that send() will succeed.
 		 */
+		if (rate_based) {
+			p_madw->rate_based_smp = rate_based;
+			cl_atomic_inc(&p_vl->p_stats->qp0_rate_based_smps_outstanding);
+		}
 		cl_atomic_inc(&p_vl->p_stats->qp0_mads_outstanding_on_wire);
-	else
+	} else
 		cl_atomic_inc(&p_vl->p_stats->qp0_unicasts_sent);
 
 	cl_atomic_inc(&p_vl->p_stats->qp0_mads_sent);
@@ -106,6 +111,8 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	cl_atomic_dec(&p_vl->p_stats->qp0_mads_sent);
 	if (!p_madw->resp_expected)
 		cl_atomic_dec(&p_vl->p_stats->qp0_unicasts_sent);
+	else if (rate_based)
+		cl_atomic_dec(&p_vl->p_stats->qp0_rate_based_smps_outstanding);
 }
 
 static void vl15_poller(IN void *p_ptr)
@@ -114,6 +121,7 @@ static void vl15_poller(IN void *p_ptr)
 	osm_madw_t *p_madw;
 	osm_vl15_t *p_vl = p_ptr;
 	cl_qlist_t *p_fifo;
+	boolean_t rate_based = FALSE;
 
 	OSM_LOG_ENTER(p_vl->p_log);
 
@@ -148,7 +156,7 @@ static void vl15_poller(IN void *p_ptr)
 						osm_madw_get_smp_ptr(p_madw),
 						OSM_LOG_FRAMES);
 
-			vl15_send_mad(p_vl, p_madw);
+			vl15_send_mad(p_vl, p_madw, rate_based);
 		} else
 			/*
 			   The VL15 FIFO is empty, so we have nothing left to do.
@@ -156,11 +164,20 @@ static void vl15_poller(IN void *p_ptr)
 			status = cl_event_wait_on(&p_vl->signal,
 						  EVENT_NO_TIMEOUT, TRUE);
 
+		rate_based = FALSE;
 		while (p_vl->p_stats->qp0_mads_outstanding_on_wire >=
 		       (int32_t) p_vl->max_wire_smps &&
 		       p_vl->thread_state == OSM_THREAD_STATE_RUN) {
 			status = cl_event_wait_on(&p_vl->signal,
-						  EVENT_NO_TIMEOUT, TRUE);
+						  p_vl->rate_based_smp_usecs,
+						  TRUE);
+			if (status == CL_TIMEOUT) {
+				if (p_vl->p_stats->qp0_rate_based_smps_outstanding >=
+				    (int32_t) p_vl->max_rate_based_smps)
+					continue;
+				rate_based = TRUE;
+				break;
+			}
 			if (status != CL_SUCCESS) {
 				OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E02: "
 					"Event wait failed (%s)\n",
@@ -237,7 +254,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
 
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
-			      IN int32_t max_wire_smps)
+			      IN int32_t max_wire_smps,
+			      IN uint32_t rate_based_smp_usecs,
+			      IN uint32_t max_rate_based_smps)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
@@ -247,6 +266,8 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 	p_vl->p_log = p_log;
 	p_vl->p_stats = p_stats;
 	p_vl->max_wire_smps = max_wire_smps;
+	p_vl->rate_based_smp_usecs = rate_based_smp_usecs;
+	p_vl->max_rate_based_smps = max_rate_based_smps;
 
 	status = cl_event_init(&p_vl->signal, FALSE);
 	if (status != IB_SUCCESS)
@@ -354,6 +375,8 @@ void osm_vl15_shutdown(IN osm_vl15_t * p_vl, IN osm_mad_pool_t * p_mad_pool)
 		OSM_LOG(p_vl->p_log, OSM_LOG_DEBUG,
 			"Releasing Request p_madw = %p\n", p_madw);
 
+		if (p_madw->rate_based_smp)
+			cl_atomic_dec(&p_vl->p_stats->qp0_rate_based_smps_outstanding);
 		osm_mad_pool_put(p_mad_pool, p_madw);
 		osm_stats_dec_qp0_outstanding(p_vl->p_stats);
 
diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index 50f94db..d362c57 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -498,7 +498,7 @@ osmtest_init(IN osmtest_t * const p_osmt,
 	CL_ASSERT(status == CL_SUCCESS);
 
 	p_osmt->p_vendor = osm_vendor_new(&p_osmt->log,
-					  p_opt->transaction_timeout);
+					  p_opt->transaction_timeout, 0);
 
 	if (p_osmt->p_vendor == NULL) {
 		status = IB_INSUFFICIENT_RESOURCES;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
