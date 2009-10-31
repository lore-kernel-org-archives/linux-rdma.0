From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: Minor reorganization of
	trap_rcv_process_request
Date: Sat, 31 Oct 2009 07:25:01 -0500
Message-ID: <20091031122501.GA24260@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Move some code out into separate log_trap_info routine
for readability/maintainability 

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index d2e4202..c6fe9e9 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -275,11 +275,51 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	return ret;
 }
 
+static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
+			  ib_net16_t source_lid, ib_net64_t trans_id)
+{
+	if (ib_notice_is_generic(p_ntci)) {
+		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(129)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(130)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(131)))
+			OSM_LOG(p_log, OSM_LOG_ERROR,
+				"Received Generic Notice type:%u "
+				"num:%u (%s) Producer:%u (%s) "
+				"from LID:%u Port %d TID:0x%016" PRIx64 "\n",
+				ib_notice_get_type(p_ntci),
+				cl_ntoh16(p_ntci->g_or_v.generic.trap_num),
+				ib_get_trap_str(p_ntci->g_or_v.generic.trap_num),
+				cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
+				ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
+				cl_hton16(source_lid),
+				p_ntci->data_details.ntc_129_131.port_num,
+				cl_ntoh64(trans_id));
+		else
+			OSM_LOG(p_log, OSM_LOG_ERROR,
+				"Received Generic Notice type:%u "
+				"num:%u (%s) Producer:%u (%s) "
+				"from LID:%u TID:0x%016" PRIx64 "\n",
+				ib_notice_get_type(p_ntci),
+				cl_ntoh16(p_ntci->g_or_v.generic.trap_num),
+				ib_get_trap_str(p_ntci->g_or_v.generic.trap_num),
+				cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
+				ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
+				cl_hton16(source_lid),
+				cl_ntoh64(trans_id));
+	} else
+		OSM_LOG(p_log, OSM_LOG_ERROR,
+			"Received Vendor Notice type:%u vend:0x%06X "
+			"dev:%u from LID:%u TID:0x%016" PRIx64 "\n",
+			ib_notice_get_type(p_ntci),
+			cl_ntoh32(ib_notice_get_vend_id(p_ntci)),
+			cl_ntoh16(p_ntci->g_or_v.vend.dev_id),
+			cl_ntoh16(source_lid), cl_ntoh64(trans_id));
+}
+
 /**********************************************************************
  **********************************************************************/
 static void
-trap_rcv_process_request(IN osm_sm_t * sm,
-			 IN const osm_madw_t * const p_madw)
+trap_rcv_process_request(IN osm_sm_t * sm, IN const osm_madw_t * const p_madw)
 {
 	uint8_t payload[sizeof(ib_mad_notice_attr_t)];
 	ib_smp_t *p_smp;
@@ -362,59 +402,13 @@ trap_rcv_process_request(IN osm_sm_t * sm,
 		source_lid = tmp_madw.mad_addr.addr_type.smi.source_lid;
 
 		/* Print some info about the incoming Trap */
-		if (ib_notice_is_generic(p_ntci)) {
-			if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(129))
-			    || (p_ntci->g_or_v.generic.trap_num ==
-				CL_HTON16(130))
-			    || (p_ntci->g_or_v.generic.trap_num ==
-				CL_HTON16(131)))
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-					"Received Generic Notice type:%u "
-					"num:%u (%s) Producer:%u (%s) "
-					"from LID:%u Port %d TID:0x%016"
-					PRIx64 "\n", ib_notice_get_type(p_ntci),
-					cl_ntoh16(p_ntci->g_or_v.generic.
-						  trap_num),
-					ib_get_trap_str(p_ntci->g_or_v.generic.
-							trap_num),
-					cl_ntoh32(ib_notice_get_prod_type
-						  (p_ntci)),
-					ib_get_producer_type_str
-					(ib_notice_get_prod_type(p_ntci)),
-					cl_hton16(source_lid),
-					p_ntci->data_details.ntc_129_131.
-					port_num, cl_ntoh64(p_smp->trans_id));
-			else
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-					"Received Generic Notice type:%u "
-					"num:%u (%s) Producer:%u (%s) "
-					"from LID:%u TID:0x%016" PRIx64
-					"\n", ib_notice_get_type(p_ntci),
-					cl_ntoh16(p_ntci->g_or_v.generic.
-						  trap_num),
-					ib_get_trap_str(p_ntci->g_or_v.generic.
-							trap_num),
-					cl_ntoh32(ib_notice_get_prod_type
-						  (p_ntci)),
-					ib_get_producer_type_str
-					(ib_notice_get_prod_type(p_ntci)),
-					cl_hton16(source_lid),
-					cl_ntoh64(p_smp->trans_id));
-		} else
-			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-				"Received Vendor Notice type:%u vend:0x%06X "
-				"dev:%u from LID:%u TID:0x%016" PRIx64 "\n",
-				ib_notice_get_type(p_ntci),
-				cl_ntoh32(ib_notice_get_vend_id(p_ntci)),
-				cl_ntoh16(p_ntci->g_or_v.vend.dev_id),
-				cl_ntoh16(source_lid),
-				cl_ntoh64(p_smp->trans_id));
+		log_trap_info(sm->p_log, p_ntci, source_lid, p_smp->trans_id);
 	}
 
 	osm_dump_notice(sm->p_log, p_ntci, OSM_LOG_VERBOSE);
 
-	p_physp = osm_get_physp_by_mad_addr(sm->p_log,
-					    sm->p_subn, &tmp_madw.mad_addr);
+	p_physp = osm_get_physp_by_mad_addr(sm->p_log, sm->p_subn,
+					    &tmp_madw.mad_addr);
 	if (p_physp)
 		p_smp->m_key = p_physp->port_info.m_key;
 	else
@@ -528,8 +522,8 @@ trap_rcv_process_request(IN osm_sm_t * sm,
 		}
 
 		/* restart the aging anyway */
-		/* If physp_change_trap is TRUE - then use a callback to unset the
-		   healthy bit. If not - no need to use a callback. */
+		/* If physp_change_trap is TRUE - then use a callback to unset
+		   the healthy bit. If not - no need to use a callback. */
 		if (physp_change_trap == TRUE)
 			cl_event_wheel_reg(&sm->trap_aging_tracker, trap_key, cl_get_time_stamp() + event_wheel_timeout, osm_trap_rcv_aging_tracker_callback,	/* no callback */
 					   sm	/* no context */ );
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
