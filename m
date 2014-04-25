From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] libvendor/osm_vendor_ibumad.c: Support GRH (for GS
 classes)
Date: Thu, 24 Apr 2014 22:37:42 -0400
Message-ID: <5359CA76.6040508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


If GRH is in incoming GS class management packet, convert umad GRH
information to OpenSM GRH information. On outgoing side, convert
OpenSM GRH information into umad GRH information.

Note that only base port 0 (GID index 0) is supported.

This is mainly for SA although other GS classes could use it (but don't).

Note also that SA reports with GRH is not handled by this patch.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index f9d3036..e9651f6 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -261,9 +261,20 @@ ib_mad_addr_conv(ib_user_mad_t * umad, osm_mad_addr_t * osm_mad_addr,
 	osm_mad_addr->addr_type.gsi.remote_qkey = ib_mad_addr->qkey;
 	osm_mad_addr->addr_type.gsi.pkey_ix = umad_get_pkey(umad);
 	osm_mad_addr->addr_type.gsi.service_level = ib_mad_addr->sl;
-	osm_mad_addr->addr_type.gsi.global_route = 0;	/* FIXME: handle GRH */
-	memset(&osm_mad_addr->addr_type.gsi.grh_info, 0,
-	       sizeof osm_mad_addr->addr_type.gsi.grh_info);
+	if (ib_mad_addr->grh_present) {
+		osm_mad_addr->addr_type.gsi.global_route = 1;
+		osm_mad_addr->addr_type.gsi.grh_info.hop_limit = ib_mad_addr->hop_limit;
+		osm_mad_addr->addr_type.gsi.grh_info.ver_class_flow =
+			ib_grh_set_ver_class_flow(6,	/* GRH version */
+						  ib_mad_addr->traffic_class,
+						  ib_mad_addr->flow_label);
+		memcpy(&osm_mad_addr->addr_type.gsi.grh_info.dest_gid,
+		       &ib_mad_addr->gid, 16);
+	} else {
+		osm_mad_addr->addr_type.gsi.global_route = 0;
+		memset(&osm_mad_addr->addr_type.gsi.grh_info, 0,
+		       sizeof osm_mad_addr->addr_type.gsi.grh_info);
+	}
 }
 
 static void *swap_mad_bufs(osm_madw_t * p_madw, void *umad)
@@ -290,6 +301,7 @@ static void *umad_receiver(void *p_ptr)
 	osm_mad_addr_t osm_addr;
 	osm_madw_t *p_madw, *p_req_madw;
 	ib_mad_t *p_mad, *p_req_mad;
+	ib_mad_addr_t *p_mad_addr;
 	void *umad = 0;
 	int mad_agent, length;
 
@@ -342,6 +354,14 @@ static void *umad_receiver(void *p_ptr)
 		}
 
 		p_mad = (ib_mad_t *) umad_get_mad(umad);
+		p_mad_addr = umad_get_mad_addr(umad);
+		/* Only support GID index 0 currently */
+		if (p_mad_addr->grh_present && p_mad_addr->gid_index) {
+			OSM_LOG(p_ur->p_log, OSM_LOG_ERROR, "ERR 5409: "
+				"GRH received on GID index %d for mgmt class 0x%x\n",
+				p_mad_addr->gid_index, p_mad->mgmt_class);
+			continue;
+		}
 
 		ib_mad_addr_conv(umad, &osm_addr,
 				 p_mad->mgmt_class == IB_MCLASS_SUBN_LID ||
@@ -1070,6 +1090,7 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 	osm_mad_addr_t *const p_mad_addr = osm_madw_get_mad_addr_ptr(p_madw);
 	ib_mad_t *const p_mad = osm_madw_get_mad_ptr(p_madw);
 	ib_sa_mad_t *const p_sa = (ib_sa_mad_t *) p_mad;
+	ib_mad_addr_t mad_addr;
 	int ret = -1;
 	int __attribute__((__unused__)) is_rmpp = 0;
 	uint32_t sent_mad_size;
@@ -1098,7 +1119,17 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 			  p_mad_addr->addr_type.gsi.remote_qp,
 			  p_mad_addr->addr_type.gsi.service_level,
 			  IB_QP1_WELL_KNOWN_Q_KEY);
-	umad_set_grh(p_vw->umad, NULL);	/* FIXME: GRH support */
+	if (p_mad_addr->addr_type.gsi.global_route) {
+		mad_addr.grh_present = 1;
+		mad_addr.gid_index = 0;
+		mad_addr.hop_limit = p_mad_addr->addr_type.gsi.grh_info.hop_limit;
+		ib_grh_get_ver_class_flow(p_mad_addr->addr_type.gsi.grh_info.ver_class_flow,
+					  NULL, &mad_addr.traffic_class,
+					  &mad_addr.flow_label);
+		memcpy(&mad_addr.gid, &p_mad_addr->addr_type.gsi.grh_info.dest_gid, 16);
+		umad_set_grh(p_vw->umad, &mad_addr);
+	} else
+		umad_set_grh(p_vw->umad, NULL);
 	umad_set_pkey(p_vw->umad, p_mad_addr->addr_type.gsi.pkey_ix);
 	if (ib_class_is_rmpp(p_mad->mgmt_class)) {	/* RMPP GS classes     FIXME: no GRH */
 		if (!ib_rmpp_is_flag_set((ib_rmpp_mad_t *) p_sa,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
