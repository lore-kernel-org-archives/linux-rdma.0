From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_informinfo.c: Add untrusted support for InformInfo/InformInfoRecord
Date: Wed, 25 Apr 2012 09:02:10 -0400
Message-ID: <4F97F5D2.70503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


per C15-0.2-1.16

Previously treating these requests as trusted ones would be

Compile tested only

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index 370148e..45764fd 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -74,6 +74,7 @@ typedef struct osm_iir_search_ctxt {
 	ib_net16_t subscriber_enum;
 	osm_sa_t *sa;
 	osm_physp_t *p_req_physp;
+	ib_net64_t sm_key;
 } osm_iir_search_ctxt_t;
 
 /**********************************************************************
@@ -288,6 +289,16 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 
 	memcpy(&p_rec_item->rec, &p_infr->inform_record,
 	       sizeof(ib_inform_info_record_t));
+
+	/*
+	 * Per C15-0.2-1.16, InformInfoRecords shall always be
+	 * provided with the QPN set to 0, except for the case
+	 * of a trusted request, in which case the actual
+	 * subscriber QPN shall be returned.
+	 */
+	if (p_ctxt->sm_key == 0)
+		ib_inform_info_set_qpn(&p_rec_item->rec.inform_info, 0);
+
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
 Exit:
@@ -350,6 +361,7 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	context.subscriber_enum = p_rcvd_rec->subscriber_enum;
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
+	context.sm_key = p_rcvd_mad->sm_key;
 
 	OSM_LOG_V2(sa->p_log, OSM_LOG_DEBUG,
 		   "Query Subscriber GID:%s(%02X) Enum:0x%X(%02X)\n",
@@ -441,7 +453,7 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	if (p_recvd_inform_info->subscribe > 1) {
 		cl_plock_release(sa->p_lock);
 
-		OSM_LOG_V2(sa->p_log, OSM_LOG_ERROR, "ERR 4308 "
+		OSM_LOG_V2(sa->p_log, OSM_LOG_ERROR, "ERR 430A "
 			   "Invalid subscribe: %d\n",
 			   p_recvd_inform_info->subscribe);
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
@@ -449,6 +461,24 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	}
 
 	/*
+	 * Per C15-0.2-1.16, SubnAdmSet(InformInfo) subscriptions for
+	 * SM security traps shall be provided only if they come from a
+	 * trusted source.
+	 */
+	if ((p_sa_mad->sm_key == 0) && p_recvd_inform_info->is_generic &&
+	    ((cl_ntoh16(p_recvd_inform_info->g_or_v.generic.trap_num) >= 256) &&
+	     (cl_ntoh16(p_recvd_inform_info->g_or_v.generic.trap_num) <= 259))) {
+		cl_plock_release(sa->p_lock);
+
+		OSM_LOG_V2(sa->p_log, OSM_LOG_ERROR, "ERR 430B "
+			   "Request for security trap from non-trusted requester: "
+			   "Given SM_Key:0x%016" PRIx64 "\n",
+			   cl_ntoh64(p_sa_mad->sm_key));
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
+		goto Exit;
+	}
+
+	/*
 	 * MODIFICATIONS DONE ON INCOMING REQUEST:
 	 *
 	 * QPN:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
