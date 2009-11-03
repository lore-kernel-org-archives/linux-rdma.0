From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_trap_rcv.c: More minor reorg of
 trap_rcv_process_request
Date: Tue, 3 Nov 2009 04:00:28 +0200
Message-ID: <20091103020028.GB17404@me>
References: <20091102115051.GA32233@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091102115051.GA32233-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06:50 Mon 02 Nov     , Hal Rosenstock wrote:
> 
> Move some code out into separate handle_babbling_port routine
> for readability/maintainability 
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
> index 5790461..1621fbc 100644
> --- a/opensm/opensm/osm_trap_rcv.c
> +++ b/opensm/opensm/osm_trap_rcv.c
> @@ -312,6 +312,61 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
>  			cl_ntoh16(source_lid), cl_ntoh64(trans_id));
>  }
>  
> +static int handle_babbling_port(osm_sm_t *sm, ib_mad_notice_attr_t *p_ntci,
> +				uint32_t num_received,
> +				boolean_t physp_change_trap,
> +				osm_physp_t **pp_physp,
> +				boolean_t *run_heavy_sweep,
> +				uint64_t *event_wheel_timeout)
> +{
> +	if (print_num_received(num_received))
> +		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3804: "
> +			"Received trap %u times consecutively\n",
> +			num_received);
> +	/* If the trap provides info about a bad port, mark it as unhealthy. */
> +	if (physp_change_trap == TRUE) {
> +		/* get the port */
> +		*pp_physp = get_physp_by_lid_and_num(sm,
> +						     cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
> +						     p_ntci->data_details.ntc_129_131.port_num);
> +
> +		if (!*pp_physp)
> +			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3805: "
> +				"Failed to find physical port by lid:%u num:%u\n",
> +				cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
> +				p_ntci->data_details.ntc_129_131.port_num);
> +		else {
> +			/* When babbling port policy option is enabled and
> +			   Threshold for disabling a "babbling" port is exceeded */
> +			if (sm->p_subn->opt.babbling_port_policy &&
> +			    num_received >= 250 &&
> +			    disable_port(sm, *pp_physp) == 0)
> +				return 1;
> +
> +			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> +				"Marking unhealthy physical port by lid:%u num:%u\n",
> +				cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
> +				p_ntci->data_details.ntc_129_131.port_num);
> +			/* check if the current state of the p_physp is healthy. If
> +			   it is - then this is a first change of state. Run a heavy sweep.
> +			   if it is not - no need to mark it again - just restart the timer. */
> +			if (osm_physp_is_healthy(*pp_physp)) {
> +				osm_physp_set_health(*pp_physp, FALSE);
> +				/* Make sure we sweep again - force a heavy sweep. */
> +				/* The sweep should be done only after the re-registration, or
> +				   else we'll be losing track of the timer. */
> +				*run_heavy_sweep = TRUE;
> +			}
> +			/* If we are marking the port as unhealthy - we want to
> +			   keep this for a longer period of time than the
> +			   OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT. Use the
> +			   OSM_DEFAULT_UNHEALTHY_TIMEOUT */
> +			*event_wheel_timeout = OSM_DEFAULT_UNHEALTHY_TIMEOUT;
> +	}
> +	return 0;
> +}
> +

It looks that you are moving the code as it is to a separate function
where many flow switchers (run_heavy_sweep, event_wheel_timeout,
pp_physp) are magically modified.

What about something like below instead?

Sasha


>From 5ed9114a32f9536123af4bd135c7cc603d340f92 Mon Sep 17 00:00:00 2001
From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date: Tue, 3 Nov 2009 03:46:54 +0200
Subject: [PATCH] opensm/osm_trap_rcv.c: some consolidation

Consolidate noisy port handling code in shutup_noisy_port() function.
As before it will try to disable port or to mark it unhealthy.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_trap_rcv.c |  113 ++++++++++++++++++++----------------------
 1 files changed, 53 insertions(+), 60 deletions(-)

diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 0ee4e77..dae892e 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -226,7 +226,6 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
 	ib_port_info_t *pi = (ib_port_info_t *)payload;
-	int ret;
 
 	/* select the nearest port to master opensm */
 	if (p->p_remote_physp &&
@@ -236,10 +235,6 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	/* If trap 131, might want to disable peer port if available */
 	/* but peer port has been observed not to respond to SM requests */
 
-	OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3810: "
-		"Disabling physical port 0x%016" PRIx64 " num:%u\n",
-		cl_ntoh64(osm_physp_get_port_guid(p)), p->port_num);
-
 	memcpy(payload, &p->port_info, sizeof(ib_port_info_t));
 
 	/* Set port to disabled/down */
@@ -253,15 +248,10 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
 
-	ret = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
-			  payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
-			  cl_hton32(osm_physp_get_port_num(p)),
-			  CL_DISP_MSGID_NONE, &context);
-	if (ret)
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3811: "
-			"Request to set PortInfo failed\n");
-
-	return ret;
+	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
+			   payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
+			   cl_hton32(osm_physp_get_port_num(p)),
+			   CL_DISP_MSGID_NONE, &context);
 }
 
 static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
@@ -301,6 +291,42 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			cl_ntoh16(source_lid), cl_ntoh64(trans_id));
 }
 
+static int shutup_noisy_port(osm_sm_t *sm, uint16_t lid, uint8_t port,
+			     unsigned num)
+{
+	osm_physp_t *p = get_physp_by_lid_and_num(sm, lid, port);
+	if (!p) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3805: "
+			"Failed to find physical port by lid:%u num:%u\n",
+			lid, port);
+		return -1;
+	}
+
+	/* When babbling port policy option is enabled and
+	   Threshold for disabling a "babbling" port is exceeded */
+	if (sm->p_subn->opt.babbling_port_policy && num >= 250) {
+		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+			"Disabling noisy physical port 0x%016" PRIx64
+			": lid %u, num %u\n",
+			cl_ntoh64(osm_physp_get_port_guid(p)), lid, port);
+		if (disable_port(sm, p))
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3811: "
+				"Failed to disable.\n");
+		else
+			return 1;
+	}
+
+	/* check if the current state of the p_physp is healthy. If
+	   it is - then this is a first change of state. Run a heavy sweep. */
+	if (osm_physp_is_healthy(p)) {
+		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+			"Marking unhealthy physical port by lid:%u num:%u\n",
+			lid, port);
+		osm_physp_set_health(p, FALSE);
+		return 2;
+	}
+	return 0;
+}
 /**********************************************************************
  **********************************************************************/
 static void trap_rcv_process_request(IN osm_sm_t * sm,
@@ -438,7 +464,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 		/* Now we know how many times it provided this trap */
 		if (num_received > 10) {
 			if (print_num_received(num_received))
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3804: "
+				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 					"Received trap %u times consecutively\n",
 					num_received);
 			/*
@@ -446,49 +472,17 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 			 * we mark it as unhealthy.
 			 */
 			if (physp_change_trap == TRUE) {
-				/* get the port */
-				p_physp = get_physp_by_lid_and_num(sm,
-								   cl_ntoh16
-								   (source_lid),
-								   port_num);
-
-				if (!p_physp)
-					OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-						"ERR 3805: "
-						"Failed to find physical port by lid:%u num:%u\n",
-						cl_ntoh16(source_lid),
-						port_num);
-				else {
-					/* When babbling port policy option is enabled and
-					   Threshold for disabling a "babbling" port is exceeded */
-					if (sm->p_subn->opt.
-					    babbling_port_policy
-					    && num_received >= 250
-					    && disable_port(sm, p_physp) == 0)
-						goto Exit;
-
-					OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-						"Marking unhealthy physical port by lid:%u num:%u\n",
-						cl_ntoh16(source_lid),
-						port_num);
-					/* check if the current state of the p_physp is healthy. If
-					   it is - then this is a first change of state. Run a heavy sweep.
-					   if it is not - no need to mark it again - just restart the timer. */
-					if (osm_physp_is_healthy(p_physp)) {
-						osm_physp_set_health(p_physp,
-								     FALSE);
-						/* Make sure we sweep again - force a heavy sweep. */
-						/* The sweep should be done only after the re-registration, or
-						   else we'll be losing track of the timer. */
-						run_heavy_sweep = TRUE;
-					}
-					/* If we are marking the port as unhealthy - we want to
-					   keep this for a longer period of time than the
-					   OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT. Use the
-					   OSM_DEFAULT_UNHEALTHY_TIMEOUT */
-					event_wheel_timeout =
-					    OSM_DEFAULT_UNHEALTHY_TIMEOUT;
-				}
+				int ret = shutup_noisy_port(sm,
+							    cl_ntoh16(source_lid),
+							    port_num,
+							    num_received);
+				if (ret == 1) /* port disabled */
+					goto Exit;
+				else if (ret == 2) /* unhealthy - run sweep */
+					run_heavy_sweep = TRUE;
+				/* in any case increase timeout interval */
+				event_wheel_timeout =
+				    OSM_DEFAULT_UNHEALTHY_TIMEOUT;
 			}
 		}
 
@@ -508,8 +502,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 		if (num_received > 10 && run_heavy_sweep == FALSE) {
 			if (print_num_received(num_received))
 				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-					"Continuously received this trap %u times. Ignoring\n",
-					num_received);
+					"Ignoring noisy traps.\n");
 			goto Exit;
 		}
 	}
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
