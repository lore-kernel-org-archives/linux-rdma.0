From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: More minor reorg of
	trap_rcv_process_request
Date: Mon, 2 Nov 2009 06:50:51 -0500
Message-ID: <20091102115051.GA32233@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Move some code out into separate handle_babbling_port routine
for readability/maintainability 

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 5790461..1621fbc 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -312,6 +312,61 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			cl_ntoh16(source_lid), cl_ntoh64(trans_id));
 }
 
+static int handle_babbling_port(osm_sm_t *sm, ib_mad_notice_attr_t *p_ntci,
+				uint32_t num_received,
+				boolean_t physp_change_trap,
+				osm_physp_t **pp_physp,
+				boolean_t *run_heavy_sweep,
+				uint64_t *event_wheel_timeout)
+{
+	if (print_num_received(num_received))
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3804: "
+			"Received trap %u times consecutively\n",
+			num_received);
+	/* If the trap provides info about a bad port, mark it as unhealthy. */
+	if (physp_change_trap == TRUE) {
+		/* get the port */
+		*pp_physp = get_physp_by_lid_and_num(sm,
+						     cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
+						     p_ntci->data_details.ntc_129_131.port_num);
+
+		if (!*pp_physp)
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3805: "
+				"Failed to find physical port by lid:%u num:%u\n",
+				cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
+				p_ntci->data_details.ntc_129_131.port_num);
+		else {
+			/* When babbling port policy option is enabled and
+			   Threshold for disabling a "babbling" port is exceeded */
+			if (sm->p_subn->opt.babbling_port_policy &&
+			    num_received >= 250 &&
+			    disable_port(sm, *pp_physp) == 0)
+				return 1;
+
+			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+				"Marking unhealthy physical port by lid:%u num:%u\n",
+				cl_ntoh16(p_ntci->data_details.ntc_129_131.lid),
+				p_ntci->data_details.ntc_129_131.port_num);
+			/* check if the current state of the p_physp is healthy. If
+			   it is - then this is a first change of state. Run a heavy sweep.
+			   if it is not - no need to mark it again - just restart the timer. */
+			if (osm_physp_is_healthy(*pp_physp)) {
+				osm_physp_set_health(*pp_physp, FALSE);
+				/* Make sure we sweep again - force a heavy sweep. */
+				/* The sweep should be done only after the re-registration, or
+				   else we'll be losing track of the timer. */
+				*run_heavy_sweep = TRUE;
+			}
+			/* If we are marking the port as unhealthy - we want to
+			   keep this for a longer period of time than the
+			   OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT. Use the
+			   OSM_DEFAULT_UNHEALTHY_TIMEOUT */
+			*event_wheel_timeout = OSM_DEFAULT_UNHEALTHY_TIMEOUT;
+		}
+	}
+	return 0;
+}
+
 /**********************************************************************
  **********************************************************************/
 static void
@@ -454,68 +509,11 @@ trap_rcv_process_request(IN osm_sm_t * sm, IN const osm_madw_t * const p_madw)
 					    trap_key);
 
 		/* Now we know how many times it provided this trap */
-		if (num_received > 10) {
-			if (print_num_received(num_received))
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3804: "
-					"Received trap %u times consecutively\n",
-					num_received);
-			/*
-			 * If the trap provides info about a bad port
-			 * we mark it as unhealthy.
-			 */
-			if (physp_change_trap == TRUE) {
-				/* get the port */
-				p_physp = get_physp_by_lid_and_num(sm,
-								   cl_ntoh16
-								   (p_ntci->
-								    data_details.
-								    ntc_129_131.
-								    lid),
-								   port_num);
-
-				if (!p_physp)
-					OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-						"ERR 3805: "
-						"Failed to find physical port by lid:%u num:%u\n",
-						cl_ntoh16(p_ntci->data_details.
-							  ntc_129_131.lid),
-						p_ntci->data_details.
-						ntc_129_131.port_num);
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
-						cl_ntoh16(p_ntci->data_details.
-							  ntc_129_131.lid),
-						p_ntci->data_details.
-						ntc_129_131.port_num);
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
-			}
-		}
+		if (num_received > 10 &&
+		    handle_babbling_port(sm, p_ntci, num_received,
+					 physp_change_trap, &p_physp,
+					 &run_heavy_sweep, &event_wheel_timeout))
+			goto Exit; 
 
 		/* restart the aging anyway */
 		/* If physp_change_trap is TRUE - then use a callback to unset
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
