From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_service_record.c: Cosmetic changes
Date: Mon, 04 Apr 2011 14:46:08 -0400
Message-ID: <4D9A11F0.3050907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Cosmetic simplification of component mask checks
Also, cosmetic commentary change

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index d9386fe..33c1f3b 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -99,8 +99,8 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 	}

 	if ((comp_mask & IB_SR_COMPMASK_SPKEY) == IB_SR_COMPMASK_SPKEY) {
-		/* We have a ServiceP_Key - check matching on requester port, and
-		   ServiceGid port (if such exists) */
+		/* We have a ServiceP_Key - check matching on requester port,
+		   and ServiceGid port (if such exists) */
 		/* Make sure it matches the p_req_physp */
 		if (!osm_physp_has_pkey
 		    (sa->p_log, p_service_rec->service_pkey, p_req_physp)) {
@@ -109,7 +109,7 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 		}

 		/* Make sure it matches the port of the ServiceGid */
-		if ((comp_mask & IB_SR_COMPMASK_SGID) == IB_SR_COMPMASK_SGID) {
+		if (comp_mask & IB_SR_COMPMASK_SGID) {
 			service_guid =
 			    p_service_rec->service_gid.unicast.interface_id;
 			service_port =
@@ -220,189 +220,189 @@ static void get_matching_sr(IN cl_list_item_t *
p_list_item, IN void *context)
 	ib_net64_t comp_mask = p_sr_item->comp_mask;
 	const osm_physp_t *p_req_physp = p_ctxt->p_req_physp;

-	if ((comp_mask & IB_SR_COMPMASK_SID) == IB_SR_COMPMASK_SID) {
+	if (comp_mask & IB_SR_COMPMASK_SID) {
 		if (p_sr_item->p_service_rec->service_id !=
 		    p_svcr->service_record.service_id)
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SGID) == IB_SR_COMPMASK_SGID) {
+	if (comp_mask & IB_SR_COMPMASK_SGID) {
 		if (memcmp(&p_sr_item->p_service_rec->service_gid,
 			   &p_svcr->service_record.service_gid,
 			   sizeof(p_svcr->service_record.service_gid)) != 0)
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SPKEY) == IB_SR_COMPMASK_SPKEY) {
+	if (comp_mask & IB_SR_COMPMASK_SPKEY) {
 		if (p_sr_item->p_service_rec->service_pkey !=
 		    p_svcr->service_record.service_pkey)
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SKEY) == IB_SR_COMPMASK_SKEY) {
+	if (comp_mask & IB_SR_COMPMASK_SKEY) {
 		if (memcmp(p_sr_item->p_service_rec->service_key,
 			   p_svcr->service_record.service_key,
 			   16 * sizeof(uint8_t)))
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SNAME) == IB_SR_COMPMASK_SNAME) {
+	if (comp_mask & IB_SR_COMPMASK_SNAME) {
 		if (memcmp(p_sr_item->p_service_rec->service_name,
 			   p_svcr->service_record.service_name,
 			   sizeof(p_svcr->service_record.service_name)) != 0)
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_0) == IB_SR_COMPMASK_SDATA8_0) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_0) {
 		if (p_sr_item->p_service_rec->service_data8[0] !=
 		    p_svcr->service_record.service_data8[0])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_1) == IB_SR_COMPMASK_SDATA8_1) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_1) {
 		if (p_sr_item->p_service_rec->service_data8[1] !=
 		    p_svcr->service_record.service_data8[1])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_2) == IB_SR_COMPMASK_SDATA8_2) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_2) {
 		if (p_sr_item->p_service_rec->service_data8[2] !=
 		    p_svcr->service_record.service_data8[2])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_3) == IB_SR_COMPMASK_SDATA8_3) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_3) {
 		if (p_sr_item->p_service_rec->service_data8[3] !=
 		    p_svcr->service_record.service_data8[3])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_4) == IB_SR_COMPMASK_SDATA8_4) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_4) {
 		if (p_sr_item->p_service_rec->service_data8[4] !=
 		    p_svcr->service_record.service_data8[4])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_5) == IB_SR_COMPMASK_SDATA8_5) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_5) {
 		if (p_sr_item->p_service_rec->service_data8[5] !=
 		    p_svcr->service_record.service_data8[5])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_6) == IB_SR_COMPMASK_SDATA8_6) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_6) {
 		if (p_sr_item->p_service_rec->service_data8[6] !=
 		    p_svcr->service_record.service_data8[6])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_7) == IB_SR_COMPMASK_SDATA8_7) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_7) {
 		if (p_sr_item->p_service_rec->service_data8[7] !=
 		    p_svcr->service_record.service_data8[7])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_8) == IB_SR_COMPMASK_SDATA8_8) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_8) {
 		if (p_sr_item->p_service_rec->service_data8[8] !=
 		    p_svcr->service_record.service_data8[8])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_9) == IB_SR_COMPMASK_SDATA8_9) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_9) {
 		if (p_sr_item->p_service_rec->service_data8[9] !=
 		    p_svcr->service_record.service_data8[9])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_10) == IB_SR_COMPMASK_SDATA8_10) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_10) {
 		if (p_sr_item->p_service_rec->service_data8[10] !=
 		    p_svcr->service_record.service_data8[10])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_11) == IB_SR_COMPMASK_SDATA8_11) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_11) {
 		if (p_sr_item->p_service_rec->service_data8[11] !=
 		    p_svcr->service_record.service_data8[11])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_12) == IB_SR_COMPMASK_SDATA8_12) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_12) {
 		if (p_sr_item->p_service_rec->service_data8[12] !=
 		    p_svcr->service_record.service_data8[12])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_13) == IB_SR_COMPMASK_SDATA8_13) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_13) {
 		if (p_sr_item->p_service_rec->service_data8[13] !=
 		    p_svcr->service_record.service_data8[13])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_14) == IB_SR_COMPMASK_SDATA8_14) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_14) {
 		if (p_sr_item->p_service_rec->service_data8[14] !=
 		    p_svcr->service_record.service_data8[14])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA8_15) == IB_SR_COMPMASK_SDATA8_15) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA8_15) {
 		if (p_sr_item->p_service_rec->service_data8[15] !=
 		    p_svcr->service_record.service_data8[15])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_0) == IB_SR_COMPMASK_SDATA16_0) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_0) {
 		if (p_sr_item->p_service_rec->service_data16[0] !=
 		    p_svcr->service_record.service_data16[0])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_1) == IB_SR_COMPMASK_SDATA16_1) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_1) {
 		if (p_sr_item->p_service_rec->service_data16[1] !=
 		    p_svcr->service_record.service_data16[1])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_2) == IB_SR_COMPMASK_SDATA16_2) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_2) {
 		if (p_sr_item->p_service_rec->service_data16[2] !=
 		    p_svcr->service_record.service_data16[2])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_3) == IB_SR_COMPMASK_SDATA16_3) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_3) {
 		if (p_sr_item->p_service_rec->service_data16[3] !=
 		    p_svcr->service_record.service_data16[3])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_4) == IB_SR_COMPMASK_SDATA16_4) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_4) {
 		if (p_sr_item->p_service_rec->service_data16[4] !=
 		    p_svcr->service_record.service_data16[4])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_5) == IB_SR_COMPMASK_SDATA16_5) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_5) {
 		if (p_sr_item->p_service_rec->service_data16[5] !=
 		    p_svcr->service_record.service_data16[5])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_6) == IB_SR_COMPMASK_SDATA16_6) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_6) {
 		if (p_sr_item->p_service_rec->service_data16[6] !=
 		    p_svcr->service_record.service_data16[6])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA16_7) == IB_SR_COMPMASK_SDATA16_7) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA16_7) {
 		if (p_sr_item->p_service_rec->service_data16[7] !=
 		    p_svcr->service_record.service_data16[7])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA32_0) == IB_SR_COMPMASK_SDATA32_0) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA32_0) {
 		if (p_sr_item->p_service_rec->service_data32[0] !=
 		    p_svcr->service_record.service_data32[0])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA32_1) == IB_SR_COMPMASK_SDATA32_1) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA32_1) {
 		if (p_sr_item->p_service_rec->service_data32[1] !=
 		    p_svcr->service_record.service_data32[1])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA32_2) == IB_SR_COMPMASK_SDATA32_2) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA32_2) {
 		if (p_sr_item->p_service_rec->service_data32[2] !=
 		    p_svcr->service_record.service_data32[2])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA32_3) == IB_SR_COMPMASK_SDATA32_3) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA32_3) {
 		if (p_sr_item->p_service_rec->service_data32[3] !=
 		    p_svcr->service_record.service_data32[3])
 			return;
 	}

-	if ((comp_mask & IB_SR_COMPMASK_SDATA64_0) == IB_SR_COMPMASK_SDATA64_0) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA64_0) {
 		if (p_sr_item->p_service_rec->service_data64[0] !=
 		    p_svcr->service_record.service_data64[0])
 			return;
 	}
-	if ((comp_mask & IB_SR_COMPMASK_SDATA64_1) == IB_SR_COMPMASK_SDATA64_1) {
+	if (comp_mask & IB_SR_COMPMASK_SDATA64_1) {
 		if (p_sr_item->p_service_rec->service_data64[1] !=
 		    p_svcr->service_record.service_data64[1])
 			return;
@@ -528,9 +528,8 @@ static void sr_rcv_process_set_method(osm_sa_t * sa,
IN osm_madw_t * p_madw)
 		goto Exit;
 	}

-	/* if we were not provided with a service lease make it
-	   infinite */
-	if ((comp_mask & IB_SR_COMPMASK_SLEASE) != IB_SR_COMPMASK_SLEASE) {
+	/* if we were not provided with a service lease make it infinite */
+	if (!(comp_mask & IB_SR_COMPMASK_SLEASE)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"ServiceLease Component Mask not set - using infinite lease\n");
 		p_recvd_service_rec->service_lease = 0xFFFFFFFF;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
